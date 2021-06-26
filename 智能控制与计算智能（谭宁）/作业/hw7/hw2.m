% �Ŵ��㷨����PID����
clear;
clc;
close;

ts = 0.001;             % �������
sys = tf(523500, [1, 87.35, 10470, 0]); % �������ݺ���ģ��
dsys = c2d(sys, ts, 'z');               % ��ɢ��ģ��
[num, den] = tfdata(dsys, 'v');         % ��ɢģ�͵ķ��ӷ�ĸ

x = [0, 0, 0]';                         % ���u�õ�
u_3 = 0; u_2 = 0; u_1 = 0;              % ǰ������u
y_3 = 0; y_2 = 0; y_1 = 0;              % ǰ������y

generation = 500;                       % ��Ⱥ����
population = 80;                        % ��Ⱥ����
code_len = 10;                          % һ�������ı��볤��

kp_max = 1.0;                           % kp���ֵ
kp_min = 0.3;                           % kp��Сֵ
ki_max = 0.1;                           % ki���ֵ
ki_min = 0.01;                          % ki��Сֵ
kd_max = 0.05;                          % kd���ֵ
kd_min = 0.01;                          % kd��Сֵ

gene = round(rand(population, 3 * code_len));   % ���������ı���

for k = 1: generation
    time(k) = k * ts;                   % x��
    r(k) = 1.0;                         % �����켣
    
    for p = 1: population
        % ��������������
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
        
        u(p) = kp * x(1) + ki * x(2) * kd * x(3);   % ����õ���u
        % ����õ���y
        y(p) = -den(2) * y_1 - den(3) * y_2 - den(4) * y_3 +...
            num(1) * u(p) + num(2) * u_1 + num(3) * u_2 + num(4) * u_3;
        e(p) = r(k) - y(p);             % �������
        
        F(p) = 1 / abs(e(p));           % ������Ӧ��
    end
    
    J = 1 ./ F;
    best_J(k) = min(J);                 % Ŀ�꺯��
    
    f = F;
    [order_f, index_f] = sort(f);       % ����Ӧ�ȴ�С��������
    best_f(k) = order_f(population);    % �����Ӧ��
    best_g = gene(index_f(population)); % ��õĸ������
    best_u(k) = u(index_f(population)); % ��õĶ�������
    best_y(k) = y(index_f(population)); % ��õĶ������
    best_e(k) = e(index_f(population)); % ��С�ĸ������
    
    
    % ����
    sum_f = sum(f);
    f_p = floor((order_f / sum(f)) * population);
    kk = 1;
    for i = 1: population
        for j = 1: f_p(i)
            tmp_gene(kk, :) = gene(index_f(i), :);
            kk = kk + 1;
        end
    end
    
    % ����
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
    
    % ����
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
    
    % ��һ������
    gene = tmp_gene;
    
    % ���¼�¼
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

