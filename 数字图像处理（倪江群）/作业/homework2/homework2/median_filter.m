% 清屏及清除工作区
clc
clear

% 读取图像
I = imread('F:\program\数字图像处理\hm2\sport car.pgm');
[m, n] = size(I);

% 产生随机矩阵
T1 = im2uint8(rand(m, n));
T2 = im2uint8(rand(m, n));

% 产生椒盐噪声图像
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

% 填充噪声图像
expand_J = uint8(zeros(m+2, n+2));
expand_J(2:m+1, 2:n+1) = J;

% 中值滤波
K = uint8(zeros(m, n));
for i = 1:m
    for j = 1:n
        % 取值
        kernal = expand_J(i:i+2, j:j+2);
        % 排序
        sort_res = sort(kernal(:));
        % 取中值
        K(i, j) = sort_res(5);
    end
end

% 调用函数
L = medfilt2(expand_J, [3, 3]);

% 画图
figure;
subplot(2, 2, 1);
imshow(I);
title('原图像');
subplot(2, 2, 2);
imshow(J);
title('椒盐噪声图像');
subplot(2, 2, 3);
imshow(K);
title('中值滤波图像');
subplot(2, 2, 4);
imshow(L);
title("采用Matlab 'medfilt2'");
