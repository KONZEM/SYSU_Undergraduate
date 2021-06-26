clc
clear

% 读取
f = imread('book_cover.jpg');
% 转double
f = im2double(f);
% 矩阵大小
[m, n] = size(f);
% 获得坐标
[y, x] = meshgrid(1:n, 1:m);
% 中心化
ff = f .* (-1).^(x+y);
% 傅立叶变换
F = fft2(ff);


factor = (0.1 .* (x - m/2) + 0.1 .* (y - n/2)) .* pi;
% 防止分母为0
t = find(factor == 0);
factor(t) = 0.1;
% 退化函数
H = sin(factor) .* exp(-factor .* j) ./ factor;

% 模糊处理
new_F = F .* H;
% 反傅立叶变换->取实部->去中心化
blurred_f = real(ifft2(new_F)) .* (-1).^(x+y);
% 归一化
blurred_f = (blurred_f - min(blurred_f(:))) /...
                (max(blurred_f(:)) - min(blurred_f(:)));

% 第一张图
figure
subplot(2, 2, [1 2]), imshow(f, []), title('origin image');
subplot(2, 2, 3), imshow(blurred_f, []), title('blurred image');

% 添加高斯噪声
mean = 0;
var = 500;  
gaussian_noise = 0 + sqrt(var) * randn(m, n);
% % 高斯噪声归一化，保持与图像值域相同
% gaussian_noise = (gaussian_noise - min(gaussian_noise(:))) /...
%                 (max(gaussian_noise(:)) - min(gaussian_noise(:)));
% 原图像的值域为0到1
blurred_noisy_f = blurred_f * 255 + gaussian_noise;
% 归一化
blurred_noisy_f = (blurred_noisy_f - min(blurred_noisy_f(:))) /...
                (max(blurred_noisy_f(:)) - min(blurred_noisy_f(:)));
subplot(2, 2, 4), imshow(blurred_noisy_f, []), title('blurred&noisy image');

% 逆滤波器阈值设置
inv_H = H;
for i = 1:m
    for j = 1:n
        if (abs(H(i, j)) < 0.01)
            inv_H(i, j) = 0;
        else
            inv_H(i, j) = 1 / H(i, j);
        end
    end
end

% 第二张图
figure
subplot(2, 2, [1 2]), imshow(f, []), title('origin image');

% 模糊图像中心化->傅立叶变化
blurred_F = fft2(blurred_f .* (-1).^(x+y));
% 逆滤波器处理
deblurred_F = blurred_F .* inv_H;
% 反傅立叶变换->取实部->去中心化
deblurred_f = real(ifft2(deblurred_F)) .* (-1).^(x+y);
subplot(2, 2, 3), imshow(deblurred_f, []), title('deblurred image');

% 模糊噪声图像中心化->傅立叶变化
blurred_noisy_F = fft2(blurred_noisy_f .* (-1).^(x+y));
% 逆滤波器处理
deblurred_noisy_F = blurred_noisy_F .* inv_H;
% 反傅立叶变换->取实部->去中心化
deblurred_noisy_f = real(ifft2(deblurred_noisy_F)) .* (-1).^(x+y);
subplot(2, 2, 4), imshow(deblurred_noisy_f, []), title('deblurred&noise image');

% 第三张图
figure
subplot(2, 2, 1), imshow(f, []), title('origin image');

index = 2;
% 尝试的K值
K = [0.1, 0.01, 0.005];
for k = K
    % 维纳滤波器
    H_win = (abs(H).^ 2 ./ (abs(H).^ 2 + k));
    % 维纳滤波器处理
    deblurred_noisy_F = blurred_noisy_F .* H_win ./ H;
    % 反傅立叶变换->取实部->去中心化
    deblurred_noisy_f = real(ifft2(deblurred_noisy_F)) .* (-1).^(x+y);
    t = ['Wiener Filter', ', K = ', num2str(K(index-1))];
    subplot(2, 2, index), imshow(deblurred_noisy_f, []), title(t);
    index = index + 1;
end








