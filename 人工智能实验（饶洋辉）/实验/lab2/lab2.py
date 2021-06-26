# coding：UTF-8
import pandas as pd
import numpy as np
import math
import copy
from matplotlib import pyplot as plt

READ_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\Lab2 决策树\\lab2_dataset\\car_train.csv'
TRAIN_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\Lab2 决策树\\train.csv'
TEST_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\Lab2 决策树\\test.csv'
Attribute_VALUE = {'buying': ('vhigh', 'high', 'med', 'low'), 'maint': ('vhigh', 'high', 'med', 'low'),
                   'dorrs': ('2', '3', '4', '5more'), 'persons': ('2', '4', 'more'),
                   'lug_boot': ('small', 'med', 'big'), 'safety': ('low', 'med', 'high')}


def division(read_path, train_path, test_path, k):
    '''
    :param read_path: 数据集路径
    :param train_path: 训练集路径
    :param test_path: 测试集路径
    :param k: 划分数据集为k份，(k-1)/k为训练集，1/k为测试机
    :return: 无
    将数据集划分为训练集和测试集
    '''
    train_data = []
    test_data = []

    df = pd.read_csv(read_path)                 # 读文件
    columns = df.columns.values                 # 获取属性名
    df = np.array(df)
    np.random.shuffle(df)                       # 打乱顺序
    num = len(df)                               # 数据集大小
    for i in range(int(num / k)):               # 1/4为测试集
        test_data.append(df[i])
    for i in range(int(num / k), num):          # 3/4为训练集
        train_data.append(df[i])
    # 写入文件
    train_data = pd.DataFrame(train_data, columns=columns)
    test_data = pd.DataFrame(test_data, columns=columns)
    train_data.to_csv(train_path, index=0, line_terminator='\n')
    test_data.to_csv(test_path, index=0, line_terminator='\n')


def get_data(path):
    '''
    :param path: 要读的文件的路径
    :return: 数据集和特征集
    读出文件中的数据集以及特征集
    '''
    train_data = pd.read_csv(path)                  # 读文件
    features = list(train_data.columns.values)      # 特征
    train_data = np.array(train_data)               # 数据集
    return train_data, features


def cal_IG(data, features, feature):
    '''
    :param data: 数据集
    :param features: 特征集
    :param feature: 要计算信息增益的特征
    :return: 该特征的信息增益
    计算feature在data中的信息增益
    '''
    dic = {}                                    # 记录（特征值，标签）的次数
    feature_val = {}                            # 记录出现的特征值以及出现的次数
    label_val = []                              # 记录出现的标签
    num = len(data)
    IG = 0.0
    index = features.index(feature)             # 第index列是对应的特征值
    # 计算条件熵
    for row in data:
        tup = (row[index], row[-1])              # (特征值，标签)

        if tup[0] not in feature_val.keys():            # [特征值: 特征值出现的次数]
            feature_val[tup[0]] = 1
        else:
            feature_val[tup[0]] += 1

        if tup[1] not in label_val:              # 标签值
            label_val.append(tup[1])

        if tup not in dic.keys():               # (特征值, 标签值): [特征值次数. 对应标签次数]
            dic[tup] = [1, 1]
        else:
            dic[tup][0] += 1
            dic[tup][1] += 1
    for a, b in feature_val.items():            # a是特征值，b是出现的次数
        sum = 0.0
        for c in label_val:                     # c是标签
            if (a, c) in dic.keys():
                tmp = float(dic[(a, c)][1]) / float(b)
                if tmp != 0:
                    sum -= tmp * math.log(tmp)
        IG += float(b) / float(num) * float(sum)
    # 经验熵
    num_of_0_1 = [0.0, 0.0]
    for row in data:
        if row[-1] == 1:
            num_of_0_1[1] += 1                  # 1标签出现的次数
        elif row[-1] == 0:
            num_of_0_1[0] += 1                  # 0标签出现的次数
    num_of_0_1[0] /= float(num)
    num_of_0_1[1] /= float(num)
    IG = -IG
    for digit in num_of_0_1:
        if digit != 0:
            IG -= digit * math.log(digit)
    return IG


def cal_GR(data, features, feature):
    '''
    :param data: 数据集
    :param features: 特征集
    :param feature: 要计算信息增益率的特征
    :return: 该特征的信息增益率
    计算feature在data上的信息增益率
    '''
    IG = cal_IG(data, features, feature)                    # 获得信息增益
    feature_val = list(Attribute_VALUE[feature])            # 该特征所有的取值
    index = features.index(feature)                         # 该特征所在列
    num = len(data)                                         # 数据集的数量
    num_feature_val = [0] * len(feature_val)                # 该特征值出现的次数
    splitinfo = 0.0
    # 记录出现的次数
    for row in data:
        num_feature_val[feature_val.index(row[index])] += 1
    # 特征的熵
    for i in range(len(feature_val)):
        t = float(num_feature_val[i]) / float(num)
        if t != 0:
            splitinfo -= t * math.log(t)
    return IG / (splitinfo + 0.1)                           # 会出现除以0的情况


