clear;
% clc;
close;

start_time = clock;                     % 开始时间

% 获取样本
[N, s, G] = make_data; 

param_min = [0, 0, 0, 0];               % 参数的最小值
param_max = [5, 5, 50, 5];              % 参数的最大值
param_num = 4;                          % 参数的个数
population = 80;                        % 种群大小
generation = 500;                       % 种群代数
f = 0.8;                                % 缩放因子
cr = 0.6;                               % 交叉概率

% 随机初始化个体
for i = 1: param_num
    param(:, i) = param_min(i) + (param_max(i) - param_min(i)) * rand(population, 1);
end

% 找到最优个体及其目标函数值
best_param = param(:, 1);
best_J = 1e10;
for i = 2: population
    J = cal_J(param(i, :), N, s, G);
    if J < best_J
        best_param = param(i, :);
        best_J = J;
    end
end

% 开始搜索
for k = 1: generation
    time(k) = k;                % x轴
    
    for i = 1: population
        % 找到两个随机个体
        r1 = 1; r2 = 1;
        while (r1 == r2 || r1 == i || r2 == i)
            r1 = ceil(population * rand);
            r2 = ceil(population * rand);
        end
        % 变异
        h(i, :) = best_param + f * (param(r1, :) - param(r2, :));
        
        % 交叉
        for j = 1: param_num
            if h(i, j) < param_min(j)
                h(i, j) = param_min(j);
            elseif h(i, j) > param_max(j)
                h(i, j) = param_max(j);
            end    
        end
        
        % 限定边界
        for j = 1: param_num
            tmp = rand;
            if cr > tmp
                v(i, j) = h(i, j);
            else
                v(i, j) = param(i, j);
            end
        end
        
        % 选择
        if cal_J(v(i, :), N, s, G) < cal_J(param(i, :), N, s, G)
            param(i, :) = v(i, :);
        end
        
        % 更新最优个体
        J = cal_J(param(i, :), N, s, G);
        if J < best_J
            best_param = param(i, :);
            best_J = J;
        end
    end
    
    % 每一代的最优个体的目标函数值
    generation_best_J(k) = best_J;
    
%     if generation_best_J(k) < eps
%         disp(k)
%     end
end

disp("true value: K = 2, T1 = 1, T2 = 20, T = 0.8");
disp("estimated value: ");
disp(best_param);
disp("best value of object funtion: ");
disp(best_J);
    
end_time = clock;                   % 结束时间
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