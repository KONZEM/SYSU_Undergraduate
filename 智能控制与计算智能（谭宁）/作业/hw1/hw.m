%Expert PID Controller
clear;
clc;

ts = 0.001;                         % 采样时间
step = 500;                         % 迭代次数
r = ones(step, 1);                  % 系统期望输出
time = zeros(step, 1);              % x轴
u = zeros(step, 1);                 % 系统实际输入/PID控制器输出
y = zeros(step, 1);                 % 系统实际输出
error = zeros(step, 1);             % 系统期望输出与实际输出之差

u_1 = 0; u_2 = 0;                   % 前两步系统的输入
y_1 = 0; y_2 = 0;                   % 前两步系统的输出

e = [0, 0, 0]';                     % kp、ki、kd对应的e
e2_1 = 0;                           % 上一步的e(2)

% kp、ki、kd
kp = 5;
ki = 0.03;     
kd = 0.01;

sys = tf(133, [1, 25, 0]);          % 建立传递函数模型
dsys = c2d(sys, ts, 'z');           % 离散化该模型
[num, den] = tfdata(dsys, 'v');     % 获取分子分母的系数

for k = 1:step
    time(k) = k*ts;

    u(k) = kp*e(1) + kd*e(2) + ki*e(3);   % 位置型离散形式

    % 规则一
    if abs(e(1)) > 0.8      
       u(k) = 0.45;
    elseif abs(e(1)) > 0.4        
       u(k) = 0.5;
    elseif abs(e(1)) > 0.2   
       u(k) = 0.12; 
    elseif abs(e(1)) > 0.01 
       u(k) = 0.1; 
    end   
    
    % 规则二
    if (e(1)*e(2)>0) || (e(2)==0)       
       if abs(e(1)) >= 0.0125
          u(k) = u_1 + 2*kp*e(1);
       else
          u(k) = u_1 + 0.4*kp*e(1);
       end
    end
    
    % 规则三
    if (e(1)*e(2)<0 && e(2)*e2_1>0)||(e(1)==0) 
        u(k) = 2*u(k);
    end

    % 规则四
    if (e(1)*e(2)<0) && (e(2)*e2_1<0)
       if abs(e(1)) >= 0.0125
          u(k) = u_1 + 2*kp*e(1);
       else
          u(k) = u_1 + 0.6*kp*e(1);
       end
    end

    % 规则五
    if abs(e(1)) <= 0.001   
       u(k) = 0.5*e(1) + 0.010*e(3);
    end

    % 限制控制器的输出
    if u(k) >= 10
       u(k) = 10;
    end
    if u(k) <= -10
       u(k) = -10;
    end

% 系统实际输出以及误差
y(k) = -den(2)*y_1 - den(3)*y_2 + num(2)*u_1 + num(3)*u_2;
error(k) = r(k) - y(k);

% 更新参数
u_2 = u_1; u_1 = u(k);
y_2 = y_1; y_1 = y(k);
                 
e2_1 = e(2);
e(2) = (error(k)-e(1))/ts;  
e(1) = error(k); 
e(3) = e(3)+error(k)*ts;        
end

figure(1);
plot(time,r,'b',time,y,'r');
xlabel('time(s)');ylabel('r,y');
figure(2);
plot(time,error,'r');
xlabel('time(s)');ylabel('error');
