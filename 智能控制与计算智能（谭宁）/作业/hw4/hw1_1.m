% BP����ģʽʶ�� ѵ������
clear;
close;

xite = 0.50;                        % ѧϰ��
alfa = 0.05;                        % ��������

w1 = rands(2, 6);                   % ����㵽���ز��Ȩֵ
w1_1 = w1; w1_2 = w1;               % ǰ������Ȩֵ
dw1 = 0 * w1;                       % w1���ݶ�

w2 = rands(6, 1);                   % ���ز㵽������Ȩֵ
w2_1 = w2; w2_2 = w2_1;             % ǰ������Ȩֵ

I = [0, 0, 0, 0, 0, 0]';            % ���ز������
Iout = [0, 0, 0, 0, 0, 0]';         % ���ز�����
FI = [0, 0, 0, 0, 0, 0]';           % Ϊ����dw1

NS = 3;                             % ѵ��������
xs=[1, 0; 0, 0; 0, 1];              % ������x 
ys=[1; 0; -1];                      % ������y
k = 0;                              % ѵ������
E = 1.0;                            % ���

while E >= 1e-2
    k = k+1;   
    times(k) = k;
    
    % ����ÿ����������ѵ��
    for s=1:NS      
        % �������ز����롢���
        x = xs(s, :);
        for j=1:6   
            I(j) = x * w1(:,j);
            Iout(j) = 1 / (1 + exp(-I(j)));
        end
        
        % �����������
        yl = w2' * Iout;
        
        % ���㵥�����������
        y = ys(s);
        el = 0.5 * (y - yl)^2;
        es(s) = el;
        
        % �����������������
        E=0;
        if s == NS
           for s = 1:NS
              E = E + es(s);
           end
        end
        
        % ����w2
        ey = y - yl;
        w2 = w2_1 + xite * Iout * ey + alfa * (w2_1 - w2_2);
        
        % ����w1
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
        
        % ���²���
        w1_2 = w1_1; w1_1 = w1;
        w2_2 = w2_1; w2_1 = w2;
    end
    
    % ��¼�������
    Ek(k)=E;
end

figure(1);
plot(times, Ek, 'r');
xlabel('train time(s)'); ylabel('error');

save wfile w1 w2;