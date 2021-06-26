function divide_data(class_num, per_class_pic_num, pattern)
% class_num: �������
% per_class_pic_num: ÿ������ѵ�������߲��Լ�����
% pattern�����ݼ���·��
% �������Ĺ��ܣ��������ݼ�

    % ����ѵ�����Ͳ��Լ��ļ���
    if ~exist('train_data', 'dir')
        mkdir('train_data');
    end
    if ~exist('test_data', 'dir')
        mkdir('test_data');
    end
    
    % ÿ���������ݼ�һ����Ϊѵ������һ����Ϊ���Լ�
    for i = 1:class_num
        
        % ����������
        random_index = randperm(per_class_pic_num * 2);
        
        % ѵ����
        path = sprintf('train_data\\s%d', i);
        if ~exist(path, 'dir')
            mkdir(path);
        end
        
        for j = 1:per_class_pic_num;
            des = sprintf('train_data\\s%d\\%d.pgm', [i, j]);
            copyfile(sprintf(pattern, [i, random_index(j)]), des)
        end
        
        % ���Լ�
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