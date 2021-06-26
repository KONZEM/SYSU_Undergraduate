clear;
close;
% clc;

start_time = clock;                     % 开始时间

% 获取样本
[N, s, G] = make_data; 

param_min = [0, 0, 0, 0];               % 参数的最小值
param_max = [5, 5, 50, 5];              % 参数的最大值
v_max = 1;                              % 速度的最大值
v_min = -1;                             % 速度的最小值
population = 80;                        % 种群大小
param_num = 4;                          % 参数的数量
generation = 500;                       % 种群代数
c1 = 1.3; c2 = 1.7;                     % 学习因子
w_max = 0.9; w_min = 0.1;               % 惯性权重的最大值和最小值

% 线性递减的惯性权重
for i = 1: generation
    w(i) = w_max - ((w_max - w_min) / generation) * i;
end

% 初始化个体及速度
for i = 1: param_num
    param(:, i) = param_min(i)  +(param_max(i) - param_min(i)) * rand(population, 1);
    v(:, i) = v_min + (v_max - v_min) * rand(population, 1);
end

% 找到全局最优个体及其目标函数
global_best_param = param(1, :);        % 全局最优个体
global_best_J = 1e10;                   % 全局最优个体的目标函数值
for i = 1: population
    J(i) = cal_J(param(i, :), N, s, G);     % 个体的目标函数值
    local_best_param(i, :) = param(i, :);   % 个体历史最优
    if J(i) < global_best_J
        global_best_param = param(i, :);
        global_best_J = J(i);
    end
end

% 开始搜索
for k = 1: generation
    time(k) = k;                        % x轴
        
    for i = 1: population
        % 更新速度
        v(i, :) = w(k) * v(i, :) + c1 * rand *...
            (local_best_param(i, :) - param(i, :)) + c2 * rand *...
            (global_best_param - param(i, :));
        
        % 限定边界
        for j = 1: param_num
            if v(i, j) < v_min
                v(i, j) = v_min;
            elseif v(i, j) > v_max
                v(i, j) = v_max;
            end
        end
        
        % 更新个体
        param(i, :) = param(i, :) + v(i, :);
        
        % 限定边界
        for j = 1: param_num
            if param(i, j) < param_min(j)
                param(i, j) = param_min(j);
            elseif param(i, j) > param_max(j)
                param(i, j) = param_max(j);
            end
        end
        
        % 变异
        if rand > 0.8
            n = ceil(param_num * rand);
            param(i, n) = param_max(n) * rand;
        end
        
        % 更新个体的历史最优
        new_J = cal_J(param(i, :), N, s, G);
        if  new_J < J(i)
            J(i) = new_J;
            local_best_param(i, :) = param(i, :);
        end
        
        % 更新全局最优
        if J(i) < global_best_J
            global_best_param = param(i, :);
            global_best_J = J(i);
        end
    end
    
    % 每一代的全局最优的目标函数值
    generation_best_J(k) = global_best_J;
    
%     if generation_best_J(k) < eps
%         disp(k)
%     end
end

disp("true value: K = 2, T1 = 1, T2 = 20, T = 0.8");
disp("estimated value: ");
disp(global_best_param);
disp("best value of object funtion: ");
disp(global_best_J);

end_time = clock;
disp(["time spent: ", num2str((end_time(5) - start_time(5)) * 60 + (end_time(6) - start_time(6))), "s"]);

figure(1);
plot(time, generation_best_J, 'r', "linewidth", 2);
xlabel("generation(s)"); ylabel("best value of obeject function");

% 计算目标函数
function J = cal_J(param, N, s, G)
    Kp = param(1);
    T1p = param(2);
    T2p = param(3);
    Tp = param(4);
    J = 0;
    for i = 1: N
        Gp(i) = Kp * exp(-Tp * s(i)) / (T1p * s(i) + 1) / (T2p * s(i) + 1);
        e = Gp(i) - G(i);
        J = J + 0.5 * e^2;
    end
end

% 生成样本
function [N, s, G] = make_data
    K = 2;
    T1 = 1;
    T2 = 20;
    T = 0.8;

    smin = -3;
    smax = 3;
    N = (smax - smin) / 0.1 + 1;
    index = 0;
    
    for i = 1: N
        index = index + 1;
        s(index) = smin + (i - 1) * 0.1;
        if T1 * s(index) + 1 == 0 || T2 * s(index) + 1 == 0 % 防止分母为零
            index = index - 1;
            s = s(1: index);
            continue;
        end
        G(index) = K * exp(-T * s(index)) / (T1 * s(index) + 1) / (T2 * s(index) + 1);
    end
    N = index;
end