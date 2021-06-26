import numpy as np
import copy
import pandas as pd
from matplotlib import pyplot as plt


TRAIN_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab1 数据处理与KNN\\lab1_data\\classification_dataset\\train_set.csv'
TEST_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab1 数据处理与KNN\\lab1_data\\classification_dataset\\test_set.csv'
VALIDATION_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab1 数据处理与KNN\\lab1_data\\classification_dataset\\' \
                  u'validation_set.csv'
VOCABULARY = []
ARTICLE_NUM = 0


def get_vocabulary(path):
    global ARTICLE_NUM
    global VOCABULARY
    f = open(path, 'r')
    lines = f.readlines()
    for line in lines[1:]:
        ARTICLE_NUM += 1
        value = line.split(',')
        words = value[0].split(' ')
        for word in words:
            if word.lower() not in VOCABULARY:
                VOCABULARY.append(word.lower())
    # print(VOCABULARY)
    # print()
    print('The vocabulary has {:d} words'.format(len(VOCABULARY)))
    print()


def generate_tf_idf(path, istest):
    tf_idf = []
    record = {}
    tf = []
    idf = {}

    # 创建统计表
    for word in VOCABULARY:
        record[word] = 0
        idf[word] = 0

    # 创建tf和idf
    f = open(path, 'r')
    lines = f.readlines()
    for line in lines[1:]:
        value = line.split(',')
        if istest:
            words = value[1].split()
        else:
            words = value[0].split()
        for word in words:
            if word.lower() in VOCABULARY and record[word.lower()] == 0:
                idf[word.lower()] += 1
                record[word.lower()] += 1
        for word in words:
            if word.lower() in VOCABULARY:
                record[word.lower()] /= float(len(words))
        tf.append(copy.deepcopy(record))
        for word in VOCABULARY:
            record[word] = 0
    f.close()
    for word in VOCABULARY:
        idf[word] = np.log10(ARTICLE_NUM / (0.1 + idf[word]))

    # 创建tf_idf
    for rec in tf:
        tmp = []
        for word in VOCABULARY:
            tmp.append(rec[word] * idf[word])
        tf_idf.append(tmp)
    return np.array(tf_idf)


def generate_matrix(path):
    matrix = []
    label = []

    f = open(path, 'r')
    lines = f.readlines()
    for line in lines[1:]:
        # record = [0 for i in range(len(VOCABULARY) + 1)]    # 零列表
        record = [0 for i in range(len(VOCABULARY))]  # 零列表
        value = line.split(',')
        words = value[0].split()
        for word in words:
            record[VOCABULARY.index(word.lower())] = 1      # 出现就置一
        label.append(value[1].split()[0])
        matrix.append(record)                               # 加入一行的one_hot

    return np.array(matrix), label


def predict(sentence, matrix, label, k, tf_idf_train, tf_idf_validation, choice):
    '''
    :param sentence: 预测文本
    :param matrix: 训练集的one_hot
    :param label: 训练集的标签
    :param k: 取k个最相似
    :param tf_idf_train: 训练集的tf_idf矩阵
    :param tf_idf_validation: 测试集tf_idf向量（就是对应的那一条行）
    :return: 预测值
    '''
    record = [0 for i in range(len(VOCABULARY))]
    rank = [0 for i in range(len(matrix))]
    prediction = {}
    # 制作测试集的ont_hot
    words = sentence.split()
    for word in words:
        if word.lower() in VOCABULARY:
            record[VOCABULARY.index(word.lower())] = 1
    record = np.array(record)
    # 特殊情况
    if np.linalg.norm(record) == 0:
        return 'joy'
    # 与训练集求距离
    for i in range(len(matrix)):
        if choice == 0:
            rank[i] = np.sqrt(np.sum(np.square(record - matrix[i])))
        else:
            rank[i] = np.dot(record * tf_idf_validation, tf_idf_train[i] * matrix[i]) / (
                   np.linalg.norm(record * tf_idf_validation) * np.linalg.norm(tf_idf_train[i] * matrix[i]))
    # 取k个最相似的
    rank = np.array(rank)
    # rank = (rank - np.mean(rank)) / (max(rank) - min(rank))
    if choice == 0:
        top_k = np.argsort(rank)[0: k]
    else:
        top_k = np.argsort(-rank)[0: k]
    for index in top_k:
        # key = matrix[index][-1]
        key = label[index]
        if key not in prediction.keys():
            if choice == 0:
                prediction[key] = 1.0 / (0.001 + rank[index])
            else:
                prediction[key] = 1.0 * rank[index]         # 加权
        else:
            if choice == 0:
                prediction[key] += 1.0 / (0.001 + rank[index])
            else:
                prediction[key] += 1.0 * rank[index]        # 加权
    # 排序找最可能的
    prediction = sorted(prediction.items(), key=lambda x: x[1], reverse=True)
    # print(prediction)
    # print()
    return prediction[0][0]

