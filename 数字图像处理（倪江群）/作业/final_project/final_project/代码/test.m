function accuracy = test(m, n, class_num, per_class_pic_num, pattern,... 
    character_pics_mean, V_k, A_k)
% m: ͼ�������
% n: ͼ�������
% k: ѡȡ��������������
% class_num: �������
% per_class_pic_num: ÿ������ѵ��������
% pattern: ���Լ���·��
% character_pics_mean: ����ͼ��ľ�ֵ
% V_k: ����ͼ���Э��������k����������
% A_k: �Լ�����ͼ����k������������ɵ������ռ��ϵ��
% �������Ĺ��ܣ�������Լ���׼ȷ��

    % ��ʼ��׼ȷ��
    accuracy = 0;
    
    for i = 1:class_num
        for j = 1:per_class_pic_num
            I = im2double(imread(sprintf(pattern, [i, j])));
            I = reshape(I, m * n, 1);
            
            % ��ͼ���������ռ��ϵ��
            a = V_k' * (I - character_pics_mean);  
            
            % �õ���ϵ��������ͼ���ϵ������
            dif = A_k - repmat(a, 1, class_num);
            
            % ���ݲ����������
            dist = zeros(1, class_num);
            for k = 1:class_num
                dist(k) = sum(dif(:, k) .* dif(:, k));
            end
            
            % ȡ��������Сֵ��Ӧ�������ΪԤ�����
            [~, prediction] = min(dist);
            
            % Ԥ����ȷ
            if prediction == i
                accuracy = accuracy + 1;
            end
            
        end
    end
    
    % ���յ�׼ȷ��
    accuracy = accuracy / (class_num * per_class_pic_num);

end