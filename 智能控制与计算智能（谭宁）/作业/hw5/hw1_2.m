% CMAC网络逼近对象
clear;
close;

xite = 0.50;                        % 学习率
alfa = 0.05;                        % 动量因子
    
M = 800;                            % AC参数
c = 3; xmin = -3.0; xmax = 3.0;     % AC参数
N = 500;                            % AP参数

w = zeros(N,1);                     % AP到输出层的权值
w_1 = w; w_2 = w;                   % 前两步的权值
d_w = w;                            % w的梯度

u_1 = 0;                            % 前一步的u
y_1 = 0;                            % 前一步的y    
ts = 0.05;                          % 采样时间

for k=1:200
    time(k) = k * ts;               % x轴

%     u(k) = sign(sin(k * ts));       % 对象的输入

    u(k) = 0.5 * sin(4 * k * ts);
    for i=1:c
        % AC
        s(k, i) = round((u(k) - xmin) * M / (xmax - xmin)) + i; 
        % AP
        ad(i)=mod(s(k, i), N) + 1;
    end

    % 计算网络的输出
    sum=0;
    for i=1:c
       sum = sum + w(ad(i));
    end
    yn(k) = sum;
    
    % 期望输出
    y(k) = (u_1 - 0.9 * y_1) / (1 + y_1^2);

    % 计算误差
    error(k) = y(k) - yn(k);
    
    % 更新用到的w
    for i=1:c
        j = ad(i);
        d_w(j) = xite * error(k);
        w(j) = w_1(j) + d_w(j) + alfa * (w_1(j) - w_2(j));
    end
    
    % 更新参数
    w_2 = w_1; w_1 = w;
    u_1 = u(k);
    y_1 = y(k);
end

figure(1);
plot(time, y, 'b', time, yn, 'r');
xlabel('time(s)'); ylabel('y, yn');
legend('y', 'yn')
figure(2);
plot(time, y - yn, 'k');
xlabel('time(s)'); ylabel('error');