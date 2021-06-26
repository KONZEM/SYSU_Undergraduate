% ģ��RBF����ƽ�����
clear;
close;

xite = 0.50;                % ѧϰ��
alfa = 0.05;                % ��������

bj = 1.0;                   % ��˹�������
c = [-1 -0.5 0 0.5 1;       % ��˹��������
     -1.5 -1 0 1 1.5];
 
w = rands(25, 1);           % ���ز㵽������Ȩֵ
w_1 = w; w_2 = w_1;         % ǰ������Ȩֵ

u_1 = 0.0;                  % ǰһ����u
y_1 = 0.0;                  % ǰһ����y
ts = 0.001;                 % ����ʱ��

for k = 1:50000
    time(k) = k * ts;       % x��

    % ������������
    u(k) = 0.5 * sin(0.5 * k * ts);
    y(k) = (u_1 - 0.9 * y_1) / (1 + y_1^2);

    % �����
    x = [u(k), y(k)]'; 
    f1 = x; 
    
    % ģ������
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
    
    % �����
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

    % �����
    f4 = w_1' * f3';                   
    ym(k) = f4;                   
    
    % �������
    e(k) = y(k) - ym(k);

    % ����w
    d_w = 0 * w_1;
    for j = 1:25
        d_w(j) = xite * e(k) * f3(j);
    end
    w = w_1 + d_w + alfa * (w_1 - w_2);

    % ���²���
    u_1 = u(k);
    y_1 = y(k);

    w_2 = w_1;
    w_1 = w;
end

% ��ͼ
figure(1);
plot(time, y, 'r', time, ym, '-.b', 'linewidth', 2);
xlabel('time(s)'); ylabel('Approximation');
legend('y', 'ym');
figure(2);
plot(time, y - ym, 'r', 'linewidth', 2);
xlabel('time(s)'); ylabel('Approximation error');
legend('y-ym');