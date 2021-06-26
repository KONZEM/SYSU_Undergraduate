from nltk import ngrams
import jieba
# import pynlpir
import re

FileName = './train_data/{:d}.txt'
Table_Path = './train_data/word_table.txt'
StopWord_Path = 'stopword.txt'
Dict_Up_Path = './train_data/dict1.txt'
Dict_Down_Path = './train_data/dict2.txt'
Text_Num = 1000
Word_Num = 44229
N = 2

Dict_for_Up = dict()
Dict_for_Down = dict()
Word_Table = []
Stop_Word = []
Answer = []

Test_Path = './test_data/questions.txt'
Answer_Path = './test_data/answer.txt'


def get_table_dict():
    print('Load word table and dictionaries...')
    # Word_Table
    with open(Table_Path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.split()
            word = line[1]
            # print(word, len(word))
            Word_Table.append(word)
    # # Dict_for_Up
    # with open(Dict_Up_Path, 'r', encoding='utf-8') as f:
    #     for line in f:
    #         line = line.split()
    #         words = tuple(line[:N])
    #         num = int(line[N])
    #         Dict_for_Up[words] = num
    # # print(Dict_for_Up)
    # # Dict_for_Down
    # with open(Dict_Down_Path, 'r', encoding='utf-8') as f:
    #     for line in f:
    #         line = line.split()
    #         words = tuple(line[:N - 1])
    #         num = int(line[N - 1])
    #         Dict_for_Down[words] = num
    # # print(Dict_for_Down)
    # print('Finish loading...')


def count():
    for i in range(1, Text_Num + 1):
        with open(FileName.format(i), 'r', encoding='utf-8') as f:
            # 读取每个文件内容
            lines = f.readlines()
            for line in lines:
                # 添加<BOS>和<EOS>
                line = '<BOS> ' + line + ' <EOS>'

                # 以n-gram形式分割
                res = ngrams(line.split(), N)

                for each in res:
                    # 公式中的分子
                    if each in Dict_for_Up.keys():
                        Dict_for_Up[each] += 1
                    else:
                        Dict_for_Up[each] = 1

                    # 公式中的分母
                    if each[:N - 1] in Dict_for_Down.keys():
                        Dict_for_Down[each[:N - 1]] += 1
                    else:
                        Dict_for_Down[each[:N - 1]] = 1
        print('Finish {:d}...'.format(i))

    # 写入文件
    with open(Dict_Up_Path, 'w', encoding='utf-8') as f:
        for key, value in Dict_for_Up.items():
            f.write(' '.join(key) + ' ' + str(value) + '\n')
    print('Finish writing Dict_for_Up...')

    with open(Dict_Down_Path, 'w', encoding='utf-8') as f:
        for key, value in Dict_for_Down.items():
            f.write(' '.join(key) + ' ' + str(value) + '\n')
    print('Finish writing Dict_for_Down...')


def predict():
    # 添加词语，使jieba能够正常分词
    jieba.add_word('[MASK]')
    # 记录预测对的个数
    accuracy = 0
    # 记录预测的答案e
    prediction = []

    with open(Test_Path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        # 正确答案在AnswerR里的索引
        index = 0
        for line in lines:
            # 记录词语对应的概率
            word_prob = dict()
            # print(line)

            # 分词
            sentence = jieba.lcut(line)
            mask_pos = sentence.index('MASK')

            # 去非中文、去停止词
            for i in range(len(sentence)):
                # 跳过MASK
                if i == mask_pos:
                    continue
                sentence[i] = re.sub('[^\u4e00-\u9fa5]', '', sentence[i])
            while '' in sentence:
                sentence.remove('')
            sentence = [_word for _word in sentence if _word not in Stop_Word]

            # n-gram预测
            sentence.insert(0, '<BOS>')
            sentence.append('<EOS>')
            mask_pos = sentence.index('MASK')
            for word in Word_Table:
                prob = 1.0
                # 将词语代入到MASK
                sentence[mask_pos] = word
                for i in range(N):
                    # 保证窗口不会越界
                    if mask_pos-N+i+1 > -1 and mask_pos+i < len(sentence):
                        up = tuple(sentence[mask_pos-N+i+1: mask_pos+i+1])
                        down = tuple(sentence[mask_pos-N+i+1: mask_pos+i])
                        # 分子值
                        if up in Dict_for_Up.keys():
                            up_num = float(Dict_for_Up[up] + 1)
                        else:
                            up_num = 1.0
                        # 分母值
                        if down in Dict_for_Down.keys():
                            down_num = float(Dict_for_Down[down] + Word_Num)
                        else:
                            down_num = float(Word_Num)
                        prob *= up_num / down_num
                word_prob[word] = prob

            # 排序、取概率值最高的作为答案
            word_prob = sorted(word_prob.items(), key=lambda x: x[1], reverse=True)
            prediction.append(word_prob[0][0])

            # 预测正确
            if Answer[index] == word_prob[0][0]:
                print('answer:', Answer[index])
                # print()
                accuracy += 1

            index += 1

    # 将预测答案写入文件
    prediction = '\n'.join(prediction)
    with open('./test_data/n-gram_prediction.txt', 'w', encoding='utf8') as f:
        f.write(prediction)

    print('accuracy: {:.2%}'.format(float(accuracy) / float(len(Answer))))


if __name__ == '__main__':
    count()
    # 加载停止词
    with open(StopWord_Path, 'r', encoding='utf-8') as f:
        for line in f:
            Stop_Word.append(line.strip())
    # 加载答案
    with open(Answer_Path, 'r', encoding='utf-8') as f:
        for line in f:
            Answer.append(line.split()[0])
    get_table_dict()
    predict()