def cal_GN(data, features, feature):
    '''
    :param data: 数据集
    :param features: 特征集
    :param feature: 要计算gini指数的特征
    :return: 该特征的gini指数
    计算feature在data上的gini指数
    '''
    dic = {}                                        # 记录（特征值，标签）的次数
    feature_val = {}                                # 记录出现的特征值以及出现的次数
    label_val = []                                  # 记录出现的标签值
    num = len(data)                                 # 数据集的数量
    GN = 0.0
    index = features.index(feature)                 # 该特征值在第index列
    # gini系数
    for row in data:
        tup = (row[index], row[-1])                 # (特征值，标签)

        if tup[0] not in feature_val:               # [特征值: 特征值出现的次数]
            feature_val[tup[0]] = 1
        else:
            feature_val[tup[0]] += 1

        if tup[1] not in label_val:                 # 标签值
            label_val.append(tup[1])

        if tup not in dic.keys():                   # (特征值, 标签值): [特征值次数. 对应标签次数]
            dic[tup] = [1, 1]
        else:
            dic[tup][0] += 1
            dic[tup][1] += 1
    for a, b in feature_val.items():
        sum = 1.0
        for c in label_val:
            if (a, c) in dic.keys():
                tmp = float(dic[(a, c)][1]) / float(b)
                sum -= tmp**2
        GN += float(b) / float(num) * float(sum)
    return GN


def choose_vertex_v1(data, features):
    '''
    :param data: 数据集
    :param features: 特征集
    :return: 适合做结点的特征
    for information gain
    '''
    IGs = []
    for feature in features[:-1]:
        IGs.append(cal_IG(data, features, feature))
    vertex = np.argsort(-np.array(IGs))[0]
    vertex = features[vertex]
    return vertex


def choose_vertex_v2(data, features):
    '''
    :param data: 数据集
    :param features: 特征集
    :return: 适合做结点的特征
    for information gain ratio
    '''
    GRs = []
    for feature in features[:-1]:
        GRs.append(cal_GR(data, features, feature))
    vertex = np.argsort(-np.array(GRs))[0]
    vertex = features[vertex]
    return vertex


def choose_vertex_v3(data, features):
    '''
    :param data: 数据集
    :param features: 特征集
    :return: 适合做结点的特征
    for gini
    '''
    GNs = []
    for feature in features[:-1]:
        GNs.append(cal_GN(data, features, feature))
    vertex = np.argsort(np.array(GNs))[0]
    vertex = features[vertex]
    return vertex


def split(data, features, feature):
    '''
    :param data: 数据集
    :param features: 特征集
    :param feature: 根据此特征划分数据集
    :return: 根据feature的值划分得到的若干子数据集，feature的所有值，删去feature后的特征集
    '''
    _features = copy.deepcopy(features)                         # 避免影响其他同一层的特征集
    index = _features.index(feature)                            # 该特征所在的列
    feature_val = list(Attribute_VALUE[feature])                # 该特征所有的取值
    split_data = [[] for i in range(len(feature_val))]          # 分裂的子数据集
    for row in data:
        split_data[feature_val.index(row[index])].append(row)
    # 删去feature对应的列数据
    for i in range(len(feature_val)):
        if len(split_data[i]) != 0:
            split_data[i] = np.delete(split_data[i], index, axis=1)
            split_data[i] = np.array(split_data[i])
    _features.remove(feature)                                   # 从特征集删去该特征
    return np.array(split_data), feature_val, _features


def check_1(data):
    '''
    :param data: 数据集
    :return: 标签全部一样返回True，否则返回False
    '''
    last = data[0][-1]
    for row in data[1: ]:
        if last != row[-1]:
            return False
    return True


def check_2(data, features):
    '''
    :param data: 数据集
    :param features: 特征集
    :return: 数据集在特征集上的取值都一样返回True，否则返回False
    '''
    num = len(features)
    for i in range(len(features[: -1])):
        last = data[0][i]
        for row in data[1:]:
            if row[i] != last:
                return False
    return True


def majority(column):
    '''
    :param column: 数据集的标签
    :return: 多数标签的种类
    '''
    num = [0, 0]
    for each in column:
        num[each] += 1
    if num[0] > num[1]:
        return 0
    return 1


