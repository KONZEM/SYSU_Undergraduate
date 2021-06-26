clc
clear

% ��ȡ
f = imread('book_cover.jpg');
% תdouble
f = im2double(f);
% �����С
[m, n] = size(f);
% �������
[y, x] = meshgrid(1:n, 1:m);
% ���Ļ�
ff = f .* (-1).^(x+y);
% ����Ҷ�任
F = fft2(ff);


factor = (0.1 .* (x - m/2) + 0.1 .* (y - n/2)) .* pi;
% ��ֹ��ĸΪ0
t = find(factor == 0);
factor(t) = 0.1;
% �˻�����
H = sin(factor) .* exp(-factor .* j) ./ factor;

% ģ������
new_F = F .* H;
% ������Ҷ�任->ȡʵ��->ȥ���Ļ�
blurred_f = real(ifft2(new_F)) .* (-1).^(x+y);
% ��һ��
blurred_f = (blurred_f - min(blurred_f(:))) /...
                (max(blurred_f(:)) - min(blurred_f(:)));

% ��һ��ͼ
figure
subplot(2, 2, [1 2]), imshow(f, []), title('origin image');
subplot(2, 2, 3), imshow(blurred_f, []), title('blurred image');

% ��Ӹ�˹����
mean = 0;
var = 500;  
gaussian_noise = 0 + sqrt(var) * randn(m, n);
% % ��˹������һ����������ͼ��ֵ����ͬ
% gaussian_noise = (gaussian_noise - min(gaussian_noise(:))) /...
%                 (max(gaussian_noise(:)) - min(gaussian_noise(:)));
% ԭͼ���ֵ��Ϊ0��1
blurred_noisy_f = blurred_f * 255 + gaussian_noise;
% ��һ��
blurred_noisy_f = (blurred_noisy_f - min(blurred_noisy_f(:))) /...
                (max(blurred_noisy_f(:)) - min(blurred_noisy_f(:)));
subplot(2, 2, 4), imshow(blurred_noisy_f, []), title('blurred&noisy image');

% ���˲�����ֵ����
inv_H = H;
for i = 1:m
    for j = 1:n
        if (abs(H(i, j)) < 0.01)
            inv_H(i, j) = 0;
        else
            inv_H(i, j) = 1 / H(i, j);
        end
    end
end

% �ڶ���ͼ
figure
subplot(2, 2, [1 2]), imshow(f, []), title('origin image');

% ģ��ͼ�����Ļ�->����Ҷ�仯
blurred_F = fft2(blurred_f .* (-1).^(x+y));
% ���˲�������
deblurred_F = blurred_F .* inv_H;
% ������Ҷ�任->ȡʵ��->ȥ���Ļ�
deblurred_f = real(ifft2(deblurred_F)) .* (-1).^(x+y);
subplot(2, 2, 3), imshow(deblurred_f, []), title('deblurred image');

% ģ������ͼ�����Ļ�->����Ҷ�仯
blurred_noisy_F = fft2(blurred_noisy_f .* (-1).^(x+y));
% ���˲�������
deblurred_noisy_F = blurred_noisy_F .* inv_H;
% ������Ҷ�任->ȡʵ��->ȥ���Ļ�
deblurred_noisy_f = real(ifft2(deblurred_noisy_F)) .* (-1).^(x+y);
subplot(2, 2, 4), imshow(deblurred_noisy_f, []), title('deblurred&noise image');

% ������ͼ
figure
subplot(2, 2, 1), imshow(f, []), title('origin image');

index = 2;
% ���Ե�Kֵ
K = [0.1, 0.01, 0.005];
for k = K
    % ά���˲���
    H_win = (abs(H).^ 2 ./ (abs(H).^ 2 + k));
    % ά���˲�������
    deblurred_noisy_F = blurred_noisy_F .* H_win ./ H;
    % ������Ҷ�任->ȡʵ��->ȥ���Ļ�
    deblurred_noisy_f = real(ifft2(deblurred_noisy_F)) .* (-1).^(x+y);
    t = ['Wiener Filter', ', K = ', num2str(K(index-1))];
    subplot(2, 2, index), imshow(deblurred_noisy_f, []), title(t);
    index = index + 1;
end








