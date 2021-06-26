function [character_pics_mean, V_k, A_k] =...
    train(m, n, k, class_num, per_class_pic_num, pattern)
% m: 图像的行数
% n: 图像的列数
% k: 选取的特征向量个数
% class_num: 类别数量
% per_class_pic_num: 每个类别的训练集数量
% pattern: 训练集的路径
% 本函数的功能：返回特征图像的均值，特征图像的协方差矩阵的k个特征向量，
% 以及特征图像在k个特征向量组成的特征空间的系数

    % 每个人的五张图像平均后作为一个特征图像
    character_pics = [];
    for i = 1:class_num
        all_images = zeros(m * n, 1);
        for j = 1:per_class_pic_num
            I = im2double(imread(sprintf(pattern, [i, j])));
            I = reshape(I, m * n, 1);
            all_images = all_images + I;
        end
        character_pics = cat(2, character_pics,...
            all_images ./ per_class_pic_num);
    end
    
    % 特征图像的均值
    character_pics_mean = mean(character_pics, 2);
    
    % X
    X = character_pics - repmat(character_pics_mean, 1, class_num);
    
    % L = X^(T) * X
    L = X' * X;
    [W, G] = eig(L);
    
    % V是协方差矩阵的特征向量矩阵
    V = X * W;
    
    % 找到特征值前k大的索引
    g = diag(G, 0);
    index = find_k_max(g, k);
    
    % 取特征值前k大的对应的特征向量
    V_k = V(:, index);
    for i = 1:k
        V_k(:, i) = V_k(:, i) ./ norm(V_k(:, i));
    end
    
    % 特征图像在特征空间的系数
    A_k = V_k' * X;
    
%     % eigenfaces
%     figure
%     for i = 1:k
%         I = reshape(V_k(:, i), m, n);
%         subplot(5, k/5, i), imshow(I, []), title(['第', num2str(i), '个eigenface'])
%     end
end

function index = find_k_max(A, k)
% A: 向量
% k: int
% 本函数的功能: 找到A中数字前k大的对应的索引

    [~, indices] = sort(A, 'descend');
    index = indices(1:k);
end