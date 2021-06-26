#################
####训练及预测####
#################

import torch
import torch.nn as nn
import torch.optim as optim
from Net import *
import random
from nltk.translate.bleu_score import sentence_bleu
from matplotlib import pyplot as plt

# 读文件所需参数
Train_Path = ('./dataset/train_source.txt', './dataset/train_target.txt')
Test_Path = ('./dataset/test_source.txt', './dataset/test_target.txt')
Answer_Path = './dataset/answer.txt'
Source_Word2Num_Path = './dataset/source_word2num.txt'
Target_Word2Num_Path = './dataset/target_word2num.txt'
Source_Num2Word = {}
Source_Word2Num = {}
Target_Num2Word = {}
Target_Word2Num = {}
Source_Vocab_Size = 0
Target_Vocab_Size = 0

# 网络所需参数
Embedding_Dim = 128
NHidden = 256
Encoder_Learning_Rate = 1e-5
Decoder_Learning_Rate = 1e-5
Batch_Size = 20
Epochs = 100
Teacher_Force_Ratio = 0.6


def read_dict():
    '''
    读取源语言、目标语言字典
    '''
    global Source_Vocab_Size
    global Target_Vocab_Size
    global Source_Word2Num
    global Source_Num2Word
    global Target_Word2Num
    global Target_Num2Word

    for line in open(Source_Word2Num_Path, 'r', encoding='utf-8'):
        line = line.strip().split()
        # print(line)
        Source_Word2Num[line[0]] = int(line[1])
        Source_Num2Word[int(line[1])] = [line[0]]

    for line in open(Target_Word2Num_Path, 'r', encoding='utf-8'):
        line = line.strip().split()
        # print(line)
        Target_Word2Num[line[0]] = int(line[1])
        Target_Num2Word[int(line[1])] = [line[0]]

    Source_Vocab_Size = len(Source_Word2Num)
    Target_Vocab_Size = len(Target_Word2Num)


def sen2vec(text_path, word2num, padding=True):
    '''
    :param text_path: 文件路径
    :param word2num: 词语到数字的映射的字典
    :param padding: 是否padding
    :return: 句向量
    '''
    lines = open(text_path, 'r', encoding='utf-8').readlines()
    max_len = max([len(line.strip().split()) for line in lines])

    data = []
    for line in lines:
        line = line.strip().split()
        vec = []
        for word in line:
            if word in word2num.keys():
                vec.append(word2num[word])
            else:
                vec.append(word2num['<UNK>'])
        if padding:
            # 长度不足
            if len(vec) < max_len:
                vec += (max_len - len(vec)) * [word2num['<PAD>']]
        data.append(vec)
    return data


def test(test_source, test_target, num2word, beam_width):
    '''
    :param test_source: 预测集的源语言文本的向量表示
    :param test_target: 预测集的目标语言文本的向量表示
    :param num2word: 目标语言的数字到词语的映射的字典
    :param beam_width: 集束搜索的宽度
    :return:
    '''
    encoder = torch.load('encoder.pkl').cuda().eval()
    decoder = torch.load('decoder.pkl').cuda().eval()
    f = open(Answer_Path, 'w', encoding='utf-8')

    # 可能的答案及概率
    candidate_answer = [['<BOS>'] for i in range(beam_width)]
    candidate_prob = [[1] for i in range(beam_width)]

    for i in range(len(test_source)):
        one_test_source = torch.LongTensor(test_source[i]).unsqueeze(0).transpose(0, 1).cuda()
        one_test_target = torch.LongTensor(test_target[i]).unsqueeze(0).transpose(0, 1).cuda()

        # 编码器的整体输出，（编码器最后节点的输出h，编码器最后节点的细胞状态c）
        encoder_output, (encoder_h, encoder_c) = encoder(one_test_source)
        encoder_h = (encoder_h[0] + encoder_h[1]).unsqueeze(0)
        encoder_c = (encoder_c[0] + encoder_c[1]).unsqueeze(0)
        # 解码器的初始隐状态
        decoder_state = (encoder_h, encoder_c)

        # 限制长度为真实答案的长度
        for j in range(len(test_target[i]) - 1):
            # 第一个词语永远是<BOS>
            if not j:
                decoder_input = one_test_target[0].unsqueeze(0)
                decoder_output, decoder_state = decoder(decoder_input, encoder_output, decoder_state)
            # 第二次选择上次网络输出概率前beam_width大作为输入，也作为备选答案
            elif j == 1:
                probs, indices = torch.topk(decoder_output, beam_width)
                indices = indices.squeeze(0).transpose(0, 1)
                for k in range(beam_width):
                    candidate_answer[k] += num2word[indices[k][0].item()]
                    candidate_prob[k] += [probs[0][0][k].item()]
                decoder_output, decoder_state = decoder(indices, encoder_output, decoder_state)
            # 之后就取最大的作为答案
            else:
                probs, indices = torch.max(decoder_output, 2)
                for k in range(beam_width):
                    candidate_answer[k] += num2word[indices[k][0].item()]
                    candidate_prob[k] += [probs[k][0].item()]
                decoder_output, decoder_state = decoder(indices, encoder_output, decoder_state)

        # 选择概率和最大的作为答案
        answer_prob = 0
        answer = []
        for k in range(beam_width):
            total_pro = sum(candidate_prob[k])
            if total_pro > answer_prob:
                answer = candidate_answer[k]
                answer_prob = total_pro

        target = [num2word[index] for index in test_target[i]]
        # print(answer)
        # print(sentence_bleu(target, answer))
        # print()
        f.write(' '.join(answer) + '  bleu:' + str(sentence_bleu(target, answer)) + '\n')
    f.close()


