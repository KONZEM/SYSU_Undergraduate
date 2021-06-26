% 初始化
H_A = zeros(1, 256);    % A的直方图
H_B = zeros(1, 256);    % B的直方图
S_H_A = zeros(1, 256);  % A的映射函数
S_H_B = zeros(1, 256);  % B的映射函数
L = 256;                % 灰度级

% 读取A、B信息
A = imread('F:\program\数字图像处理\DIP_HW1\EightAM.png');
B = imread('F:\program\数字图像处理\DIP_HW1\LENA.png');
[m_A, n_A] = size(A);
[m_B, n_B] = size(B);
A0 = m_A * n_A;
B0 = m_B * n_B;

% 统计A直方图
for i = 1:256
    H_A(i) = numel(find(A == i-1));
end
% 制作A的映射函数
S_H_A(1) = H_A(1);
for i = 2:256
    S_H_A(i) = S_H_A(i-1) + H_A(i);
end
S_H_A = S_H_A .* L ./ A0;

% 统计B直方图
for i = 1:256
    H_B(i) = numel(find(B == i-1));
end
% 制作B映射函数
S_H_B(1) = H_B(1);
for i = 2:256
    S_H_B(i) = S_H_B(i-1) + H_B(i);
end
S_H_B = S_H_B .* L ./ B0;

% 匹配
C = zeros(m_A, n_A);
for i = 1:m_A
    for j = 1:n_A
        % 越界uint8 
        [min_val, min_index] = min(abs(S_H_B - S_H_A(int16(A(i, j))+1)));
        C(i, j) = (min_index - 1) / 255.0;
    end
end

% double转uint8
C = im2uint8(C);

% 画图
figure;
subplot(1, 3, 1);
imshow(A);
title('原图');
subplot(1, 3, 2);
imshow(C);
title('直方图匹配后的图');
subplot(1, 3, 3);
imshow(B);
title('要匹配的图');
% 画直方图
figure;
subplot(1, 3, 1);
imhist(A);
title('原图');
subplot(1, 3, 2);
imhist(C);
title('直方图匹配后的图');
subplot(1, 3, 3);
imhist(B);
title('要匹配的图');




