% RBF网络逼近对象
clear;
close;

alfa = 0.05;                        % 动量因子         
xite = 0.15;                        % 学习率
x = [0,1]';                         % 网络输入

b = 3 * ones(5, 1);                 % 宽度
c = [-1 -0.5 0 0.5 1;               % 中心
     -1 -0.5 0 0.5 1];
 
w = rands(5, 1);                    % 隐藏层到输出层的权值
w_1 = w; w_2 = w_1;                 % 前两步的权值
d_w = 0 * w;                        % w的梯度

u_1 = 0;                            % 前一步的u
y_1 = 0;                            % 前一步的y

ts = 0.001;                         % 采样时间

for k = 1:1000
   
    time(k) = k * ts;               % x轴
    % 对象的输入输出
    u(k) = 0.5 * sin(30 * k * ts);
    y(k) = (u_1 - 0.9 * y_1) / (1 + y_1^2);  
    
    % 设置网络输入
    x(1) = u(k);
    x(2) = y(k);
    
    % 计算隐藏层输出
    for j=1:5
        h(j) = exp(-norm(x - c(:, j))^2 / (2 * b(j) * b(j)));
    end
    
    % 计算网络输出
    ym(k) = w' * h';
    
    % 计算误差
    em(k) = y(k) - ym(k);

    % 更新w
    d_w(j) = xite * em(k) * h(j);
    w = w_1 + d_w + alfa * (w_1 - w_2);
    
    % 更新参数
    u_1 = u(k);
    y_1 = y(k);
    
    w_2 = w_1;
    w_1 = w;   
end
figure(1);
plot(time, y, 'r', time, ym, 'k:', 'linewidth', 2);
xlabel('time(s)'); ylabel('y and ym');
legend('ideal signal', 'signal approximation');
figure(2);
plot(time, y-ym, 'k', 'linewidth', 2);
xlabel('time(s)'); ylabel('error');