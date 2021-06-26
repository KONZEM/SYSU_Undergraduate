import tensorflow as tf
from tensorflow.contrib import rnn
import numpy as np
import jieba
import re

Train_File_Name = './train_data/{:d}.txt'
Train_Text_Num = 1000
Test_File_Name = './test_data/questions.txt'
Answer_Path = './test_data/answer.txt'
StopWord_Path = 'stopword.txt'
Freq_File = './train_data/freq.txt'
Table_Path = './train_data/word_table.txt'

Stop_Word = []
Answer = []
Word2Id = {}
Id2Word = {}

Learning_Rate_Base = 1e-3
Learning_Rate_Decay = 0.9
nStep = 25
Embedding_Size = 300
Batch_Size = 100
Train_Step = 4000


def build_vocab():
    # 建立词到id的映射
    word_to_id = {}
    id_to_word = {}

    # word -> id
    with open(Table_Path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.split()
            word_to_id[line[1]] = int(line[0]) + 1
    word_to_id['Unknown'] = 0

    # id -> word
    for key, value in word_to_id.items():
        id_to_word[value] = key

    return word_to_id, id_to_word


class Train_Text2Vec:
    def __init__(self, train_file_name, train_text_num, num_word):
        '''
        :param train_file_name: 训练文本的位置
        :param train_text_num: 训练文本的数量
        :param num_word: 一个句子最大长度，超过就截断，不足就padding
        '''

        self.num_word = num_word            # 一个句子的最大长度
        self.input = []                     # 网络的输入
        self.output = []                    # 网络的输出
        self.length = []                    # 输入向量的实际长度
        self.mask = []                      # 长度跟输入一样，有实际输入的位置置一，padding的位置上置零
        self.start_read = 0                 # 开始读取的位置
        self.train_num = 0                  # 训练数据即句子的数量

        self.transform(train_file_name, train_text_num)     # 将训练文本转成向量
        self.make_mask()                    # 制作self.mask

    def transform(self, train_file_name, train_text_num):
        '''
        :param train_file_name: 训练文本的位置
        :param train_text_num: 训练文本的数量
        '''

        for i in range(1, train_text_num):
            with open(train_file_name.format(i), 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.split()
                    sen2vec = [Word2Id[word] if word in Word2Id.keys() else 0 for word in line]     # 句向量

                    # 多删少添
                    l = len(sen2vec)
                    if l == 1:              # 句子只有一个词，舍去
                        continue
                    if l < self.num_word:   # 少添
                        sen2vec += [0] * (self.num_word - l)
                        self.length.append(l - 1)
                    else:                   # 多删
                        sen2vec = sen2vec[:self.num_word]
                        self.length.append(self.num_word - 1)
                    self.input.append(sen2vec[: self.num_word - 1])     # 句子的前l-1个词为输入
                    self.output.append(sen2vec[1: self.num_word])       # 句子的后l-1个词为输出

        self.train_num = len(self.input)

    def make_mask(self):
        for i in range(self.train_num):
            # 实际输入的位置置一，padding位置置零
            t = [1] * self.length[i] + [0] * (self.num_word - 1 - self.length[i])
            self.mask.append(t)

    def next_batch(self, batch_size):
        '''
        :param batch_size: 批量读取大小
        :return: 批量数据
        '''

        end_read = (self.start_read + batch_size) % self.train_num      # 结束的位置
        if self.start_read > end_read:
            input_batch = self.input[self.start_read:] + self.input[: end_read]
            output_batch = self.output[self.start_read:] + self.output[: end_read]
            length_batch = self.length[self.start_read:] + self.length[: end_read]
            mask_batch = self.mask[self.start_read:] + self.mask[: end_read]
        else:
            input_batch = self.input[self.start_read: end_read]
            output_batch = self.output[self.start_read: end_read]
            length_batch = self.length[self.start_read: end_read]
            mask_batch = self.mask[self.start_read: end_read]

        self.start_read = end_read                                      # 更新下次读取的位置

        return input_batch, output_batch, length_batch, mask_batch


class Test_Text2Vec:
    def __init__(self, test_file_name, num_word):
        '''
        :param test_file_name: 测试文本位置
        :param num_word: 句子最大长度
        '''
        self.input = []                                 # 网络的输出
        self.length = []                                # 句向量实际长度
        self.num_word = num_word                        # 一个句子的最大长度
        self.test_num = 0                               # 测试数据即句子的数量

        self.transform(test_file_name, num_word)        # 将测试文本转成向量

    def transform(self, test_file_name, num_word):
        '''
        :param test_file_name: 测试文本位置
        :param num_word: 句子最大长度
        '''
        jieba.add_word('[MASK]')
        with open(test_file_name, 'r', encoding='utf-8') as f:
            for line in f:
                # 分词、定位MASK位置
                sentence = jieba.lcut(line)
                mask_pos = sentence.index('MASK')
                sentence = sentence[: mask_pos]         # 截断

                # 去非中文、去停止词
                for i in range(mask_pos):
                    sentence[i] = re.sub('[^\u4e00-\u9fa5]', '', sentence[i])
                while '' in sentence:
                    sentence.remove('')
                sentence = [_word for _word in sentence if _word not in Stop_Word]

                sen2vec = [Word2Id[word] if word in Word2Id.keys() else 0 for word in sentence]     # 句向量
                l = len(sen2vec)
                if l > num_word:        # 太长，取MASK前num_word个词
                    sen2vec = sen2vec[-num_word:]
                    self.length.append(num_word)
                else:                   # 短 补零
                    sen2vec += [0] * (num_word - l)
                    self.length.append(l)

                self.input.append(sen2vec)

        self.test_num = len(self.length)

    def get_test_data(self):
        '''
        :return: 测试数据
        '''
        output = np.zeros([self.test_num, self.num_word])       # 只为了feed占位符，无意义
        mask = np.zeros([self.test_num, self.num_word])         # 只为了feed占位符，无意义
        return self.input, output, self.length, mask


class LSTM_Model:
    def __init__(self, embedding_size, nstep, batch_size):
        '''
        :param embedding_size: embedding后词语的向量维度
        :param nstep: LSTM的时间节点个数
        :param batch_size: 每次喂入网络数据的数量
        '''
        self.accuracy = 0          # 当前最高准确率
        self.vocab_size = len(Word2Id)  # 词表大小
        self.embedding_size = embedding_size
        self.nstep = nstep
        self.nhidden = embedding_size
        self.batch_size = batch_size
        self.global_step = tf.Variable(0, trainable=False)  # 训练了多少次了

        self.learning_rate = tf.compat.v1.train.exponential_decay(Learning_Rate_Base,
                                                                  self.global_step,
                                                                  100,
                                                                  Learning_Rate_Decay,
                                                                  staircase=True)   # 指数衰减学习率

        self.x = tf.compat.v1.placeholder(shape=[self.batch_size, self.nstep], dtype=tf.int32)  # 输入
        self.y = tf.compat.v1.placeholder(shape=[self.batch_size, self.nstep], dtype=tf.int32)  # 输出
        self.length = tf.compat.v1.placeholder(shape=[self.batch_size], dtype=tf.int32)         # 输入的实际长度
        self.mask = tf.compat.v1.placeholder(shape=[self.batch_size, self.nstep], dtype=tf.float32)     # 权重矩阵
        self.keep_prob = tf.compat.v1.placeholder(dtype=tf.float32)     # dropout

        # embedding_layer
        self.embedding_mat = tf.Variable(tf.compat.v1.random_uniform([self.vocab_size, self.embedding_size], -1, 1))
        self.inputs = tf.nn.embedding_lookup(self.embedding_mat, self.x)
        self.dinputs = tf.nn.dropout(self.inputs, keep_prob=self.keep_prob)

        # lstm_layer
        self.lstm_cell = rnn.BasicLSTMCell(self.nhidden, forget_bias=1.0, state_is_tuple=True)
        self.lstm = rnn.DropoutWrapper(self.lstm_cell, output_keep_prob=self.keep_prob)
        self.initial_state = self.lstm.zero_state(self.batch_size, dtype=tf.float32)
        self.output, _ = tf.nn.dynamic_rnn(self.lstm, self.dinputs, initial_state=self.initial_state, dtype=tf.float32,
                                           time_major=False)  # sequence_length=self.length,

        self.reshape_output = tf.reshape(self.output, [self.batch_size*self.nstep, self.nhidden])

        # full_connect
        self.w = tf.Variable(tf.compat.v1.truncated_normal([self.nhidden, self.vocab_size]), dtype=tf.float32)
        self.b = tf.Variable(tf.zeros([self.vocab_size]))
        self.prob = tf.matmul(self.reshape_output, self.w) + self.b
        self.reshape_prob = tf.reshape(self.prob, [self.batch_size, self.nstep, self.vocab_size])

        # loss
        self.loss = tf.contrib.seq2seq.sequence_loss(
            self.reshape_prob,
            self.y,
            self.mask,
            average_across_timesteps=False,
            average_across_batch=True)
        self.mloss = tf.reduce_mean(self.loss)

        # train
        self.cost = tf.reduce_sum(self.loss)
        tvars = tf.trainable_variables()
        grads, _ = tf.clip_by_global_norm(tf.gradients(self.cost, tvars), 4)        # 梯度裁剪 防梯度爆炸
        self.train = tf.compat.v1.train.AdamOptimizer(self.learning_rate).apply_gradients(
            zip(grads, tvars), global_step=self.global_step)

    def test(self, sess, x, y, l, m):
        '''
        :param sess: 当前会话
        :param x: 测试数据的输入
        :param y: 只为了feed占位符，无意义
        :param l: 输入的实际长度
        :param m: 只为了feed占位符，无意义
        :return: 在测试集上准确率
        '''
        accuracy = 0        # 本次预测的准确率
        predictions = []    # 本次预测的结果
        size = len(x)       # 本次预测的数量
        output = sess.run(self.reshape_prob, feed_dict={self.x: x, self.y: y, self.length: l,
                                                        self.mask: m, self.keep_prob: 1.0})     # 获取预测结果
        for i in range(size):
            prediction = np.argmax(output[i, l[i]-1, :])    # 最大可能的词语的id
            prediction = Id2Word[prediction]                # 通过id获取词语
            predictions.append(prediction)
            # print(prediction, Answer[i])
            if prediction == Answer[i]:                     # 预测正确
                print(prediction)
                accuracy += 1

        if accuracy > self.accuracy:            # 大于当前准确率
            self.accuracy = accuracy            # 更新最高准确率
            predictions = '\n'.join(predictions)    # 更新预测
            with open('./test_data/rnn_prediction.txt', 'w', encoding='utf-8') as f:
                f.write(predictions)

        return float(accuracy) / float(size)


if __name__ == '__main__':
    # 建立映射
    Word2Id, Id2Word = build_vocab()

    # 训练文本转换为向量
    train_data = Train_Text2Vec(Train_File_Name, Train_Text_Num + 1, nStep + 1)

    # 预处理测试文本并转化为向量
    test_data = Test_Text2Vec(Test_File_Name, nStep)

    # 获取预测数据
    test_x, test_y, test_l, test_m = test_data.get_test_data()

    # 加载停止词
    with open(StopWord_Path, 'r', encoding='utf-8') as f:
        for line in f:
            Stop_Word.append(line.strip())

    # 加载答案
    with open(Answer_Path, 'r', encoding='utf-8') as f:
        for line in f:
            Answer.append(line.split()[0])

    # 声明模型
    model = LSTM_Model(Embedding_Size, nStep, Batch_Size)
    # 建立会话
    with tf.compat.v1.Session() as sess:
        # 初始化
        sess.run(tf.compat.v1.global_variables_initializer())
        # 训练Train_Step次
        for i in range(Train_Step + 1):
            input_batch, output_batch, length_batch, mask_batch = train_data.next_batch(Batch_Size)
            _, _loss, step = sess.run([model.train, model.mloss, model.global_step],
                                      feed_dict={model.x: input_batch, model.y: output_batch,
                                                 model.length: length_batch, model.mask: mask_batch,
                                                 model.keep_prob: 1.0})

            if i % 100 == 0:
                print('Step: {:d}, Loss {:f}'.format(step, _loss))
                print('Accuracy: {:.2%}'.format(model.test(sess, test_x, test_y, test_l, test_m)))
                print()

