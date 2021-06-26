import os
import jieba
# import pynlpir
import re

# Letters_and_Digits = [chr(ord('A')+i) for i in range(26)] + [chr(ord('a')+i) for i in range(26)]\
#           + [chr(ord('0')+i) for i in range(10)]
Path1 = './data/'
Path2 = './train_data/'
FileName = '{:d}.txt'
StopWord_Path = 'stopword.txt'
Table_Path = 'word_table.txt'
Num = 1001
Word_Table = set()
Stop_Word = []
# Split_Punctuation = [',', '.', '?', '!', ';', '；', '，', '？', '！', '。']
Split_Punctuation = [u'；', u'？', u'！', u'。', u'……']


def preprocess():
    for i in range(1, Num):
        # 读取原文
        lines = open(Path1 + FileName.format(i), 'r', encoding='utf-8').readlines()

        # 分词、去燥、写文件
        with open(Path2 + FileName.format(i), 'w', encoding='utf-8') as f:
            for line in lines:
                # 以；。？！……分句
                line = [line]
                for char in Split_Punctuation:
                    sentences = []              # 记录一行中的句子
                    for j in range(len(line)):
                        sentences += line[j].split(char)
                    line = sentences

                # 对句子先分词再去燥
                for sentence in sentences:
                    if sentence == '':
                        continue
                    # 分词
                    sentence = jieba.lcut(sentence)
                    # sentence = pynlpir.segment(sentence, pos_tagging=False)

                    # 去除非中文
                    for j in range(len(sentence)):
                        sentence[j] = re.sub('[^\u4e00-\u9fa5]', '', sentence[j])
                    while '' in sentence:
                        sentence.remove('')

                    # 去停止词
                    sentence = [word for word in sentence if word not in Stop_Word]

                    # 更新词表
                    Word_Table.update(sentence)

                    # 写文件
                    if len(sentence):
                        f.write(' '.join(sentence) + '\n')
        print('Finish {:d}...'.format(i))
        # with open(Path2 + FileName.format(i), 'w', encoding='utf-8') as f:
        #     for line in lines:
        #         # 保留中文
        #         line = re.sub('[^\u4e00-\u9fa5]', '', line)
        #         # 分词
        #         line = jieba.lcut(line)
        #         # 去停止词
        #         line = [word for word in line if word not in Stop_Word]
        #         # 更新词表
        #         Word_Table.update(line)
        #         # 以空格隔开分词结果
        #         line = ' '.join(line)
        #         # 写文件
        #         f.write(line + '\n')


def write_table():
    with open(Path2 + Table_Path, 'w', encoding='utf-8') as f:
        for i, word in enumerate(Word_Table):
            f.write(str(i) + ' ' + word + '\n')


if __name__ == '__main__':
    # 新建文件夹
    if not os.path.exists('train_data'):
        os.makedirs('train_data')
    # 加载停止词
    with open(StopWord_Path, 'r', encoding='utf-8') as f:
        for line in f:
            Stop_Word.append(line.strip())
    # 预处理
    # pynlpir.open()
    preprocess()
    write_table()
    # with open(Path1 + FileName.format(1), 'r', encoding='utf-8') as f:
    #     lines = f.readlines()
    #     for line in lines:
    #         print('original: ', line)
    #         line = [line]
    #         for char in Split_Punctuation:
    #             sentences = []
    #             for i in range(len(line)):
    #                 sentences += line[i].split(char)
    #             line = sentences
    #         print('every sentence: ', sentences)
    #         for sentence in sentences:
    #             if sentence == '':
    #                 continue
    #             sentence = jieba.lcut(sentence)
    #             for i in range(len(sentence)):
    #                 sentence[i] = re.sub('[^\u4e00-\u9fa5]', '', sentence[i])
    #             while '' in sentence:
    #                 sentence.remove('')
    #             if len(sentence):
    #                 print('every word: ', sentence)
    #         print()



