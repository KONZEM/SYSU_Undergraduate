clc
clear

% 均匀光照
A = im2double(imread('blobz1.png'));
figure
subplot(1, 2, 1), imshow(A), title('原图')
subplot(1, 2, 2), imshow(segmentation(A)), title('分割后的图')

% % 不均匀光照
% B = im2double(imread('blobz2.png'));
% [m, n] = size(B);
% % 分块进行图像分割
% segment = 10.0;
% for i = 1:segment
%     PB = segmentation(B(floor((i-1)/segment*m+1):floor(i/segment*m),... 
%         1:floor(1/segment*n)));
%     for j = 2:segment
%         PB = cat(2, PB, segmentation(B(floor((i-1)/segment*m+1):floor(i/segment*m),... 
%         floor((j-1)/segment*n+1):floor(j/segment*n))));
%     end
%     if i == 1
%         new_B = PB;
%     else
%         new_B = cat(1, new_B, PB);
%     end
% end
% figure
% subplot(2, 2, [1 2]), imshow(new_B), title('原图')
% subplot(2, 2, 3), imshow(segmentation(B)), title('直接进行分割')
% subplot(2, 2, 4), imshow(new_B), title('分块进行分割')
        
function R = segmentation(I)
    reshape_I = I(:);
    [m, n] = size(I);
    num = m * n;
    
    % 新老阈值之差小于eps即停止迭代
    eps = 1e-6;
    old_T = 100.0;
    new_T = mean(reshape_I);

    while abs(old_T - new_T) > eps
        array_1 = [];
        array_2 = [];
        % 根据新阈值将所有像素分成两组
        for j = 1:num
            if reshape_I(j) <= new_T
                array_1 = [array_1, reshape_I(j)];
            else
                array_2 = [array_2, reshape_I(j)];
            end
        end
        old_T = new_T;
        % 计算新阈值
        new_T = (mean(array_1) + mean(array_2)) / 2;
    end
    
    % 大于阈值置一，小于置零
    R = zeros(m, n);
    for i = 1:m
        for j = 1:n
            if I(i, j) > new_T
                R(i, j) = 1;
            else
                R(i, j) = 0;
            end
        end
    end
end
