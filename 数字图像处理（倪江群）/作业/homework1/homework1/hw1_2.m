% ��ʼ��
H_A = zeros(1, 256);    % A��ֱ��ͼ
H_B = zeros(1, 256);    % B��ֱ��ͼ
S_H_A = zeros(1, 256);  % A��ӳ�亯��
S_H_B = zeros(1, 256);  % B��ӳ�亯��
L = 256;                % �Ҷȼ�

% ��ȡA��B��Ϣ
A = imread('F:\program\����ͼ����\DIP_HW1\EightAM.png');
B = imread('F:\program\����ͼ����\DIP_HW1\LENA.png');
[m_A, n_A] = size(A);
[m_B, n_B] = size(B);
A0 = m_A * n_A;
B0 = m_B * n_B;

% ͳ��Aֱ��ͼ
for i = 1:256
    H_A(i) = numel(find(A == i-1));
end
% ����A��ӳ�亯��
S_H_A(1) = H_A(1);
for i = 2:256
    S_H_A(i) = S_H_A(i-1) + H_A(i);
end
S_H_A = S_H_A .* L ./ A0;

% ͳ��Bֱ��ͼ
for i = 1:256
    H_B(i) = numel(find(B == i-1));
end
% ����Bӳ�亯��
S_H_B(1) = H_B(1);
for i = 2:256
    S_H_B(i) = S_H_B(i-1) + H_B(i);
end
S_H_B = S_H_B .* L ./ B0;

% ƥ��
C = zeros(m_A, n_A);
for i = 1:m_A
    for j = 1:n_A
        % Խ��uint8 
        [min_val, min_index] = min(abs(S_H_B - S_H_A(int16(A(i, j))+1)));
        C(i, j) = (min_index - 1) / 255.0;
    end
end

% doubleתuint8
C = im2uint8(C);

% ��ͼ
figure;
subplot(1, 3, 1);
imshow(A);
title('ԭͼ');
subplot(1, 3, 2);
imshow(C);
title('ֱ��ͼƥ����ͼ');
subplot(1, 3, 3);
imshow(B);
title('Ҫƥ���ͼ');
% ��ֱ��ͼ
figure;
subplot(1, 3, 1);
imhist(A);
title('ԭͼ');
subplot(1, 3, 2);
imhist(C);
title('ֱ��ͼƥ����ͼ');
subplot(1, 3, 3);
imhist(B);
title('Ҫƥ���ͼ');