def create_tree(data, features, choice):
    '''
    :param data: 数据集
    :param features: 特征集
    :param choice: 选择信息增益、信息增益率还是gini指数来选择结点
    :return: 树的根结点
    '''
    tree = {}                                       # 特征：子字典
    sub_tree = {}                                   # 特征值：子字典
    if choice == 0:                                 # 信息增益作为标准
        vertex = choose_vertex_v1(data, features)
    elif choice == 1:                               # 信息增益率作为标准
        vertex = choose_vertex_v2(data, features)
    else:                                           # gini指数作为标准
        vertex = choose_vertex_v3(data, features)
    split_data, feature_val, features = split(data, features, vertex)       # 划分数据集并从当前特征集中删去特征
    for i in range(len(feature_val)):
        if len(split_data[i]) == 0:                 # 子数据集为空，递归停止
            res = majority(data[:, -1])             # 选择父结点的数据集的多数标签作为叶结点的标签
            sub_tree[feature_val[i]] = res
        elif check_1(split_data[i]):                # 子数据集的标签都一样，递归停止
            sub_tree[feature_val[i]] = split_data[i][0][-1]     # 选择该标签作为叶结点的标签
        elif check_2(split_data[i], features):      # 子数据集在特征集上的取值都一样，递归停止
            res = majority(split_data[i][:, -1])    # 选择多数标签作为叶结点的标签
            sub_tree[feature_val[i]] = res
        else:                                       # 递归建树
            sub_tree[feature_val[i]] = create_tree(split_data[i], features, choice)

    tree[vertex] = sub_tree
    return tree


def predict(data, features, decision_tree):
    '''
    :param data: 数据集
    :param features: 特征集
    :param decision_tree: 决策树
    :return: 在测试集上的准确率
    '''
    total_num = len(data)                           # 数据集的数量
    correct_num = 0                                 # 预测正确的数量
    # predict_label_1 = 0
    # predict_label_2 = 0
    # real_label_1 = 0
    # real_label_2 = 0
    for row in data:
        tree = decision_tree
        while type(tree) != int:                    # 到达叶结点
            feature = list(tree.keys())[0]
            vertex = row[features.index(feature)]   # 在该特征上的取值
            tree = tree[feature]
            tree = tree[vertex]                     # 子树
        print(tree)
        # if tree == row[-1]:                         # 预测正确
            # correct_num += 1
        '''
        if tree == 0:
            predict_label_1 += 1
        else:
            predict_label_2 += 1
        if row[-1] == 0:
            real_label_1 += 1
        else:
            real_label_2 += 1
        '''
    # print('真正的标签0所占的比例：', float(real_label_1) / float(total_num))
    # print('真正的标签1所占的比例：', float(real_label_2) / float(total_num))
    # print('预测的标签1所占的比例：', float(predict_label_1) / float(total_num))
    # print('预测的标签2所占的比例：', float(predict_label_2) / float(total_num))
    # print('准确率：', float(correct_num) / float(total_num))

    # return float(correct_num) / float(total_num)


if __name__ == '__main__':
    '''
    x = range(2, 10)
    model = [[] for i in range(3)]
    for k in range(2, 10):
        division(READ_PATH, TRAIN_PATH, TEST_PATH, k)
        for i in range(0, 3):
            if i == 0:
                print('选择信息增益作为标准')
            elif i == 1:
                print('选择信息增益率作为标准')
            else:
                print('选择gini指数作为标准')
            data, features = get_data(TRAIN_PATH)
            decision_tree = create_tree(data, features, i)
            data, features = get_data(TEST_PATH)
            model[i].append(predict(data, features, decision_tree))
            # print(predict(data, features, decision_tree))
            print()
    plt.xlabel('Value Of K')
    plt.ylabel('Accuracy On Test Data')
    plt.plot(x, model[0], label='Information Gain')
    plt.plot(x, model[1], label='Information Gain Ratio')
    plt.plot(x, model[2], label='Gini Coefficient')
    plt.legend()
    plt.show()
    '''
    # division(READ_PATH, TRAIN_PATH, TEST_PATH, 4)
    for i in range(0, 3):
        if i == 0:
            print('选择信息增益作为标准')
        elif i == 1:
            print('选择信息增益率作为标准')
        else:
            print('选择gini指数作为标准')
        data, features = get_data(TRAIN_PATH)
        decision_tree = create_tree(data, features, i)
        print(decision_tree)
        data, features = get_data(TEST_PATH)
        print(predict(data, features, decision_tree))
        print()