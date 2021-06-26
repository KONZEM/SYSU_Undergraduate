#################
### 数据预处理 ###
#################

import jieba
import os

# 训练数据的路径
Train_Path = ('./dataset_10000/train_source_8000.txt', './dataset_10000/train_target_8000.txt')
# 测试数据的路径
Test_Path = ('./dataset_10000/test_source_1000.txt', './dataset_10000/test_target_1000.txt')
# 分词后的训练数据的路径
New_Train_Path = ('./dataset/train_source.txt', './dataset/train_target.txt')
# 分词后的测试数据的路径
New_Test_Path = ('./dataset/test_source.txt', './dataset/test_target.txt')
# 源语言的词典（词到数字的映射）的路径
Source_Word2Num_Path = './dataset/source_word2num.txt'
# 目标语言的词典（词到数字的映射）的路径
Target_Word2Num_Path = './dataset/target_word2num.txt'
# 源语言的词典（词到数字的映射）
Source_Word2Num = {'<BOS>': 0, '<EOS>': 1, '<PAD>': 2, '<UNK>': 3}
# 目标语言的词典（词到数字的映射）
Target_Word2Num = {'<BOS>': 0, '<EOS>': 1, '<PAD>': 2, '<UNK>': 3}
max_length = 0  # 102, 96


def preprocess_train():
    '''
    将训练集中的源语言文本和目标语言文本分词，并为两种语言建立词典
    '''
    global max_length
    with open(New_Train_Path[0], 'w', encoding='utf-8') as f:
        lines = open(Train_Path[0], 'r', encoding='utf-8').readlines()
        for line in lines:
            # 统一小写
            line = line.lower().strip()
            # 分词
            words = jieba.lcut(line)
            # 去空格
            for i in range(len(words)):
                words[i] = words[i].strip()
            while '' in words:
                words.remove('')
            # 更新词典
            for word in words:
                if word not in Source_Word2Num.keys():
                    Source_Word2Num[word] = len(Source_Word2Num)
            # 写入分词结果
            sentence = '<BOS> ' + ' '.join(words) + ' <EOS>' + '\n'
            f.write(sentence)

    with open(New_Train_Path[1], 'w', encoding='utf-8') as f:
        lines = open(Train_Path[1], 'r', encoding='utf-8').readlines()
        for line in lines:
            # 统一小写
            line = line.lower().strip()
            # 分词
            words = jieba.lcut(line)
            # 去空格
            for i in range(len(words)):
                words[i] = words[i].strip()
            while '' in words:
                words.remove('')
            # max_length = max(len(words), max_length)
            # 更新词典
            for word in words:
                if word not in Target_Word2Num.keys():
                    Target_Word2Num[word] = len(Target_Word2Num)
            # 写入分词结果
            sentence = '<BOS> ' + ' '.join(words) + ' <EOS>' + '\n'
            f.write(sentence)
        # print(max_length)

    # 将源语言词典写进文件
    with open(Source_Word2Num_Path, 'w', encoding='utf-8') as f:
        for (key, value) in Source_Word2Num.items():
            f.write(key + ' ' + str(value) + '\n')
    # with open(Source_Num2Word_Path, 'w', encoding='utf-8') as f:
    #     for (key, value) in Source_Word2Num.items():
    #         f.write(str(value) + ' ' + key + '\n')

    # 将目标语言词典写进文件
    with open(Target_Word2Num_Path, 'w', encoding='utf-8') as f:
        for (key, value) in Target_Word2Num.items():
            f.write(key + ' ' + str(value) + '\n')
    # with open(Target_Num2Word_Path, 'w', encoding='utf-8') as f:
    #     for (key, value) in Target_Word2Num.items():
    #         f.write(str(value) + ' ' + key + '\n')


def preprocess_test():
    '''
    将测试集中的源语言文本和目标语言文本分词
    '''
    with open(New_Test_Path[0], 'w', encoding='utf-8') as f:
        lines = open(Test_Path[0], 'r', encoding='utf-8').readlines()
        for line in lines:
            # 统一小写
            line = line.lower().strip()
            # 分词
            words = jieba.lcut(line)
            # 去空格
            for i in range(len(words)):
                words[i] = words[i].strip()
            while '' in words:
                words.remove('')
            # 写入分词结果
            sentence = '<BOS> ' + ' '.join(words) + ' <EOS>' + '\n'
            f.write(sentence)

    with open(New_Test_Path[1], 'w', encoding='utf-8') as f:
        lines = open(Test_Path[1], 'r', encoding='utf-8').readlines()
        for line in lines:
            # 统一小写
            line = line.lower().strip()
            # 分词
            words = jieba.lcut(line)
            # 去空格
            for i in range(len(words)):
                words[i] = words[i].strip()
            while '' in words:
                words.remove('')
            # 写入分词结果
            sentence = '<BOS> ' + ' '.join(words) + ' <EOS>' + '\n'
            f.write(sentence)


if __name__ == '__main__':
    if not os.path.exists('dataset'):
        os.makedirs('dataset')
    preprocess_train()
    preprocess_test()
