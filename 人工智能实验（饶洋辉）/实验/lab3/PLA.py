import numpy as np
import pandas as pd
import random
from matplotlib import pyplot as plt

READ_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab3 感知机学习算法与逻辑回归\\train.csv'
TRAIN_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab3 感知机学习算法与逻辑回归\\check_train.csv'
TEST_PATH = u'F:\\software\\人工智能\\人工智能\\实验\\lab3 感知机学习算法与逻辑回归\\check_test.csv'
NUM_OF_FEATURE = 40


def division(read_path, train_path, test_path, k):
    '''
    :param read_path: 数据集路径
    :param train_path: 训练集路径
    :param test_path: 验证集路径
    :param k: 划分数据为k份
    :return: 无
    '''
    train_data = []
    test_data = []
    # 读取数据集
    total_data = pd.read_csv(read_path, header=None)
    total_data = np.array(total_data)
    # np.random.shuffle(total_data)
    num = len(total_data)
    # 划分数据集
    for i in range(int(num/k)):
        test_data.append(total_data[i])
    for i in range(int(num/k), num):
        train_data.append(total_data[i])
    # 写入
    train_data = pd.DataFrame(train_data)
    test_data = pd.DataFrame(test_data)
    train_data.to_csv(train_path, header=False, index=False, line_terminator='\n')
    test_data.to_csv(test_path, header=False, index=False, line_terminator='\n')


def get_data(path):
    '''
    :param path: 文件路径
    :return: 加工后的增广特征向量和修改后的标签
    '''
    # 读取文件
    data = pd.read_csv(path, header=None)
    data = np.array(data)
    # 第一列插入一
    data = np.insert(data, obj=0, values=1, axis=1)
    # 将标签0改为-1
    label = data[:, NUM_OF_FEATURE+1]
    for i in range(len(label)):
        if label[i] == 0:
            label[i] = -1
    return data[:, :NUM_OF_FEATURE+1], label


def train(train_path, test_path, train_time):
    '''
    :param train_path: 训练集的路径
    :param test_path: 验证集的路径
    :param train_time: 训练次数
    :return: 无
    '''
    # 初始化权重向量
    w = np.zeros(NUM_OF_FEATURE + 1)
    # 获取数据
    data, label = get_data(train_path)
    # 训练
    num = len(data)
    # index = [i for i in range(num)]
    # x = range(1, train_time+1)
    # y = []
    for i in range(1, train_time+1):
        # random_index = random.sample(index, 500)
        # for j in random_index:
        #     if np.sign(np.dot(w, data[j])) != label[j]:
        #         w += 10 * label[j] * data[j]
        for j in range(num):
            # 发现分类错误的数据
            if np.sign(np.dot(w, data[j])) != label[j]:
                w += label[j] * data[j]
                break
    return w
        # y.append(test(test_path, w))
        # 每10次输出准确率
        # if i > 0 and i % 10 == 0:
        #     print('train step:', i)
        #     print('accuracy:', '{:.2%}'.format(test(test_path, w)))
        #     print()
    # plt.xlabel('train step')
    # plt.ylabel('accuracy')
    # plt.plot(x, y)
    # plt.show()


# def train(train_path, test_path, train_time):
#     '''
#     :param train_path: 训练集的路径
#     :param test_path: 验证集的路径
#     :param train_time: 训练次数
#     :return: 无
#     '''
#     # 初始化权重w
#     old_w = np.zeros(NUM_OF_FEATURE + 1)
#     # 获得数据
#     data, label = get_data(train_path)
#     # 训练
#     num = len(data)
#     old_accuracy = 0
#     # index = [i for i in range(num)]
#     x = range(1, train_time+1)
#     y = []
#     for i in range(train_time):
#         # random_index = random.sample(index, 500)
#         # for j in random_index:
#         learning_rate = 1
#         for j in range(num):
#             # 找到分类错误的数据
#             if np.sign(np.dot(old_w, data[j])) != label[j]:
#                 # 找到适合修改权重向量w的权重learning_state直到在验证集上准确率有所提高
#                 new_w = old_w + learning_rate * label[j] * data[j]
#                 # new_w = w + learning_rate * label[j] * data[j]
#                 new_accuracy = test(test_path, new_w)
#                 iterative_time = 0
#                 while iterative_time <= 10 and new_accuracy < old_accuracy:
#                     learning_rate *= 0.1
#                     new_w = old_w + learning_rate * label[j] * data[j]
#                     new_accuracy = test(test_path, new_w)
#                 old_accuracy = new_accuracy
#                 old_w = new_w
#                 break
#         y.append(old_accuracy)
#         # 每3次输出准确率
#         if i > 0 and i % 3 == 0:
#             print('train step:', i)
#             print('accuracy: {:.2%}'.format(test(test_path, old_w)))
#             print()
#     plt.xlabel('train step')
#     plt.ylabel('accuracy')
#     plt.plot(x, y)
#     plt.show()


# def test_1(test_path, w):
#     '''
#     :param test_path: 验证集的路径
#     :param w: 训练得到的权重w
#     :return: 在验证集上的准确率
#     '''
#     # 获取数据
#     data, label = get_data(test_path)
#     # 统计预测正确的个数
#     num = len(data)
#     correct = 0
#     r_c_1 = 0
#     r_c_2 = 0
#     p_c_1 = 0
#     p_c_2 = 0
#     for i in range(num):
#         predict = np.sign(np.dot(w, data[i]))
#         if predict == label[i]:
#             correct += 1
#         if predict == -1:
#             p_c_1 += 1
#         else:
#             p_c_2 += 1
#         if label[i] == -1:
#             r_c_1 += 1
#         else:
#             r_c_2 += 1
#     print('the number of real -1:', r_c_1)
#     print('the number of real 1:', r_c_2)
#     print('the number of predict -1:', p_c_1)
#     print('the number of predict 1', p_c_2)
#     return float(correct) / float(num)


def test(test_path, w):
    # 获取数据
    data, label = get_data(test_path)
    # 统计预测正确的个数
    num = len(data)
    correct = 0
    for i in range(num):
        predict = np.sign(np.dot(w, data[i]))
        if predict == label[i]:
            correct += 1
    return float(correct) / float(num)


def predict(test_path, w):
    data = pd.read_csv(test_path, header=None)
    data = np.array(data)[:, :-1]
    num = len(data)
    for i in range(num):
        print(np.sign(np.dot(w, data[i])))


if __name__ == '__main__':
    # division(READ_PATH, TRAIN_PATH, TEST_PATH, 4)
    w = train(TRAIN_PATH, TEST_PATH, 100)
    predict(TEST_PATH, w)