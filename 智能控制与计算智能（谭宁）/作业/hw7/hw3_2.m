clear;
% clc;
close;

start_time = clock;                     % ��ʼʱ��

% ��ȡ����
[N, s, G] = make_data; 

param_min = [0, 0, 0, 0];               % ��������Сֵ
param_max = [5, 5, 50, 5];              % ���������ֵ
param_num = 4;                          % �����ĸ���
population = 80;                        % ��Ⱥ��С
generation = 500;                       % ��Ⱥ����
f = 0.8;                                % ��������
cr = 0.6;                               % �������

% �����ʼ������
for i = 1: param_num
    param(:, i) = param_min(i) + (param_max(i) - param_min(i)) * rand(population, 1);
end

% �ҵ����Ÿ��弰��Ŀ�꺯��ֵ
best_param = param(:, 1);
best_J = 1e10;
for i = 2: population
    J = cal_J(param(i, :), N, s, G);
    if J < best_J
        best_param = param(i, :);
        best_J = J;
    end
end

% ��ʼ����
for k = 1: generation
    time(k) = k;                % x��
    
    for i = 1: population
        % �ҵ������������
        r1 = 1; r2 = 1;
        while (r1 == r2 || r1 == i || r2 == i)
            r1 = ceil(population * rand);
            r2 = ceil(population * rand);
        end
        % ����
        h(i, :) = best_param + f * (param(r1, :) - param(r2, :));
        
        % ����
        for j = 1: param_num
            if h(i, j) < param_min(j)
                h(i, j) = param_min(j);
            elseif h(i, j) > param_max(j)
                h(i, j) = param_max(j);
            end    
        end
        
        % �޶��߽�
        for j = 1: param_num
            tmp = rand;
            if cr > tmp
                v(i, j) = h(i, j);
            else
                v(i, j) = param(i, j);
            end
        end
        
        % ѡ��
        if cal_J(v(i, :), N, s, G) < cal_J(param(i, :), N, s, G)
            param(i, :) = v(i, :);
        end
        
        % �������Ÿ���
        J = cal_J(param(i, :), N, s, G);
        if J < best_J
            best_param = param(i, :);
            best_J = J;
        end
    end
    
    % ÿһ�������Ÿ����Ŀ�꺯��ֵ
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
    
end_time = clock;                   % ����ʱ��
disp(["time spent: ", num2str((end_time(5) - start_time(5)) * 60 + (end_time(6) - start_time(6))), "s"]);

figure(1);
plot(time, generation_best_J, 'r', "linewidth", 2);
xlabel("generation(s)"); ylabel("best value of obeject function");

% ����Ŀ�꺯��
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

% ��������
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
        if T1 * s(index) + 1 == 0 || T2 * s(index) + 1 == 0 % ��ֹ��ĸΪ��
            index = index - 1;
            s = s(1: index);
            continue;
        end
        G(index) = K * exp(-T * s(index)) / (T1 * s(index) + 1) / (T2 * s(index) + 1);
    end
    N = index;
end