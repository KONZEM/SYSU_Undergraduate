% 遗传算法调节PID参数
clear;
clc;
close;

ts = 0.001;             % 采样间隔
sys = tf(523500, [1, 87.35, 10470, 0]); % 建立传递函数模型
dsys = c2d(sys, ts, 'z');               % 离散化模型
[num, den] = tfdata(dsys, 'v');         % 离散模型的分子分母

x = [0, 0, 0]';                         % 设计u用到
u_3 = 0; u_2 = 0; u_1 = 0;              % 前三部的u
y_3 = 0; y_2 = 0; y_1 = 0;              % 前三步的y

generation = 500;                       % 种群代数
population = 80;                        % 种群个数
code_len = 10;                          % 一个变量的编码长度

kp_max = 1.0;                           % kp最大值
kp_min = 0.3;                           % kp最小值
ki_max = 0.1;                           % ki最大值
ki_min = 0.01;                          % ki最小值
kd_max = 0.05;                          % kd最大值
kd_min = 0.01;                          % kd最小值

gene = round(rand(population, 3 * code_len));   % 三个变量的编码

for k = 1: generation
    time(k) = k * ts;                   % x轴
    r(k) = 1.0;                         % 期望轨迹
    
    for p = 1: population
        % 解码获得三个参数
        kp = 0;
        ki = 0;
        kd = 0;
        g = gene(p, :);

        % kp
        kp_g = g(1: code_len);
        tmp = 0;
        for i = 1:code_len
            tmp = tmp + kp_g(i) * 2^(i-1);
        end
        kp = (kp_max - kp_min) * tmp / (2^code_len - 1) + kp_min;
        
        % ki
        ki_g = g(code_len + 1: 2 * code_len);
        tmp = 0;
        for i = 1:code_len
            tmp = tmp + ki_g(i) * 2^(i-1);
        end
        ki = (ki_max - ki_min) * tmp / (2^code_len - 1) + ki_min;
        
        % kd
        kd_g = g(2 * code_len + 1: 3 * code_len);
        tmp = 0;
        for i = 1:code_len
            tmp = tmp + kd_g(i) * 2^(i-1);
        end
        kd = (kd_max - kd_min) * tmp / (2^code_len - 1) + kd_min;
        
        u(p) = kp * x(1) + ki * x(2) * kd * x(3);   % 个体得到的u
        % 个体得到的y
        y(p) = -den(2) * y_1 - den(3) * y_2 - den(4) * y_3 +...
            num(1) * u(p) + num(2) * u_1 + num(3) * u_2 + num(4) * u_3;
        e(p) = r(k) - y(p);             % 跟踪误差
        
        F(p) = 1 / abs(e(p));           % 个体适应度
    end
    
    J = 1 ./ F;
    best_J(k) = min(J);                 % 目标函数
    
    f = F;
    [order_f, index_f] = sort(f);       % 按适应度从小到大排序
    best_f(k) = order_f(population);    % 最大适应度
    best_g = gene(index_f(population)); % 最好的跟踪输出
    best_u(k) = u(index_f(population)); % 最好的对象输入
    best_y(k) = y(index_f(population)); % 最好的对象输出
    best_e(k) = e(index_f(population)); % 最小的跟踪误差
    
    
    % 复制
    sum_f = sum(f);
    f_p = floor((order_f / sum(f)) * population);
    kk = 1;
    for i = 1: population
        for j = 1: f_p(i)
            tmp_gene(kk, :) = gene(index_f(i), :);
            kk = kk + 1;
        end
    end
    
    % 交叉
    pc = 0.60;
    n = ceil(3 * code_len * rand);
    for i = 1: 2: (population - 1)
        tmp = rand;
        if pc > tmp
            for j = n: 3 * code_len
                tmp_gene(i, j) = gene(i + 1, j);
                tmp_gene(i + 1, j) = gene(i, j);
            end
        end
    end
    tmp_gene(population, :) = best_g;
    
    % 变异
    pm = 0.10;
    for i = 1: population
        for j = 1: 3 * code_len
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
    
    % 更新记录
    u_3 = u_2; u_2 = u_1; u_1 = best_u(k);
    y_3 = y_2; y_2 = y_1; y_1 = best_y(k);
    
    x(3) = (best_e(k) - x(1)) / ts;
    x(1) = best_e(k);
    x(2) = x(2) + best_e(k) * ts;
end

figure(1);
plot(time, r, 'b', time, best_y, 'r');
xlabel("time(s)");
legend("tracing trajectory", "real trajectory");

