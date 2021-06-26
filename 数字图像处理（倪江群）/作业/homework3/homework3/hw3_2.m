% ����
rH = 2.0;
rL = 0.25;
C = 1;
D0 = [5, 50, 500, 1000];

% ͼƬ��Ϣ
f = imread('F:\program\����ͼ����\hw3\office.jpg');
f = im2double(rgb2gray(f));
[m, n] = size(f);

% ̬ͬ�˲�

% ȡ����
ln_f = log(f + 1);

% ���0
P = 2 * m;
Q = 2 * n;
padding_f = zeros(P, Q);
padding_f(1:m, 1:n) = ln_f;

% ���Ļ�
[y, x] = meshgrid(1:Q, 1:P);
g = padding_f .* (-1).^(x+y);

% fft
G = fft2(g);

figure
subplot(3, 2, [1 2]), imshow(f, []), title('ԭͼ')
index = 3;
for d0 = D0
    D = (x - m).^2 + (y - n).^2;
    H = (rH - rL) .* (1 - exp(-C .* (D ./ d0^2))) + 0.25;
    new_G = G .* H;
    new_g = real(ifft2(new_G)) .* (-1).^(x+y);
    new_f = exp(new_g) - 1;
    t = ['D_0=', num2str(d0),'�Ķ���Ƶ���˲���'];
    subplot(3, 2, index), imshow(new_f(1:m, 1:n), []), title(t)
    index = index + 1;
end

% Butterworth

% ���
padding_f(1:m, 1:n) = f;

% ���Ļ�
g = padding_f .* (-1).^(x+y);

% fft
G = fft2(g);

figure
subplot(3, 2, [1 2]), imshow(f, []), title('ԭͼ')
D0 = [10, 20, 40, 80];
index = 3;
for d0 = D0
    D = (x - m).^2 + (y - n).^2;
    H = 1./ (1 + (d0^2 ./ D));
    new_G = G .* H;
    new_g = real(ifft2(new_G)) .* (-1).^(x+y);
    new_f = exp(new_g) - 1;
    t = ['D_0=', num2str(d0),'��һ��Butterworth��ͨ�˲���'];
    subplot(3, 2, index), imshow(new_f(1:m, 1:n), []), title(t)
    index = index + 1;
end
