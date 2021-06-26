% 基于RBF网络的模型参考自校正控制器
clear;
close;

xite1 = 0.15;                   % 网络1的学习率
xite2 = 0.50;                   % 网络2的学习率
alfa = 0.05;

w = 0.5 * ones(6, 1);           % 网络1隐层到输出层的权重
v = 0.5 * ones(6, 1);           % 网络2隐层到输出层的权重

c = 0.5 * ones(1, 6);           % 中心
b = 5 * ones(6, 1);             % 宽度
h = zeros(6, 1);                % 隐层输出

w_1 = w; w_2 = w_1;             % 前两步的w
v_1 = v; v_2 = v_1;             % 前两步的v
u_1 = 0; y_1 = 0; ym_1 = 0;     % 前一步的u、y、ym

ts = 0.001;                     % 采样时间
for k = 1:2000
    time(k) = k * ts;           % x轴
    
    r(k) = 0.5 * sin(2 * pi * k * ts);      % 参考模型信号
    ym(k) = 0.6 * ym_1 + r(k);              % 参考模型输出
    
    g(k) = 0.8 * sin(y_1);                  
    f(k) = 15;  
    y(k) = g(k) + f(k) * u_1;               % 被控对象的输出
    
    % 网络1和网络2的隐层输出
    for j = 1:6
        h(j) = exp(-norm(y(k) - c(:, j))^2 / (2 * b(j) * b(j)));
    end
    
    Ng(k) = w' * h;                         % 网络1的输出（逼近g）
    Nf(k) = v' * h;                         % 网络2的输出（逼近f）
    yn(k) = Ng(k) + Nf(k) * u_1;            % 根据网络估计的参数预测被控对象的输出
    
    e(k) = y(k) - yn(k);                    % 网络的误差
    
    % 更新w
    d_w = 0 * w;
    for j = 1:6
        d_w(j) = xite1 * e(k) * h(j);
    end
    w = w_1 + d_w + alfa * (w_1 - w_2);
    
    % 更新v
    d_v = 0 * v;
    for j = 1:6
        d_v(j) = xite2 * e(k) * h(j) * u_1;
    end
    v = v_1 + d_v + alfa * (v_1 - v_2);
    
    % 自校正控制器的输出（被控对象的控制输入）
    u(k) = (ym(k) - Ng(k)) / Nf(k); 
%     u(k) = (ym(k) - 0.8*sin(y(k)))/15;
    
    % 更新记录
    u_1 = u(k); y_1 = y(k); ym_1 = ym(k);
    w_2 = w_1; w_1 = w;
    v_2 = v_1; v_1 = v;  
end

% 画图
figure(1);
plot(time, y, 'r', time, ym, 'g', time, yn, 'b');
xlabel('time(s)');
legend('被控对象输出', '参考模型输出', '网络估计参数，预测输出');
figure(2);
plot(time, g, 'r', time, Ng, 'g');
xlabel('time(s)');
legend('实际g', '逼近g');
figure(3);
plot(time, f, 'r', time, Nf, 'g');
xlabel('time(s)');
legend('实际f', '逼近f');
figure(4);
plot(time, e);
xlabel('time(s)');
legend('网络误差');