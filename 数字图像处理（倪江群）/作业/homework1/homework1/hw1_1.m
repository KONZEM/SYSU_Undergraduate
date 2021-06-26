% 初始化
H_A = zeros(1, 256);        % 直方图
SUM_H_A = zeros(1, 256);    % 映射函数
L = 256;                    % 灰度级

% 读取信息
A = imread('F:\program\数字图像处理\DIP_HW1\river.JPG');
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

% 统计直方图
for i = 1:256
    H_A(i) = numel(find(A == i-1));
end

% 制作映射函数
SUM_H_A(1) = H_A(1);
for i = 2:256
    SUM_H_A(i) = SUM_H_A(i-1) + H_A(i);
end
SUM_H_A = SUM_H_A .* L ./ A0;

% 均衡化
B = zeros(m, n);
for i = 1:m
    B(i, :) = SUM_H_A(int16(A(i, :)) + 1) / 255.0;
end

% duoble转uint8
B = im2uint8(B);

% 调用histeq()
C = histeq(A);

% 画图
figure;
subplot(1, 3, 1);
imshow(A);
title('原图');
subplot(1, 3, 2);
imshow(B);
title('自己写的直方图均衡处理后的图');
subplot(1, 3, 3);
imshow(C);
title('调用histeq后的图');
% 画直方图
figure;
subplot(1, 3, 1);
imhist(A);
title('原图')
subplot(1, 3, 2);
imhist(B);
title('自己写的直方图均衡处理后的图');
subplot(1, 3, 3);
imhist(C);
title('调用histeq后的图');
