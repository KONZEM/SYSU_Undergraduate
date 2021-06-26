function accuracy = test(m, n, class_num, per_class_pic_num, pattern,... 
    character_pics_mean, V_k, A_k)
% m: 图像的行数
% n: 图像的列数
% k: 选取的特征向量个数
% class_num: 类别数量
% per_class_pic_num: 每个类别的训练集数量
% pattern: 测试集的路径
% character_pics_mean: 特征图像的均值
% V_k: 特征图像的协方差矩阵的k个特征向量
% A_k: 以及特征图像在k个特征向量组成的特征空间的系数
% 本函数的功能：计算测试集的准确率

    % 初始化准确率
    accuracy = 0;
    
    for i = 1:class_num
        for j = 1:per_class_pic_num
            I = im2double(imread(sprintf(pattern, [i, j])));
            I = reshape(I, m * n, 1);
            
            % 该图像在特征空间的系数
            a = V_k' * (I - character_pics_mean);  
            
            % 得到的系数与特征图像的系数作差
            dif = A_k - repmat(a, 1, class_num);
            
            % 根据差算出二范数
            dist = zeros(1, class_num);
            for k = 1:class_num
                dist(k) = sum(dif(:, k) .* dif(:, k));
            end
            
            % 取二范数最小值对应的类别作为预测类别
            [~, prediction] = min(dist);
            
            % 预测正确
            if prediction == i
                accuracy = accuracy + 1;
            end
            
        end
    end
    
    % 最终的准确率
    accuracy = accuracy / (class_num * per_class_pic_num);

end