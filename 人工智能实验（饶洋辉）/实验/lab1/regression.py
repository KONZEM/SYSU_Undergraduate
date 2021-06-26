import numpy as np
import pandas as pd
import copy
from matplotlib import pyplot as plt


TRAIN_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab1 数据处理与KNN\\lab1_data\\regression_dataset\\train_set.csv'
TEST_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab1 数据处理与KNN\\lab1_data\\regression_dataset\\test_set.csv'
VALIDATION_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab1 数据处理与KNN\\lab1_data\\regression_dataset\\' \
                  u'validation_set.csv'
VOCABULARY = []
ARTICLE_NUM = 0
MOOD = ['anger', 'disgust', 'fear', 'joy', 'sad', 'surprise']


def get_vocabulary(path):
    global VOCABULARY
    global ARTICLE_NUM
    f = open(path, 'r')
    lines = f.readlines()
    for line in lines[1:]:
        ARTICLE_NUM += 1
        value = line.split(',')
        words = value[0].split()
        for word in words:
            if word.lower() not in VOCABULARY:
                VOCABULARY.append(word.lower())
    print('The vocabulary has {:d} words'.format(len(VOCABULARY)))
    print(VOCABULARY)
    print()


def generate_matrix(path):
    matrix = []

    f = open(path, 'r')
    lines = f.readlines()
    for line in lines[1:]:
        rec = [0 for i in range(len(VOCABULARY) + len(MOOD))]
        value = line.split(',')
        words = value[0].split()
        for word in words:
            rec[VOCABULARY.index(word.lower())] = 1
        for i in range(len(MOOD)):
            rec[len(VOCABULARY) + i] = float(value[1 + i])
        matrix.append(rec)

    return np.array(matrix)


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
            record[word.lower()] = 0
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


def prediction(matrix, tf_idf_train, tf_idf_validation, path, k, istest, choice):
    '''
    :param matrix: 训练集的one_hot
    :param tf_idf_train: 训练集的tf_idf矩阵
    :param tf_idf_validation: 测试机的tf_idf矩阵
    :param path: 测试集的路径
    :param k: 取k相似
    :param istest: 输入的是预测集集还是验证集
    :return: 返回预测值
    '''
    res = []

    f = open(path, 'r')
    lines = f.readlines()
    j = 0
    for line in lines[1:]:
        one_hot = [0 for i in range(len(VOCABULARY))]
        rank = [0 for i in range(len(matrix))]
        # 制作测试集的one_hot
        value = line.split(',')
        if istest:
            words = value[1].split()
        else:
            words = value[0].split()
        for word in words:
            if word.lower() in VOCABULARY:
                one_hot[VOCABULARY.index(word.lower())] = 1
        one_hot = np.array(one_hot) + 0.001         #防止为0
        # 计算与训练集的距离
        for i in range(len(matrix)):
            if choice == 0:
                rank[i] = np.sqrt(np.sum(np.square(one_hot, matrix[i][:len(VOCABULARY)])))
            else:
                if np.sum(tf_idf_validation[j]) != 0:
                    rank[i] = 1 - (np.dot(one_hot * tf_idf_validation[j], matrix[i][:len(VOCABULARY)] * tf_idf_train[i]) /
                                   (np.linalg.norm(one_hot * tf_idf_validation[j]) * np.linalg.norm(matrix[i][:len(VOCABULARY)] * tf_idf_train[i])))
                else:
                    rank[i] = 1 - (np.dot(one_hot, matrix[i][:len(VOCABULARY)] * tf_idf_train[i]) /
                                   (np.linalg.norm(one_hot) * np.linalg.norm(matrix[i][:len(VOCABULARY)] * tf_idf_train[i])))
        # 排序后找k个最相似的
        top_k = np.argsort(np.array(rank))[0: k]
        tmp = [0 for i in range(len(MOOD))]
        for index in top_k:
            train_mood = matrix[index][len(VOCABULARY): len(VOCABULARY)+len(MOOD)]
            for i in range(len(MOOD)):
                tmp[i] += train_mood[i] / (0.001 + rank[index])     # 加权
        # 处理后概率相加为1
        s = sum(tmp)
        for i in range(len(MOOD)):
            tmp[i] /= s
        res.append(tmp)
        j += 1
    return res


