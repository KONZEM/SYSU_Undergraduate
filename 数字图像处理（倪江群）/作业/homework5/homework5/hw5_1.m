clc
clear
A = [0, 0, 0, 0, 0, 0, 0;
     0, 0, 1, 1, 0, 0, 0;
     0, 0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, 1, 0, 0;
     0, 0, 1, 1, 1, 1, 0;
     0, 0, 1, 1, 1, 0, 0;
     0, 1, 0, 1, 0, 1, 0;
     0, 0, 0, 0, 0, 0, 0]; 

% figure, subplot(1, 2, 1), imshow(A), title('ԭͼ')
figure, subplot(2, 2, [1 2]), imshow(A), title('ԭͼ')

% R1 = Dilation_SE1(A);
% subplot(1, 2, 1), imshow(R1), title('���ͺ��ͼ')

% R2 = Erosion_SE1(A);
% subplot(1, 2, 1), imshow(R2), title('��ʴ���ͼ')

% R3 = Dilation_SE2(A);
% subplot(1, 2, 1), imshow(R3), title('���ͺ��ͼ')

% R4 = Erosion_SE2(A);
% subplot(1, 2, 2), imshow(R4), title('��ʴ���ͼ')

% R5 = Dilation_SE1(Erosion_SE1(A));
% R6 = Dilation_SE2(Erosion_SE2(A));
% subplot(2, 2, 3), imshow(R5), title('��һ�����任���ͼ')
% subplot(2, 2, 4), imshow(R6), title('�ڶ������任���ͼ')

R7 = Erosion_SE1(Dilation_SE1(A));
R8 = Erosion_SE2(Dilation_SE2(A));
subplot(2, 2, 3), imshow(R7), title('��һ���ձ任���ͼ')
subplot(2, 2, 4), imshow(R8), title('�ڶ����ձ任���ͼ')

% disp(R1)
% disp(R2)
% disp(R3)
% disp(R4)
% disp(R5)
% disp(R6)
% disp(R7)
% disp(R8)

function R = Dilation_SE1(I)
    % ��ת��ԭ���ڵ�������
    SE1 = [1, 1, 1];
    [m, n] = size(I);
    R = zeros(m, n);
    % padding
    padding_I = zeros(m, n+2);
    padding_I(:, 3:n+2) = I;
    % ��������
    for i = 1:m
        for j = 3:n+2
            R(i, j-2) = sign(dot(padding_I(i, j-2:j), SE1));
        end
    end
end

function R = Erosion_SE1(I)
    SE1 = [1, 1, 1];
    [m, n] = size(I);
    R = zeros(m, n);
    % padding
    padding_I = zeros(m, n+2);
    padding_I(:, 1:n) = I;
    % ���㸯ʴ
    for i = 1:m
        for j = 1:n
            R(i, j) = isequal(padding_I(i, j:j+2), SE1);
        end
    end
end

function R = Dilation_SE2(I)
    % ��ת
    % SE2 = [1, 1; 0, 1];
    SE2 = [1 ,0; 1, 1];
    [m, n] = size(I);
    R = zeros(m, n);
    % padding
    padding_I = zeros(m+1, n+1);
    padding_I(2:m+1, 1:n) = I;
    % ��������
    for i = 2:m+1
        for j = 1:n
            R(i-1, j) = sign(sum(sum(padding_I(i-1: i, j:j+1) .* SE2)));
        end
    end
end

function R = Erosion_SE2(I)
    SE2 = [1, 1; 0, 1];
    [m, n] = size(I);
    R = zeros(m, n);
    % padding
    padding_I = zeros(m+1, n+1);
    padding_I(1:m, 2:n+1) = I;
    % ���㸯ʴ
    for i = 1:m
        for j = 2:n+1
            R(i, j-1) = isequal(padding_I(i, j-1:j), SE2(1, 1:2)) && padding_I(i+1, j) == SE2(2, 2);
        end
    end
end
 
% % dilation with SE1
% % padding
% B = zeros(m, n + 2);
% B(:, 1:n) = A;
% for i = 1: m
%     for j = 1: n
%         B(i, j) = sign(dot(B(i, j:j+2), SE1));
%     end
% end
% disp(B(:, 1:n));
% 
% % erosion with SE1
% C = zeros(m, n + 2);
% C(:, 1: n) = A;
% for i = 1: m
%     for j = 1: n
%         C(i, j) = isequal(C(i, j:j+2), SE1);
%     end
% end
% disp(C(:, 1:n))

% % dilation with SE2
% D = zeros(m+1, n+1);
% D(1:m, 2:n+1) = A;
% DD = zeros(m, n);
% for i = 1:m
%     for j = 2:n+1
%         DD(i, j) = sign(sum(sum(D(i: i+1, j-1:j) .* SE2)));
%     end
% end
% figure
% subplot(1, 2, 1)
% imshow(DD)
% disp(DD(1:m, 2:n+1));
% 
% % erosion with SE2
% E = zeros(m+1, n+1);
% E(1:m, 2:n+1) = A;
% EE = zeros(m, n);
% for i = 1:m
%     for j = 2:n+1
%         EE(i, j) = isequal(E(i, j-1:j), SE2(1, 1:2)) && E(i+1, j) == SE2(2, 2);
%     end
% end
% subplot(1, 2 ,2)
% imshow(EE)
% disp(EE(1:m, 2:n+1)); 