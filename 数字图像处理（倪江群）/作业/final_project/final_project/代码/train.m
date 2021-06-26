function [character_pics_mean, V_k, A_k] =...
    train(m, n, k, class_num, per_class_pic_num, pattern)
% m: ͼ�������
% n: ͼ�������
% k: ѡȡ��������������
% class_num: �������
% per_class_pic_num: ÿ������ѵ��������
% pattern: ѵ������·��
% �������Ĺ��ܣ���������ͼ��ľ�ֵ������ͼ���Э��������k������������
% �Լ�����ͼ����k������������ɵ������ռ��ϵ��

    % ÿ���˵�����ͼ��ƽ������Ϊһ������ͼ��
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
    
    % ����ͼ��ľ�ֵ
    character_pics_mean = mean(character_pics, 2);
    
    % X
    X = character_pics - repmat(character_pics_mean, 1, class_num);
    
    % L = X^(T) * X
    L = X' * X;
    [W, G] = eig(L);
    
    % V��Э��������������������
    V = X * W;
    
    % �ҵ�����ֵǰk�������
    g = diag(G, 0);
    index = find_k_max(g, k);
    
    % ȡ����ֵǰk��Ķ�Ӧ����������
    V_k = V(:, index);
    for i = 1:k
        V_k(:, i) = V_k(:, i) ./ norm(V_k(:, i));
    end
    
    % ����ͼ���������ռ��ϵ��
    A_k = V_k' * X;
    
%     % eigenfaces
%     figure
%     for i = 1:k
%         I = reshape(V_k(:, i), m, n);
%         subplot(5, k/5, i), imshow(I, []), title(['��', num2str(i), '��eigenface'])
%     end
end

function index = find_k_max(A, k)
% A: ����
% k: int
% �������Ĺ���: �ҵ�A������ǰk��Ķ�Ӧ������

    [~, indices] = sort(A, 'descend');
    index = indices(1:k);
end