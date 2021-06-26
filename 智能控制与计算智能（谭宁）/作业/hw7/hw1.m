% 遗传算法进行BP神经网络学习参数及权值的优化设计
clear;
clc;
close;

population = 80;                        % 种群数量
generation = 1000;                      % 繁衍代数    
code_len = 10;                          % 一个变量的编码长度

w_max = 1.0;                            % 权值的最大值
w_min = -1.0;                           % 权值的最小值
gene = round(rand(population, (6 * 2 + 6 * 1) * code_len)); % 所有权值的编码

x = [0, 0];                             % 网络的输入
y_1 = 0;                                % 上一步的y
ts = 0.001;                             % 采样时间

for k = 1:generation
    time(k) = k * ts;                   % x轴
    
    u(k) = 0.50 * sin(3 * 2 * pi * k * ts);  
    y(k) = u(k)^ 3  + y_1 / (1 + y_1^2);
    
    for p = 1:population
        % 解码获得w1，w2
        w1 = zeros(2, 6);               
        w2 = zeros(6, 1);
        g = gene(p, :);
        
        % w1
        w1_g = g(1: 12 * code_len);
        for i = 1: 12
            tmp = 0;
            for j = 1: code_len
                tmp = tmp + w1_g((i - 1)* code_len + j) * 2^(j-1);
            end
            w1(i) = (w_max - w_min) * tmp /(2^code_len - 1) + w_min;
        end
        
        % w2
        w2_g = g(12 * code_len + 1: 18 * code_len);
        for i = 1: 6
            tmp = 0;
            for j = 1: code_len
                tmp = tmp + w2_g((i - 1) * code_len + j) * 2^(j-1);
            end
            w2(i) = (w_max - w_min) * tmp / (2^code_len - 1) + w_min;
        end
        
        % 网络输出及误差
        h_in = x * w1;
        h_out = 1 ./ (1 + exp(-h_in));
        yn(p) = h_out * w2;
        e(p) = y(k) - yn(p);
        
        F(p) = 1 / abs(e(p));           % 个体适应度
    end
    
    J = 1 ./ F;                         % 目标函数
    best_J(k) = min(J);
    
    f = F;
    [order_f, index_f] = sort(f);       % 按适应度从小到大排序
    best_f(k) = order_f(population);    % 最大适应度
    best_yn(k) = yn(index_f(population));   % 最好的逼近输出
    best_g = gene(index_f(population), :);  % 最好的基因
    
    % 复制
    sum_f = sum(f);
    f_p = floor((order_f / sum_f) * population);
    kk = 1;
    for i = 1: population
        for j = 1: f_p(i)
            tmp_gene(kk, :) = gene(index_f(i), :);
            kk = kk + 1;
        end
    end
    
    % 交叉
    pc = 0.60;
    n = ceil((6 * 2 + 6* 1) * code_len * rand);
    for i = 1: 2: (population - 1)
        tmp = rand;
        if pc > tmp
            for j = n: (6 * 2 + 6* 1) * code_len
                tmp_gene(i, j) = gene(i + 1, j);
                tmp_gene(i + 1, j) = gene(i, j);
            end
        end
    end
    tmp_gene(population, :) = best_g;
    
    % 变异
    pm = 0.10;
    for i = 1: population
        for j = 1: (6 * 2 + 6* 1) * code_len
            tmp = rand;
            if pm > tmp
                if tmp_gene(i, j) == 0
                    tmp_gene(i, j) = 1;
                else
                    tmp_gene(i, j) = 0;
                end
            end
        end
    end
    tmp_gene(population, :) = best_g;
    
    % 下一代基因
    gene = tmp_gene;
    
    % 更新输入和上一步数据
    x(1) = u(k);        
    x(2) = y(k);
    y_1 = y(k);
end

% 解码获得最优基因的w1，w2
w1 = zeros(2, 6);               
w2 = zeros(6, 1);
g = best_g;

% w1
w1_g = g(1: 12 * code_len);
for i = 1: 12
    tmp = 0;
    for j = 1: code_len
        tmp = tmp + w1_g((i - 1)* code_len + j) * 2^(j-1);
    end
    w1(i) = (w_max - w_min) * tmp /(2^code_len - 1) + w_min;
end

% w2
w2_g = g(12 * code_len + 1: 18 * code_len);
for i = 1: 6
    tmp = 0;
    for j = 1: code_len
        tmp = tmp + w2_g((i - 1) * code_len + j) * 2^(j-1);
    end
    w2(i) = (w_max - w_min) * tmp / (2^code_len - 1) + w_min;
end

disp("w1");
disp(w1);
disp("w2");
disp(w2);

figure(1);
plot(time, best_yn, 'r', time, y, 'b');
xlabel("time(s)");
legend("best y_n", "y")
figure(2);
plot(time, best_f);
xlabel("time(s)"); ylabel("best f");
