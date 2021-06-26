% ��ȡ��Ϣ
f = imread('F:\program\����ͼ����\hw3\barb.png');
f = im2double(f);
[m, n]= size(f);

% ���0
P = 2 * m;
Q = 2 * n;
padding_f = zeros(P, Q);
padding_f(1:m, 1:n) = f;

% ���ı任
[y, x] = meshgrid(1:Q, 1:P);
g = padding_f .* (-1).^(x+y);

% ����Ҷ�任
G = fft2(g);

figure
subplot(3, 2, [1 2]), imshow(f, []), title('ԭͼ')
index = 3;
D0 = [10, 20, 40, 80];
for d0 = D0
    % Butterworth
    D = (x - m).^2 + (y - n).^2;
    BW  = 1./ (1 + (D ./ d0^2));
    % �˲�
    new_G = G .* BW;
    % ����Ҷ���任
    new_g = real(ifft2(new_G));
    % �����ı任
    new_f = new_g .* (-1).^(x+y);
    t = ['D_0=', num2str(d0),'��һ��Butterworth��ͨ�˲���'];
    subplot(3, 2, index), imshow(new_f(1:m, 1:n), []), title(t)
    index = index + 1;
end

% subplot(221), imshow(f, [])
% subplot(222), imshow(g, [])
% subplot(223), imshow(log(1+abs(fft2(f))), [])
% subplot(224), imshow(log(1+abs(G)), [])