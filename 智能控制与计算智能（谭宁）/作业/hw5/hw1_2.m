% CMAC����ƽ�����
clear;
close;

xite = 0.50;                        % ѧϰ��
alfa = 0.05;                        % ��������
    
M = 800;                            % AC����
c = 3; xmin = -3.0; xmax = 3.0;     % AC����
N = 500;                            % AP����

w = zeros(N,1);                     % AP��������Ȩֵ
w_1 = w; w_2 = w;                   % ǰ������Ȩֵ
d_w = w;                            % w���ݶ�

u_1 = 0;                            % ǰһ����u
y_1 = 0;                            % ǰһ����y    
ts = 0.05;                          % ����ʱ��

for k=1:200
    time(k) = k * ts;               % x��

%     u(k) = sign(sin(k * ts));       % ���������

    u(k) = 0.5 * sin(4 * k * ts);
    for i=1:c
        % AC
        s(k, i) = round((u(k) - xmin) * M / (xmax - xmin)) + i; 
        % AP
        ad(i)=mod(s(k, i), N) + 1;
    end

    % ������������
    sum=0;
    for i=1:c
       sum = sum + w(ad(i));
    end
    yn(k) = sum;
    
    % �������
    y(k) = (u_1 - 0.9 * y_1) / (1 + y_1^2);

    % �������
    error(k) = y(k) - yn(k);
    
    % �����õ���w
    for i=1:c
        j = ad(i);
        d_w(j) = xite * error(k);
        w(j) = w_1(j) + d_w(j) + alfa * (w_1(j) - w_2(j));
    end
    
    % ���²���
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