if __name__ == '__main__':
    read_dict()
    train_source = sen2vec(Train_Path[0], Source_Word2Num)
    train_target = sen2vec(Train_Path[1], Target_Word2Num)
    test_source = sen2vec(Test_Path[0], Source_Word2Num, False)
    test_target = sen2vec(Test_Path[1], Target_Word2Num, False)

    encoder = Encoder(Source_Vocab_Size, Embedding_Dim, NHidden).cuda()
    decoder = Decoder(Target_Vocab_Size, Embedding_Dim, NHidden).cuda()

    # 优化器
    encoder_optimizer = optim.Adam(encoder.parameters(), lr=Encoder_Learning_Rate)
    decoder_optimizer = optim.Adam(decoder.parameters(), lr=Decoder_Learning_Rate)

    # 损失函数
    criterion = nn.CrossEntropyLoss()

    # 每个epoch的损失
    epochs_loss = []

    for i in range(Epochs):
        epoch_loss = 0
        start_read = 0
        end_of_epoch = False
        while not end_of_epoch:
            per_batch_loss = 0
            if (start_read + 1) * Batch_Size >= len(train_source):
                batch_train_source = train_source[start_read * Batch_Size:] + \
                                     train_source[: (start_read + 1) * Batch_Size - len(train_target)]
                batch_train_target = train_target[start_read * Batch_Size:] + \
                                     train_target[: (start_read + 1) * Batch_Size - len(train_target)]
                end_of_epoch = True
            else:
                batch_train_source = train_source[start_read * Batch_Size: (start_read + 1) * Batch_Size]
                batch_train_target = train_target[start_read * Batch_Size: (start_read + 1) * Batch_Size]
                start_read += 1

            # (seq_len, batch_size, 1)
            batch_train_source = torch.LongTensor(batch_train_source).transpose(0, 1).cuda()
            batch_train_target = torch.LongTensor(batch_train_target).transpose(0, 1).cuda()

            # 编码器的整体输出，（编码器最后节点的输出h，编码器最后节点的细胞状态c）
            encoder_output, (encoder_h, encoder_c) = encoder(batch_train_source)
            encoder_h = (encoder_h[0] + encoder_h[1]).unsqueeze(0)
            encoder_c = (encoder_c[0] + encoder_c[1]).unsqueeze(0)

            # 解码器的初始隐状态
            decoder_state = (encoder_h, encoder_c)

            for j in range(len(train_target[0]) - 1):
                # 不是第一次则随机
                if j:
                    # 输入正确答案
                    if random.random() < Teacher_Force_Ratio:
                        decoder_input = batch_train_target[j].unsqueeze(0)
                        decoder_output, decoder_state = decoder(decoder_input, encoder_output, decoder_state)
                    # 输入上一次输出
                    else:
                        _, decoder_input = torch.max(decoder_output, 2)
                        decoder_output, decoder_state = decoder(decoder_input, encoder_output, decoder_state)
                # 第一次只能是<BOS>
                else:
                    decoder_input = batch_train_target[j].unsqueeze(0)
                    decoder_output, decoder_state = decoder(decoder_input, encoder_output, decoder_state)
                # 交叉熵
                per_batch_loss += criterion(decoder_output.squeeze(), batch_train_target[j + 1])

            # 更新参数
            encoder_optimizer.zero_grad()
            decoder_optimizer.zero_grad()
            per_batch_loss.backward(retain_graph=True)
            encoder_optimizer.step()
            decoder_optimizer.step()
            # 叠加这次batch的损失
            epoch_loss += per_batch_loss.item() / len(train_target[0])

        # 记录这次epoch的损失
        epochs_loss.append(epoch_loss)

        # 每10个epoch保存模型
        if i % 10 == 0:
            torch.save(encoder, 'encoder.pkl')
            torch.save(decoder, 'decoder.pkl')
            # test(test_source, test_target, Target_Num2Word, 2)
        print('Epoch: ' + str(i))
        print('Loss: ', str(epoch_loss))

    plt.plot([i for i in range(1, Epochs + 1)], epochs_loss)
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.savefig('train_loss.png', format='png')