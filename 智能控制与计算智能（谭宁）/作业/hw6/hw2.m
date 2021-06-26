% ����RBF�����ģ�Ͳο���У��������
clear;
close;

xite1 = 0.15;                   % ����1��ѧϰ��
xite2 = 0.50;                   % ����2��ѧϰ��
alfa = 0.05;

w = 0.5 * ones(6, 1);           % ����1���㵽������Ȩ��
v = 0.5 * ones(6, 1);           % ����2���㵽������Ȩ��

c = 0.5 * ones(1, 6);           % ����
b = 5 * ones(6, 1);             % ���
h = zeros(6, 1);                % �������

w_1 = w; w_2 = w_1;             % ǰ������w
v_1 = v; v_2 = v_1;             % ǰ������v
u_1 = 0; y_1 = 0; ym_1 = 0;     % ǰһ����u��y��ym

ts = 0.001;                     % ����ʱ��
for k = 1:2000
    time(k) = k * ts;           % x��
    
    r(k) = 0.5 * sin(2 * pi * k * ts);      % �ο�ģ���ź�
    ym(k) = 0.6 * ym_1 + r(k);              % �ο�ģ�����
    
    g(k) = 0.8 * sin(y_1);                  
    f(k) = 15;  
    y(k) = g(k) + f(k) * u_1;               % ���ض�������
    
    % ����1������2���������
    for j = 1:6
        h(j) = exp(-norm(y(k) - c(:, j))^2 / (2 * b(j) * b(j)));
    end
    
    Ng(k) = w' * h;                         % ����1��������ƽ�g��
    Nf(k) = v' * h;                         % ����2��������ƽ�f��
    yn(k) = Ng(k) + Nf(k) * u_1;            % ����������ƵĲ���Ԥ�ⱻ�ض�������
    
    e(k) = y(k) - yn(k);                    % ��������
    
    % ����w
    d_w = 0 * w;
    for j = 1:6
        d_w(j) = xite1 * e(k) * h(j);
    end
    w = w_1 + d_w + alfa * (w_1 - w_2);
    
    % ����v
    d_v = 0 * v;
    for j = 1:6
        d_v(j) = xite2 * e(k) * h(j) * u_1;
    end
    v = v_1 + d_v + alfa * (v_1 - v_2);
    
    % ��У������������������ض���Ŀ������룩
    u(k) = (ym(k) - Ng(k)) / Nf(k); 
%     u(k) = (ym(k) - 0.8*sin(y(k)))/15;
    
    % ���¼�¼
    u_1 = u(k); y_1 = y(k); ym_1 = ym(k);
    w_2 = w_1; w_1 = w;
    v_2 = v_1; v_1 = v;  
end

% ��ͼ
figure(1);
plot(time, y, 'r', time, ym, 'g', time, yn, 'b');
xlabel('time(s)');
legend('���ض������', '�ο�ģ�����', '������Ʋ�����Ԥ�����');
figure(2);
plot(time, g, 'r', time, Ng, 'g');
xlabel('time(s)');
legend('ʵ��g', '�ƽ�g');
figure(3);
plot(time, f, 'r', time, Nf, 'g');
xlabel('time(s)');
legend('ʵ��f', '�ƽ�f');
figure(4);
plot(time, e);
xlabel('time(s)');
legend('�������');