% ��ʼ��
H_A = zeros(1, 256);        % ֱ��ͼ
SUM_H_A = zeros(1, 256);    % ӳ�亯��
L = 256;                    % �Ҷȼ�

% ��ȡ��Ϣ
A = imread('F:\program\����ͼ����\DIP_HW1\river.JPG');
[m, n] = size(A);
A0 = m * n;

% for i = 1:m
%     wrong
%     H_A(A(i, :) + 1) = H_A(A(i, :) + 1) + 1; 
% 
%     drop for
%     for j = 1:n
%         pixel = A(i, j) + 1;
%         H_A(pixel) = H_A(pixel) + 1;
%     end
% end

% ͳ��ֱ��ͼ
for i = 1:256
    H_A(i) = numel(find(A == i-1));
end

% ����ӳ�亯��
SUM_H_A(1) = H_A(1);
for i = 2:256
    SUM_H_A(i) = SUM_H_A(i-1) + H_A(i);
end
SUM_H_A = SUM_H_A .* L ./ A0;

% ���⻯
B = zeros(m, n);
for i = 1:m
    B(i, :) = SUM_H_A(int16(A(i, :)) + 1) / 255.0;
end

% duobleתuint8
B = im2uint8(B);

% ����histeq()
C = histeq(A);

% ��ͼ
figure;
subplot(1, 3, 1);
imshow(A);
title('ԭͼ');
subplot(1, 3, 2);
imshow(B);
title('�Լ�д��ֱ��ͼ���⴦����ͼ');
subplot(1, 3, 3);
imshow(C);
title('����histeq���ͼ');
% ��ֱ��ͼ
figure;
subplot(1, 3, 1);
imhist(A);
title('ԭͼ')
subplot(1, 3, 2);
imhist(B);
title('�Լ�д��ֱ��ͼ���⴦����ͼ');
subplot(1, 3, 3);
imhist(C);
title('����histeq���ͼ');
