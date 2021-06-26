function divide_data(class_num, per_class_pic_num, pattern)
% class_num: 类别数量
% per_class_pic_num: 每个类别的训练集或者测试集数量
% pattern：数据集的路径
% 本函数的功能：划分数据集

    % 创建训练集和测试集文件夹
    if ~exist('train_data', 'dir')
        mkdir('train_data');
    end
    if ~exist('test_data', 'dir')
        mkdir('test_data');
    end
    
    % 每个类别的数据集一半作为训练集，一般作为测试集
    for i = 1:class_num
        
        % 随机打乱序号
        random_index = randperm(per_class_pic_num * 2);
        
        % 训练集
        path = sprintf('train_data\\s%d', i);
        if ~exist(path, 'dir')
            mkdir(path);
        end
        
        for j = 1:per_class_pic_num;
            des = sprintf('train_data\\s%d\\%d.pgm', [i, j]);
            copyfile(sprintf(pattern, [i, random_index(j)]), des)
        end
        
        % 测试集
        path = sprintf('test_data\\s%d', i);
        if ~exist(path, 'dir')
            mkdir(path);
        end
        
        for j = 1:per_class_pic_num
            des = sprintf('test_data\\s%d\\%d.pgm', [i, j]);
            copyfile(sprintf(pattern,...
                [i,random_index(per_class_pic_num + j)]), des)
        end
        
    end
end