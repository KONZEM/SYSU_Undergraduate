% �Ŵ��㷨����BP������ѧϰ������Ȩֵ���Ż����
clear;
clc;
close;

population = 80;                        % ��Ⱥ����
generation = 1000;                      % ���ܴ���    
code_len = 10;                          % һ�������ı��볤��

w_max = 1.0;                            % Ȩֵ�����ֵ
w_min = -1.0;                           % Ȩֵ����Сֵ
gene = round(rand(population, (6 * 2 + 6 * 1) * code_len)); % ����Ȩֵ�ı���

x = [0, 0];                             % ���������
y_1 = 0;                                % ��һ����y
ts = 0.001;                             % ����ʱ��

for k = 1:generation
    time(k) = k * ts;                   % x��
    
    u(k) = 0.50 * sin(3 * 2 * pi * k * ts);  
    y(k) = u(k)^ 3  + y_1 / (1 + y_1^2);
    
    for p = 1:population
        % ������w1��w2
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
        
        % ������������
        h_in = x * w1;
        h_out = 1 ./ (1 + exp(-h_in));
        yn(p) = h_out * w2;
        e(p) = y(k) - yn(p);
        
        F(p) = 1 / abs(e(p));           % ������Ӧ��
    end
    
    J = 1 ./ F;                         % Ŀ�꺯��
    best_J(k) = min(J);
    
    f = F;
    [order_f, index_f] = sort(f);       % ����Ӧ�ȴ�С��������
    best_f(k) = order_f(population);    % �����Ӧ��
    best_yn(k) = yn(index_f(population));   % ��õıƽ����
    best_g = gene(index_f(population), :);  % ��õĻ���
    
    % ����
    sum_f = sum(f);
    f_p = floor((order_f / sum_f) * population);
    kk = 1;
    for i = 1: population
        for j = 1: f_p(i)
            tmp_gene(kk, :) = gene(index_f(i), :);
            kk = kk + 1;
        end
    end
    
    % ����
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
    
    % ����
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
    
    % ��һ������
    gene = tmp_gene;
    
    % �����������һ������
    x(1) = u(k);        
    x(2) = y(k);
    y_1 = y(k);
end

% ���������Ż����w1��w2
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
