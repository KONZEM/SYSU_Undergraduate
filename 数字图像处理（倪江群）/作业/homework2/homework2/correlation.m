% ���������������
clc
clear

% ��ȡͼ��
F = im2double(imread('F:\program\����ͼ����\hm2\car.png'));
H = im2double(imread('F:\program\����ͼ����\hm2\wheel.png'));
[m_F, n_F] = size(F);
[m_H, n_H] = size(H);

% ģ��ͼ��ƽ��ֵ
mean_H = mean(H(:));
% ģ��ͼ���ȥƽ��ֵ�õ���ģ��
H = H - mean_H;
% ��ģ��ͼ��ƽ����
s_H_2 = sum(sum(H.^2));

% ���ԭͼ
expand_row = (m_H - 1) / 2;
expand_col = (n_H - 1)/ 2;
m = m_F + expand_row * 2;
n = n_F + expand_col * 2;
expand_F = zeros(m, n);
expand_F(expand_row + 1:expand_row + m_F,... 
        expand_col + 1:expand_col + n_F) = F;

% ���ֵ��ͼ���ʾ
G = cal_correlation(expand_F, H, m_H, n_H, m_F, n_F, s_H_2);
find(G>=1)
figure;
imshow(G);
title('���ֵ');
disp('���ֵ���');
% disp(G);

figure;
% ��ԭͼ
imshow(F);
hold on

for i = 1:4
    % �ҵ�������ֵ��
    [max_i, max_j] = find(G == max(G(:)));
    % ���ܻ��ж�����ֵ
    max_i = max_i(1);
    max_j = max_j(1);
    % ���������ֵ�������
    disp(['��', i+'0','���ҵ���������ֵ�ĵ��ǣ�']);
    disp(['(', num2str(max_i), ',', num2str(max_j),')'])
    % ���������ֵ�㼰������ƥ����ͼ
    plot(max_j, max_i, 'r*')
    plot([max_j-expand_col, max_j+expand_col], [max_i-expand_row, max_i-expand_row], 'red');
    plot([max_j-expand_col, max_j-expand_col], [max_i-expand_row, max_i+expand_row], 'red');
    plot([max_j-expand_col, max_j+expand_col], [max_i+expand_row, max_i+expand_row], 'red');
    plot([max_j+expand_col, max_j+expand_col], [max_i-expand_row, max_i+expand_row], 'red');
    
    % ��ƥ�����ͼĨ��
    G(max_i-expand_row:max_i+expand_row, max_j-expand_col:max_j+expand_col) = -inf;
end

% % ��һ��
% function R = norm(I)
%     I_2 = I.^2;
%     total = sqrt(sum(I_2(:)));
%     R = I ./ total;
% end

% �������ֵ
function G = cal_correlation(expand_F, H, m_H, n_H, m_F, n_F, s_H_2)
    G = zeros(m_F, n_F);
    for i = 1:m_F
        for j = 1:n_F
        % ��ͼ
        part = expand_F(i:i+m_H-1, j:j+n_H-1);
        % ��ͼƽ��ֵ
        mean_part = mean(part(:));
        % ��ͼ��ȥƽ��ֵ�õ�����ͼ
        part = part - mean_part;
        % ����ͼ��ƽ����
        s_p_2 = sum(sum(part.^2));
        G(i, j) = sum(sum(H .* part)) / sqrt(s_H_2 * s_p_2);
%         G(i, j) = abs(corr2(part, H));
        end
    end
end