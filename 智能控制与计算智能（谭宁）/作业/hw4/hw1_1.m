% BP网络模式识别 训练程序
clear;
close;

xite = 0.50;                        % 学习率
alfa = 0.05;                        % 动量因子

w1 = rands(2, 6);                   % 输入层到隐藏层的权值
w1_1 = w1; w1_2 = w1;               % 前两步的权值
dw1 = 0 * w1;                       % w1的梯度

w2 = rands(6, 1);                   % 隐藏层到输出层的权值
w2_1 = w2; w2_2 = w2_1;             % 前两步的权值

I = [0, 0, 0, 0, 0, 0]';            % 隐藏层的输入
Iout = [0, 0, 0, 0, 0, 0]';         % 隐藏层的输出
FI = [0, 0, 0, 0, 0, 0]';           % 为计算dw1

NS = 3;                             % 训练样本数
xs=[1, 0; 0, 0; 0, 1];              % 样本的x 
ys=[1; 0; -1];                      % 样本的y
k = 0;                              % 训练次数
E = 1.0;                            % 误差

while E >= 1e-2
    k = k+1;   
    times(k) = k;
    
    % 对于每个样本进行训练
    for s=1:NS      
        % 计算隐藏层输入、输出
        x = xs(s, :);
        for j=1:6   
            I(j) = x * w1(:,j);
            Iout(j) = 1 / (1 + exp(-I(j)));
        end
        
        % 计算网络输出
        yl = w2' * Iout;
        
        % 计算单个样本的误差
        y = ys(s);
        el = 0.5 * (y - yl)^2;
        es(s) = el;
        
        % 计算所有样本的误差
        E=0;
        if s == NS
           for s = 1:NS
              E = E + es(s);
           end
        end
        
        % 更新w2
        ey = y - yl;
        w2 = w2_1 + xite * Iout * ey + alfa * (w2_1 - w2_2);
        
        % 更新w1
        for j = 1:6
           S = 1 / (1 + exp(-I(j)));
           FI(j) = S * (1 - S);
        end
        for i = 1:2
           for j = 1:6
               dw1(i, j) = xite * FI(j) * x(i) * ey(1) * w2(j,1);
           end
        end
        w1 = w1_1 + dw1 + alfa * (w1_1 - w1_2);
        
        % 更新参数
        w1_2 = w1_1; w1_1 = w1;
        w2_2 = w2_1; w2_1 = w2;
    end
    
    % 记录本次误差
    Ek(k)=E;
end

figure(1);
plot(times, Ek, 'r');
xlabel('train time(s)'); ylabel('error');

save wfile w1 w2;