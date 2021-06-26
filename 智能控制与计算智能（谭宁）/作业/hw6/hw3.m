% RBF网络自适应控制
clear;
close;
    
xite = 0.35;
alfa = 0.05;

u_1 = 0;
y_1 = 0;

% NNC
x = [0, 0]';
c = 0.5 * ones(2, 6);
b = 5 * ones(6, 1);
w = 0.5 * ones(6, 1);
h = [0, 0, 0, 0, 0, 0]';
 
c_1 = c; c_2 = c;
b_1 = b; b_2 = b;
w_1 = w; w_2 = w; 

% NNI
xx = [0, 0, 0]';
cc = [-3 -2 -1 1 2 3;
      -3 -2 -1 1 2 3;
      -3 -2 -1 1 2 3];
bb = 1 * ones(6, 1);
ww = 1 * rand(6, 1);
hh = [0, 0, 0, 0, 0, 0]';
cc_1 = cc; cc_2 = cc;
bb_1 = bb; bb_2 = bb;
ww_1 = ww; ww_2 = w;

ts = 0.01;
for k = 1:100
    time(k) = k * ts;
    ym(k) = sin(2 * pi * k / 25) + sin(2 * pi * k / 10);
    y(k) = y_1 / (1 + y_1^2) + u_1^3;  

    for j = 1:6
        h(j) = exp(-norm(x - c(:, j))^2 / (2 * b(j) * b(j)));
    end
    u(k) = w' * h;

    ec(k) = ym(k) - y(k);
%     dyu(k) = sign((y(k) - y_1) / (u(k) - u_1));
    
    % RBF辨识Jacobian
    xx(1) = u_1;
    xx(2) = y_1;
    xx(3) = y(k);
    for j = 1:6
        hh(j) = exp(-norm(xx - cc(:, j))^2 / (2 * bb(j) * bb(j)));
    end
    yy(k) = ww' * hh;
    e(k) = y(k) - yy(k); 
    dyu(k) = 0;
    for j = 1:6
        dyu(k) = dyu(k) + ww(j) * hh(j) * norm(xx - cc(:, j)) * bb(j)^-2; 
    end
    
    % 更新NNC参数
    d_w = 0 * w;
    for j=1:6
        d_w(j) = xite * ec(k) * h(j) * dyu(k);
    end
    w = w_1 + d_w + alfa * (w_1 - w_2);

    M = 1;
    if M == 1
        d_b = 0 * b;
        for j = 1:6
            d_b(j) = xite * ec(k) * w(j) * h(j) * (b(j)^-3) * norm(x - c(:, j))^2 * dyu(k);
        end
        b = b_1 + d_b + alfa * (b_1 - b_2);

        d_c = 0 * c;
        for j=1:6
            for i = 1:2
                d_c(i, j) = xite * ec(k) * w(j) * h(j) * (x(i) - c(i,j)) * (b(j)^-2) * dyu(k);
            end
        end
        c = c_1 + d_c + alfa * (c_1 - c_2);
    elseif M == 2
       b = b_1;
       c = c_1;
    end
    
    % 更新NNI参数
    d_ww = 0 * ww;
    for j = 1:6
        d_ww(j) = xite * e(k) * hh(j);
    end
    ww = ww_1 + d_ww + alfa * (ww_1 - ww_2);
    
%     d_bb = 0 * bb;
%         for j = 1:6
%             d_bb(j) = xite * e(k) * ww(j) * hh(j) * (bb(j)^-3) * norm(xx - cc(:, j))^2;
%         end
%         bb = bb_1 + d_bb + alfa * (bb_1 - bb_2);
% 
%         d_cc = 0 * cc;
%         for j=1:6
%             for i = 1:3
%                 d_cc(i, j) = xite * e(k) * ww(j) * hh(j) * (xx(i) - cc(i,j)) * (bb(j)^-2);
%             end
%         end
%         cc = cc_1 + d_cc + alfa * (cc_1 - cc_2);
       
    % 更新记录
    u_1 = u(k);
    y_1 = y(k);

    x(1) = y(k);
    x(2) = ec(k);

    w_2 = w_1; w_1 = w;
    c_2 = c_1; c_1 = c; 
    b_2 = b_1; b_1 = b;
    

    ww_2 = ww_1; ww_1 = ww;
    cc_2 = cc_1; cc_1 = cc;
    bb_2 = bb_1; bb_2 = bb;
end
% 画图
figure(1);
plot(time, ym, 'r', time, y, 'b');
xlabel('time(s)');
legend('期望轨迹', '实际轨迹')
% figure(2);
% plot(time,ym-y,'r');
% xlabel('time(s)');ylabel('tracking error');