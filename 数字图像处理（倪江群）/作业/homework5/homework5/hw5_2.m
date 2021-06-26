clc
clear

% ���ȹ���
A = im2double(imread('blobz1.png'));
figure
subplot(1, 2, 1), imshow(A), title('ԭͼ')
subplot(1, 2, 2), imshow(segmentation(A)), title('�ָ���ͼ')

% % �����ȹ���
% B = im2double(imread('blobz2.png'));
% [m, n] = size(B);
% % �ֿ����ͼ��ָ�
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
% subplot(2, 2, [1 2]), imshow(new_B), title('ԭͼ')
% subplot(2, 2, 3), imshow(segmentation(B)), title('ֱ�ӽ��зָ�')
% subplot(2, 2, 4), imshow(new_B), title('�ֿ���зָ�')
        
function R = segmentation(I)
    reshape_I = I(:);
    [m, n] = size(I);
    num = m * n;
    
    % ������ֵ֮��С��eps��ֹͣ����
    eps = 1e-6;
    old_T = 100.0;
    new_T = mean(reshape_I);

    while abs(old_T - new_T) > eps
        array_1 = [];
        array_2 = [];
        % ��������ֵ���������طֳ�����
        for j = 1:num
            if reshape_I(j) <= new_T
                array_1 = [array_1, reshape_I(j)];
            else
                array_2 = [array_2, reshape_I(j)];
            end
        end
        old_T = new_T;
        % ��������ֵ
        new_T = (mean(array_1) + mean(array_2)) / 2;
    end
    
    % ������ֵ��һ��С������
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
