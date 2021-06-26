% 模糊RBF网络逼近对象
clear;
close;

xite = 0.50;                % 学习率
alfa = 0.05;                % 动量因子

bj = 1.0;                   % 高斯函数宽度
c = [-1 -0.5 0 0.5 1;       % 高斯函数中心
     -1.5 -1 0 1 1.5];
 
w = rands(25, 1);           % 隐藏层到输出层的权值
w_1 = w; w_2 = w_1;         % 前两步的权值

u_1 = 0.0;                  % 前一步的u
y_1 = 0.0;                  % 前一步的y
ts = 0.001;                 % 采样时间

for k = 1:50000
    time(k) = k * ts;       % x轴

    % 对象的输入输出
    u(k) = 0.5 * sin(0.5 * k * ts);
    y(k) = (u_1 - 0.9 * y_1) / (1 + y_1^2);

    % 输入层
    x = [u(k), y(k)]'; 
    f1 = x; 
    
    % 模糊化层
    for i = 1:2                         
       for j = 1:5
          net2(i, j) = -(f1(i) - c(i,j))^2 / bj^2;
       end
    end
    for i=1:2
       for j=1:5
       f2(i, j) = exp(net2(i, j));
       end
    end
    
    % 规则层
    for j=1:5                        
        m1(j) = f2(1, j);
        m2(j) = f2(2, j);
    end
    for i = 1:5
        for j = 1:5
         ff3(i, j) = m2(i) * m1(j);
        end
    end
    f3 = [ff3(1, :), ff3(2, :), ff3(3, :), ff3(4, :), ff3(5, :)];

    % 输出层
    f4 = w_1' * f3';                   
    ym(k) = f4;                   
    
    % 计算误差
    e(k) = y(k) - ym(k);

    % 更新w
    d_w = 0 * w_1;
    for j = 1:25
        d_w(j) = xite * e(k) * f3(j);
    end
    w = w_1 + d_w + alfa * (w_1 - w_2);

    % 更新参数
    u_1 = u(k);
    y_1 = y(k);

    w_2 = w_1;
    w_1 = w;
end

% 画图
figure(1);
plot(time, y, 'r', time, ym, '-.b', 'linewidth', 2);
xlabel('time(s)'); ylabel('Approximation');
legend('y', 'ym');
figure(2);
plot(time, y - ym, 'r', 'linewidth', 2);
xlabel('time(s)'); ylabel('Approximation error');
legend('y-ym');