def cal_correl(res, path):
    '''
    :param res: 预测值矩阵
    :param path: 验证集的路径
    :return: 相关系数
    '''
    correlation_coefficient = []

    f = open(path, 'r')
    lines = f.readlines()
    for l in range(0, len(lines[1:])):
        answer = [0 for i in range(len(MOOD))]
        value = lines[l+1].split(',')
        for i in range(len(MOOD)):
            answer[i] = float(value[1 + i])         # 准确答案
        # answer = pd.Series(answer)
        # per_res = pd.Series(res[l])
        #correlation_coefficient.append(answer.corr(per_res))
        per_res = res[l]
        corr = np.mean((answer - np.mean(answer)) * (per_res - np.mean(per_res))) / np.sqrt(np.var(answer) * np.var(per_res))
        correlation_coefficient.append(corr)
        # 相关系数的公式
    print('预测结果如下：')
    print('预测前10条所得到的结果与准确结果的相关系数：')
    for i in range(10):
        print(i, '{:%}'.format(correlation_coefficient[i]))
    return np.mean(correlation_coefficient)

'''
if __name__ == '__main__':
    get_vocabulary(TRAIN_PATH)
    matrix = generate_matrix(TRAIN_PATH)
    tf_idf_train = generate_tf_idf(TRAIN_PATH, False)
    tf_idf_validation = generate_tf_idf(VALIDATION_PATH, False)
'''
'''
    res = prediction(matrix, tf_idf_train, tf_idf_validation, VALIDATION_PATH, 4, False, 1)
    corr = cal_correl(res, VALIDATION_PATH)
    print('平均相关系数如下：')
    print('{:%}'.format(corr))
'''
'''
    trade = []
    for k in range(1, 25):
        res = prediction(matrix, tf_idf_train,  tf_idf_validation, VALIDATION_PATH, k, False, 1)
        corr = cal_correl(res, VALIDATION_PATH)
        trade.append(corr)
        print(corr)
        print()
    x = range(1, 25)
    plt.xlabel('the value of k')
    plt.ylabel('correlation coefficient')
    plt.plot(x, trade, label='cosine + tf_idf')

    trade1 = []
    for k in range(1, 25):
        res = prediction(matrix, tf_idf_train,  tf_idf_validation, VALIDATION_PATH, k, False, 0)
        corr = cal_correl(res, VALIDATION_PATH)
        trade1.append(corr)
        print(corr)
        print()
    plt.plot(x, trade1, label='Euclidean distance')
    plt.legend()
    plt.show()

'''
# 写测试集
if __name__ == '__main__':
    get_vocabulary(TRAIN_PATH)
    matrix = generate_matrix(TRAIN_PATH)
    tf_idf_train = generate_tf_idf(TRAIN_PATH, False)
    tf_idf_test = generate_tf_idf(TEST_PATH, True)
    res = prediction(matrix, tf_idf_train, tf_idf_test, TEST_PATH, 4, True, 0)
    res = np.array(res)
    data = {'textid': range(1, len(res)+1), 'anger': res[:, 0], 'disgust': res[:, 1],
            'fear': res[:, 2], 'joy': res[:, 3], 'sad': res[:, 4], 'surprise': res[:, 5]}
    data = pd.DataFrame(data)
    print(data)
    data.to_csv('17341213_ZhengKangze_KNN_regression.csv', index=0, line_terminator='\n')


'''
1 0.383078202513441

2 0.44692112996380523

3 0.4744197481961383

4 0.4853671783032898

5 0.47292645685381096

6 0.47705192076667197

7 0.48279711396085095

8 0.4764187212556627

9 0.47746639755338977

10 0.474167887789721

11 0.46116661788306884

12 0.45351762575363047

13 0.44605375219780513

14 0.4419592690664931

15 0.4389159549906084

16 0.4371200709263598

17 0.43278627645528006

18 0.43191465974655624

19 0.4312669032733882

20 0.4318791259261148

21 0.4317047270925269

22 0.4311469426853032

23 0.4261055910143873

24 0.4291932846221303

'''
