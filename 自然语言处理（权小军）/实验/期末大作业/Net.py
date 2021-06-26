##################
#####网络定义######
##################

import torch
import torch.nn as nn
import torch.nn.functional as F


class Encoder(nn.Module):
    def __init__(self, vocab_size, embedding_dim, nhidden):
        super(Encoder, self).__init__()
        self.vocab_size = vocab_size
        self.embedding_dim = embedding_dim
        self.nhidden = nhidden

        self.embedding = nn.Embedding(self.vocab_size, self.embedding_dim)
        self.bilstm = nn.LSTM(self.embedding_dim, self.nhidden, bidirectional=True)

    def forward(self, x, hidden=None):
        seq_len, batch_size = x.size()
        if hidden is None:
            init_h = x.data.new(2, batch_size, self.nhidden).fill_(0).float()
            init_c = x.data.new(2, batch_size, self.nhidden).fill_(0).float()
        else:
            init_h, init_c = hidden
        embedding_x = self.embedding(x)
        # output(seq_len, batch_size, 2 * nhidden)
        # state:(h, c); h(2, batch_size, nhidden), c(2, batch_size, nhidden)
        output, state = self.bilstm(embedding_x, (init_h, init_c))
        # output(seq_len, batch_size, nhidden)
        output = output[:, :, :self.nhidden] + output[:, :, self.nhidden:]

        return output, state


class Attention(nn.Module):
    def __init__(self, nhidden):
        super(Attention, self).__init__()
        self.nhidden = nhidden
        self.dense = nn.Linear(self.nhidden, self.nhidden)

    def forward(self, encoder_output, target_output):
        # encoder_output(batch_size, seq_len, nhidden)
        encoder_output = encoder_output.transpose(0, 1)
        # target_output(batch_size, 1, nhidden)
        target_output = target_output.transpose(0, 1)
        # dense_encoder_output(batch_size, nhidden, seq_len)
        dense_encoder_output = self.dense(encoder_output).transpose(1, 2)
        # score(batch_size, 1, seq_len)
        score = torch.bmm(target_output, dense_encoder_output)
        # attention_weight(batch_size, 1, seq_len)
        attention_weight = F.softmax(score, dim=2)
        # context(batch_size, 1, nhidden)
        context = torch.bmm(attention_weight, encoder_output)
        # context(1, batch_size, nhidden)
        context = context.transpose(0, 1)
        return context


class Decoder(nn.Module):
    def __init__(self, vocab_size, embedding_dim, nhidden):
        super(Decoder, self).__init__()
        self.vocab_size = vocab_size
        self.embedding_dim = embedding_dim
        self.nhidden = nhidden

        self.embedding = nn.Embedding(self.vocab_size, self.embedding_dim)
        self.attention = Attention(self.nhidden)
        self.lstm = nn.LSTM(self.embedding_dim, self.nhidden)
        self.dense1 = nn.Linear(2 * self.nhidden, self.nhidden)
        self.dense2 = nn.Linear(self.nhidden, self.vocab_size)

    def forward(self, x, encoder_output, encoder_state):
        embedding_x = self.embedding(x)
        output, state = self.lstm(embedding_x, encoder_state)

        # context(1, batch_size, nhidden)
        context = self.attention(encoder_output, output)
        # context_output(1, batch_size, 2 * nhidden)
        context_output = torch.cat((context, output), 2)
        # dense1_output(1, batch_size, nhidden)
        dense1_output = F.torch.tanh(self.dense1(context_output))
        # decoder_output(1, batch_size, vocab_size)
        decoder_output = F.softmax(self.dense2(dense1_output), dim=2)

        return decoder_output, state
