% 清屏及清除工作区
clc
clear

% 读取图像
F = im2double(imread('F:\program\数字图像处理\hm2\car.png'));
H = im2double(imread('F:\program\数字图像处理\hm2\wheel.png'));
[m_F, n_F] = size(F);
[m_H, n_H] = size(H);

% 模板图像平均值
mean_H = mean(H(:));
% 模板图像减去平均值得到新模板
H = H - mean_H;
% 新模板图的平方和
s_H_2 = sum(sum(H.^2));

% 填充原图
expand_row = (m_H - 1) / 2;
expand_col = (n_H - 1)/ 2;
m = m_F + expand_row * 2;
n = n_F + expand_col * 2;
expand_F = zeros(m, n);
expand_F(expand_row + 1:expand_row + m_F,... 
        expand_col + 1:expand_col + n_F) = F;

% 相关值的图像表示
G = cal_correlation(expand_F, H, m_H, n_H, m_F, n_F, s_H_2);
find(G>=1)
figure;
imshow(G);
title('相关值');
disp('相关值结果');
% disp(G);

figure;
% 画原图
imshow(F);
hold on

for i = 1:4
    % 找到最大相关值点
    [max_i, max_j] = find(G == max(G(:)));
    % 可能会有多个最大值
    max_i = max_i(1);
    max_j = max_j(1);
    % 输出最大相关值点的坐标
    disp(['第', i+'0','次找到的最大相关值的点是：']);
    disp(['(', num2str(max_i), ',', num2str(max_j),')'])
    % 标出最大相关值点及框起来匹配子图
    plot(max_j, max_i, 'r*')
    plot([max_j-expand_col, max_j+expand_col], [max_i-expand_row, max_i-expand_row], 'red');
    plot([max_j-expand_col, max_j-expand_col], [max_i-expand_row, max_i+expand_row], 'red');
    plot([max_j-expand_col, max_j+expand_col], [max_i+expand_row, max_i+expand_row], 'red');
    plot([max_j+expand_col, max_j+expand_col], [max_i-expand_row, max_i+expand_row], 'red');
    
    % 将匹配的子图抹除
    G(max_i-expand_row:max_i+expand_row, max_j-expand_col:max_j+expand_col) = -inf;
end

% % 归一化
% function R = norm(I)
%     I_2 = I.^2;
%     total = sqrt(sum(I_2(:)));
%     R = I ./ total;
% end

% 计算相关值
function G = cal_correlation(expand_F, H, m_H, n_H, m_F, n_F, s_H_2)
    G = zeros(m_F, n_F);
    for i = 1:m_F
        for j = 1:n_F
        % 子图
        part = expand_F(i:i+m_H-1, j:j+n_H-1);
        % 子图平均值
        mean_part = mean(part(:));
        % 子图减去平均值得到新子图
        part = part - mean_part;
        % 新子图的平方和
        s_p_2 = sum(sum(part.^2));
        G(i, j) = sum(sum(H .* part)) / sqrt(s_H_2 * s_p_2);
%         G(i, j) = abs(corr2(part, H));
        end
    end
end