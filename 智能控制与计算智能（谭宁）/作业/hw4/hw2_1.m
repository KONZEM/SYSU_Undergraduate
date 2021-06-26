% BP网络逼近对象
clear;
close;

xite = 0.50;                % 学习率 
alfa = 0.05;                % 动量因子
        
w1 = rands(2,6);            % 输入层到隐藏层的权值
w1_1 = w1; w1_2 = w1;       % 前两步的权值
dw1 = 0*w1;                 % w1梯度
    
w2 = rands(6,1);            % 隐藏层到输出层的权值         
w2_1 = w2; w2_2 = w2_1;     % 前两步的权值

x = [0, 0]';                % 网络的输入

u_1 = 0;                    % 上一步的u
y_1 = 0;                    % 上一步的y

I = [0, 0, 0, 0, 0, 0]';    % 隐藏层的输入
Iout = [0, 0, 0, 0, 0, 0]'; % 隐藏层的输出
FI = [0, 0, 0, 0, 0, 0]';   % 为计算dw1

ts = 0.001;                 % 采样时间
for k = 1:1000
    time(k) = k * ts;       % x轴
    % 对象的输入输出
    u(k) = 0.50 * sin(6 * pi * k * ts); 
    y(k) = (u_1 - 0.9 * y_1) / (1 + y_1^2);
    
    % 计算隐藏层的输入输出
    for j = 1:6   
         I(j) = x' * w1(:,j);
         Iout(j) = 1 / (1 + exp(-I(j)));
    end   

    yn(k) = w2'*Iout;     % 网络的输出
    e(k) = y(k)-yn(k);    % 误差
    
    % 更新w2
    w2 = w2_1+ xite * e(k) * Iout + alfa * (w2_1 - w2_2);
    
    % 更新w1
    for j = 1:6
       FI(j) = exp(-I(j)) / (1 + exp(-I(j)))^2;
    end
    for i = 1:2
       for j = 1:6
          dw1(i, j) = e(k) * xite * FI(j) * w2(j) * x(i);
       end
    end
    w1 = w1_1 + dw1 + alfa * (w1_1 - w1_2);

    % 计算Jacobian
    yu = 0;
    for j = 1:6
       yu = yu + w2(j) * w1(1,j) * FI(j);
    end
    dyu(k)=yu;
    
    % 设置网络输入
    x(1)=u(k);
    x(2)=y(k);
    
    % 更新参数
    w1_2 = w1_1; w1_1 = w1;
    w2_2 = w2_1; w2_1 = w2;
    u_1 = u(k);
    y_1 = y(k);
end

%画图
figure(1);
plot(time, y ,'r', time, yn, 'b');
xlabel('times'); ylabel('y and yn');
legend('ideal signal', 'signal approximation');
figure(2);
plot(time, y-yn, 'r');
xlabel('times'); ylabel('error');
figure(3);
plot(time, dyu);
xlabel('times'); ylabel('dyu');