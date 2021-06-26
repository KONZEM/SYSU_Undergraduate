% ���������������
clc
clear

% ��ȡͼ��
I = imread('F:\program\����ͼ����\hm2\sport car.pgm');
[m, n] = size(I);

% �����������
T1 = im2uint8(rand(m, n));
T2 = im2uint8(rand(m, n));

% ������������ͼ��
J = uint8(zeros(m, n));
for i = 1:m
    for j = 1:n
        if I(i, j) > T1(i, j)
            J(i, j) = 255;
        elseif I(i, j) < T2(i, j)
            J(i, j) = 0;
        else
            J(i, j) = I(i, j);
        end
    end
end

% �������ͼ��
expand_J = uint8(zeros(m+2, n+2));
expand_J(2:m+1, 2:n+1) = J;

% ��ֵ�˲�
K = uint8(zeros(m, n));
for i = 1:m
    for j = 1:n
        % ȡֵ
        kernal = expand_J(i:i+2, j:j+2);
        % ����
        sort_res = sort(kernal(:));
        % ȡ��ֵ
        K(i, j) = sort_res(5);
    end
end

% ���ú���
L = medfilt2(expand_J, [3, 3]);

% ��ͼ
figure;
subplot(2, 2, 1);
imshow(I);
title('ԭͼ��');
subplot(2, 2, 2);
imshow(J);
title('��������ͼ��');
subplot(2, 2, 3);
imshow(K);
title('��ֵ�˲�ͼ��');
subplot(2, 2, 4);
imshow(L);
title("����Matlab 'medfilt2'");
