% RBF����ƽ�����
clear;
close;

alfa = 0.05;                        % ��������         
xite = 0.15;                        % ѧϰ��
x = [0,1]';                         % ��������

b = 3 * ones(5, 1);                 % ���
c = [-1 -0.5 0 0.5 1;               % ����
     -1 -0.5 0 0.5 1];
 
w = rands(5, 1);                    % ���ز㵽������Ȩֵ
w_1 = w; w_2 = w_1;                 % ǰ������Ȩֵ
d_w = 0 * w;                        % w���ݶ�

u_1 = 0;                            % ǰһ����u
y_1 = 0;                            % ǰһ����y

ts = 0.001;                         % ����ʱ��

for k = 1:1000
   
    time(k) = k * ts;               % x��
    % ������������
    u(k) = 0.5 * sin(30 * k * ts);
    y(k) = (u_1 - 0.9 * y_1) / (1 + y_1^2);  
    
    % ������������
    x(1) = u(k);
    x(2) = y(k);
    
    % �������ز����
    for j=1:5
        h(j) = exp(-norm(x - c(:, j))^2 / (2 * b(j) * b(j)));
    end
    
    % �����������
    ym(k) = w' * h';
    
    % �������
    em(k) = y(k) - ym(k);

    % ����w
    d_w(j) = xite * em(k) * h(j);
    w = w_1 + d_w + alfa * (w_1 - w_2);
    
    % ���²���
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