import numpy as np
import copy

READ_PATH = u'F:\software\人工智能\人工智能\实验\lab1 数据处理与KNN\lab1_data\semeval.txt'
SAVE_PATH = u'17341213_ZhengKangze_TFIDF.txt'


def generate(read_path, save_path):
    vocabulary = []
    record = {}
    tf = []
    idf = {}
    article_num = 0

    f = open(read_path, 'r')
    # 收集词汇和文章数量
    for line in f:
        article_num += 1
        value = line.split()
        # print(value[8:])
        for word in value[8:]:
            if word.lower() not in vocabulary:
                vocabulary.append(word.lower())
    # print(vocabulary)
    f.seek(0)

    # 创建统计表
    for word in vocabulary:
        record[word] = 0
        idf[word] = 0

    # 创建tf和idf
    for line in f:
        num = 0
        value = line.split()
        for word in value[8:]:
            num += 1
            if record[word.lower()] == 0:
                idf[word.lower()] += 1
            record[word.lower()] += 1
        for word in value[8:]:
            record[word.lower()] /= float(num)
        tf.append(copy.deepcopy(record))
        for word in value[8:]:
            record[word.lower()] = 0
    f.close()
    for word in vocabulary:
        idf[word] = np.log10(article_num / (1.0 + idf[word]))

    # 写文件
    f = open(save_path, 'w')
    for rec in tf:
        for word in vocabulary:
            f.write(str(rec[word] * idf[word]))
            f.write(' ')
        f.write('\n')
    f.close()


if __name__ == '__main__':
    generate(READ_PATH, SAVE_PATH)