'''
if __name__ == '__main__':
    get_vocabulary(TRAIN_PATH)
    print(VOCABULARY)
    print()
    tf_idf_train = generate_tf_idf(TRAIN_PATH, False)
    tf_idf_validation = generate_tf_idf(VALIDATION_PATH, False)
    matrix, label = generate_matrix(TRAIN_PATH)
    total_num = 0
    correct_num = 0
'''
'''
    res = {'anger': 0, 'disgust': 0, 'fear': 0, 'joy': 0, 'sad': 0, 'surprise': 0}
    f = open(VALIDATION_PATH, 'r')
    lines = f.readlines()
    j = 0
    for line in lines[1:]:
        total_num += 1
        value = line.split(',')
        prediction = predict(value[0], matrix, label, 20, tf_idf_train, tf_idf_validation[j])
        if prediction == value[1].split()[0]:
            correct_num += 1
        res[prediction] += 1
        j += 1
    print('预测结果分布如下：')
    for mood, num in res.items():
        print(mood + ':', num)
    print('准确率如下：')
    print('{:%}'.format(float(correct_num) / float(total_num)))
'''
'''
    res = []
    for i in range(1, 30):
        f = open(VALIDATION_PATH, 'r')
        lines = f.readlines()
        j = 0
        for line in lines[1:]:
            total_num += 1
            value = line.split(',')
            prediction = predict(value[0], matrix, label, i, tf_idf_train, tf_idf_validation[j], 0)
            if prediction == value[1].split()[0]:
                correct_num += 1
            j += 1
        print(i, 'accuracy: {:f}'.format(float(correct_num) / float(total_num)))
        res.append(float(correct_num) / float(total_num))
        f.close()
    x = range(1, 30)
    plt.xlabel('the value of k')
    plt.ylabel('accuracy')
    plt.plot(x, res, label='Euclidean distance')


    correct_num = 0
    total_num = 0
    res1 = []
    for i in range(1, 30):
        f = open(VALIDATION_PATH, 'r')
        lines = f.readlines()
        j = 0
        for line in lines[1:]:
            total_num += 1
            value = line.split(',')
            prediction = predict(value[0], matrix, label, i, tf_idf_train, tf_idf_validation[j], 1)
            if prediction == value[1].split()[0]:
                correct_num += 1
            j += 1
        print(i, 'accuracy: {:f}'.format(float(correct_num) / float(total_num)))
        res1.append(float(correct_num) / float(total_num))
        f.close()
    plt.plot(x, res1, label='cosine + tf_idf')
    plt.legend()
    plt.show()
'''
# 写测试集
if __name__ == '__main__':
    get_vocabulary(TRAIN_PATH)
    tf_idf_train = generate_tf_idf(TRAIN_PATH, False)
    tf_idf_test = generate_tf_idf(TEST_PATH, True)
    matrix, label = generate_matrix(TRAIN_PATH)
    prediction = []

    f = open(TEST_PATH, 'r')
    lines = f.readlines()
    j = 0
    for line in lines[1:]:
        value = line.split(',')
        prediction.append(predict(value[1], matrix, label, 20, tf_idf_train, tf_idf_test[j], 1))
        j += 1
    f.close()

    data = {'textid': range(1, len(prediction)+1), 'label': prediction}
    data = pd.DataFrame(data)
    data.to_csv('17341213_ZhengKangze_KNN_classification.csv', index=0, line_terminator='\n')

