import pandas as pd
import numpy as np
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
    :return: 空
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
    # 第一列插入1
    data = np.insert(data, obj=0, values=1, axis=1)
    label = data[:, NUM_OF_FEATURE+1]
    return data[:, :NUM_OF_FEATURE+1], label


def train(train_path, test_path, train_time):
    '''
    :param train_path: 训练集的路径
    :param test_path: 验证集的路径
    :param train_time: 训练次数
    :return: 无
    '''
    # 初始化权重向量w
    w = np.zeros(NUM_OF_FEATURE + 1)
    # 获取数据
    data, label = get_data(train_path)
    # 训练
    num = len(data)
    learning_rate = 1e-3
    # plt.xlabel('train step')
    # plt.ylabel('accuracy')
    # for t in range(5):
    #     x = range(1, train_time+1)
    #     y = []
    for i in range(1, train_time+1):
        # 下降梯度
        gradient = 0.0
        for j in range(num):
            res = np.dot(w, data[j])
            if res >= 0:
                res = (1.0 / (1.0 + np.exp(-res)) - label[j]) * data[j]
            else:
                res = (np.exp(res) / (1.0 + np.exp(res)) - label[j]) * data[j]
            gradient += res
        # 更新
        w -= learning_rate * gradient
    return w
        # 每100次输出准确率
        # if i % 10 == 0:
        #     accuracy = test(test_path, w)
        #     print('train step:', i)
        #     print('learning_rate:', learning_rate)
        #     print('accuracy:', accuracy)
        #     print()
    #         accuracy = test(test_path, w)
    #         y.append(accuracy)
    #     plt.plot(x, y, label=str(learning_rate))
    #     learning_rate *= 0.1
    # plt.legend()
    # plt.show()

# def train(train_path, test_path, train_time):
#     '''
#     :param train_path: 训练集的路径
#     :param test_path: 验证集的路径
#     :param train_time: 训练次数
#     :return: 无
#     '''
#     # 初始化权重向量w
#     w_old = np.zeros(NUM_OF_FEATURE + 1)
#     # 获取数据
#     data, label = get_data(train_path)
#     # 训练
#     num = len(data)
#     learning_rate = 1.0
#     old_accuracy = 0.0
#     x = range(1, train_time+1)
#     y = []
#     for i in range(train_time):
#         gradient = 0.0
#         for j in range(num):
#             res = np.dot(w_old, data[j])
#             if res >= 0:
#                 res = (1.0 / (1.0 + np.exp(-res)) - label[j]) * data[j]
#             else:
#                 res = (np.exp(res) / (1.0 + np.exp(res)) - label[j]) * data[j]
#             gradient += res
#         # 找到能使正确率上升的学习率
#         w_new = w_old - learning_rate * gradient
#         new_accuracy = test(test_path, w_new)
#         while new_accuracy < old_accuracy:
#             learning_rate *= 0.1
#             w_new = w_old - learning_rate * gradient
#             new_accuracy = test(test_path, w_new)
#         w_old = w_new
#         old_accuracy = new_accuracy
#         # 输出正确率
#         y.append(old_accuracy)
#         print(learning_rate)
#         print('train step:', i,  '  accuracy:', '{:.2%}'.format(new_accuracy))
#         print()
#     plt.xlabel('train step')
#     plt.ylabel('accuracy')
#     plt.plot(x, y)
#     plt.legend()
#     plt.show()


def test(test_path, w):
    '''
    :param test_path: 验证集的路径
    :param w: 训练得到的权重w
    :return: 在验证集上的准确率
    '''
    # 获取数据
    data, label = get_data(test_path)
    # 统计预测正确的个数
    num = len(data)
    correct = 0
    for i in range(num):
        res = np.dot(w, data[i])
        if res >= 0:
            res = 1.0 / (1.0 + np.exp(-res)) - label[i]
        else:
            res = np.exp(res) / (1.0 + np.exp(res)) - label[i]
        if abs(res) < 0.5:
            correct += 1
    return float(correct) / float(num)


def predict(test_path,  w):
    data = pd.read_csv(test_path, header=None)
    data = np.array(data)[:, :-1]
    data = np.insert(data, obj=0, values=1, axis=1)
    num = len(data)
    for i in range(num):
        res = np.dot(w, data[i])
        if res >= 0:
            res = 1.0 / (1.0 + np.exp(-res))
        else:
            res = np.exp(res) / (1.0 + np.exp(res))
        if res < 0.5:
            print('0')
        elif res == 0.5:
            print('无法预测')
        else:
            print('1')


if __name__ == '__main__':
    # division(READ_PATH, TRAIN_PATH, TEST_PATH, 4)
    w = train(TRAIN_PATH, TEST_PATH, 100)
    predict(TEST_PATH, w)
