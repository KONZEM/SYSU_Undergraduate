%Expert PID Controller
clear;
clc;

ts = 0.5;                           % ����ʱ��
step = 500;                         % ��������
r = ones(step, 1);                  % ϵͳ�������
for k = 1:step
    r(k) = 30;
end
time = zeros(step, 1);              % x��
u = zeros(step, 1);                 % ϵͳʵ������/PID���������
y = zeros(step, 1);                 % ϵͳʵ�����
error = zeros(step, 1);             % ϵͳ���������ʵ�����֮��

u_1 = 0; u_2 = 0;                   % ǰ����ϵͳ������
y_1 = 0;                            % ��һ��ϵͳ�����

e = [0, 0, 0]';                     % kp��ki��kd��Ӧ��e
e2_1 = 0;                           % ��һ����e(2)

% kp��ki��kd
kp = 2;
ki = 0.1;     
kd = 0.001;

s = tf('s');
sys = exp(-0.5*s)/(10*s+1);         % �������ݺ���ģ��
dsys = c2d(sys, ts, 'z');           % ��ɢ����ģ��
[num, den] = tfdata(dsys, 'v');     % ��ȡ���ӷ�ĸ��ϵ��

for k = 1:step
    time(k) = k*ts;

    u(k) = kp*e(1) + kd*e(2) + ki*e(3);   % λ������ɢ��ʽ
%     disp(k);   
    
    % �����
    if (e(1)*e(2)>0) || (e(2)==0)       
       if abs(e(1)) >= 0.05 * 30
          u(k) = u_1 + 2*kp*e(1);
%           display("in 2")
       else
          u(k) = u_1 + 0.4*kp*e(1);
       end
       
    end
    
    % ������
    if (e(1)*e(2)<0 && e(2)*e2_1>0)||(e(1)==0) 
%         u(k) = kp*e(1) + kd*e(2) + ki*e(3);   
        u(k) = u(k);
%         display(k);
%         disp(e);
%         display(u(k));
%         display(y_1)
    end

    % ������
    if (e(1)*e(2)<0) && (e(2)*e2_1<0)
       if abs(e(1)) >= 0.05 * 30
          u(k) = u_1 + 2*kp*e(1);
       else
          u(k) = u_1 + 0.6*kp*e(1);
       end
%        display("in 4")
    end

    % ������
    if abs(e(1)) <= 0.001 * 30 
       u(k) = 0.5*e(1) + 0.010*e(3);
    end

    % ����һ
    if abs(e(1)) > 0.8 * 30      
       u(k) = 150;
%        display("in 1_1");
    elseif abs(e(1)) > 0.4  * 30      
       u(k) = 100;
%        display("in 1_2");
    elseif abs(e(1)) > 0.2  * 30
       u(k) = 80; 
%        display("in 1_3");
    elseif abs(e(1)) > 0.1 * 30
       u(k) = 60; 
%        display("in 1_4");
    end
    
    % ���ƿ����������
    if u(k) >= 200
       u(k) = 200;
    end
    if u(k) <= -200
       u(k) = -200;
    end

% ϵͳʵ������Լ����
y(k) = -den(2)*y_1 + num(2)*u_2;
error(k) = r(k) - y(k);

% ���²���
u_2 = u_1; u_1 = u(k); 
y_1 = y(k);
                 
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
