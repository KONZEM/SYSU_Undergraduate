clc
clear
warning('off')

m = 112;
n = 92;
k = 37;
class_num = 40;
per_class_pic_num  = 5;
pattern1 = 'ORL_faces\\s%d\\%d.pgm';
pattern2 = 'train_data\\s%d\\%d.pgm';
pattern3 = 'test_data\\s%d\\%d.pgm';

% ѵ��
if ~exist('model.mat', 'file') 
    % �������ݼ�
    divide_data(class_num, per_class_pic_num, pattern1)
    
    % �������
    [character_pics_mean, V_k, A_k] =...
        train(m, n, k, class_num, per_class_pic_num, pattern2);
    
    % �������
    save('model.mat', 'character_pics_mean', 'V_k', 'A_k');
end

% �������
load('model.mat');

% ����
accuracy = test(m, n, class_num, per_class_pic_num, pattern3,... 
    character_pics_mean, V_k, A_k);
disp(accuracy);