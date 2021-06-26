% Hopfield网络解决TSP
function hw2()
    clear;
    close;

    % 初始化网络参数
    A = 1.5;
    D = 1;
    Mu = 50;
    Step = 0.01;

    % 计算N个城市之间距离,计算初始路径长度
    N = 30;
    cityfile = fopen('city30.txt', 'rt');
    cities = fscanf( cityfile, '%f %f', [2, inf]);      % 2行n列
    fclose(cityfile);
    Initial_Length = Initial_RouteLength(cities);       % 计算初始路径长度(d_12 + d_23 + ... + d_(n-1)n)

    DistanceCity=dist(cities', cities);                 % 计算每个城市之间的距离 
    
    % 网络输入的初始化
    U = 0.001 * rands(N, N);
    V = 1 ./ (1 + exp(-Mu * U));                        % S函数

    % 训练
    for k=1:1200      
        times(k) = k;
        % 计算du/dt
        dU = DeltaU(V, DistanceCity, A, D);
        % 计算u(t)
        U = U + dU * Step;
        % 计算网络输出
        V = 1 ./ (1 + exp(-Mu * U));
        % 计算能量函数
        E = Energy(V, DistanceCity, A, D);
        Ep(k) = E;
        % 检查路径合法性
        [V1, CheckR] = RouteCheck(V); 
    end
    
    % 显示及作图
    if(CheckR == 0)
       Final_E = Energy(V1, DistanceCity, A, D);
       Final_Length = Final_RouteLength(V1, cities); %计算最终路径长度
       disp('迭代次数'); k
       disp('寻优路径矩阵'); V1
       disp('最优能量函数:'); Final_E
       disp('初始路程:'); Initial_Length
       disp('最短路程:'); Final_Length
       PlotR(V1, cities);  % 寻优路径作图
    else
        disp('寻优路径矩阵:'); V1
        disp('寻优路径无效,需要重新对神经网络输入进行初始化');
    end

    figure(2);
    plot(times,Ep,'r');
    title('Energy Function Change');
    xlabel('k'); ylabel('E');
end

% 计算能量函数
function E = Energy(V, d, A, D)
    [~, n] = size(V);
    t1 = sumsqr(sum(V, 2) - 1);
    t2 = sumsqr(sum(V, 1) - 1);
    PermitV = V(:, 2:n);    
    PermitV = [PermitV, V(:, 1)];
    temp = d * PermitV;
    t3 = sum(sum(V .* temp));
    E = 0.5 * (A * t1 + A * t2 + D * t3);
end

% 计算du/dt
function du = DeltaU(V, d, A, D)
    [~, n] = size(V);
    t1 = repmat(sum(V, 2) - 1, 1, n);
    t2 = repmat(sum(V, 1) - 1, n, 1);
    PermitV = V(:, 2:n);
    PermitV = [PermitV, V(:, 1)];
    t3 = d * PermitV;
    du = -1 * (A * t1 + A * t2 + D * t3);
end

% 标准化路径，并检查路径合法性：要求每行每列只有一个“1”
function [V1, CheckR] = RouteCheck(V)
    [rows, cols] = size(V);
    V1 = zeros(rows, cols);
    [~, Order] = max(V);                            % Order为每列最大值的行号
    for j = 1:cols
        V1(Order(j), j) = 1;
    end
    C = sum(V1);                                    % 列和
    R = sum(V1');                                   % 行和
    CheckR = sumsqr(C - R);
end

% 计算初始总路程(s_12 + s_23 + ... + s_(n-1)n)
function L0 = Initial_RouteLength(cities)
    [~, c] = size(cities);
    L0 = 0;
    for i = 2:c
       L0 = L0 + dist(cities(:, i-1)', cities(:, i));
    end
end

% 计算最终总路程
function L = Final_RouteLength(V, cities)
    [~, order] = max(V);
    New = cities(:, order);                     % 按顺序取city的坐标
    New = [New New(:, 1)];
    [~, cs] = size(New);
    L = 0;
    for i = 2:cs
        L = L + dist(New(:, i-1)', New(:, i));
    end
end

% 路径寻优作图
function PlotR(V, cities)
    figure;

    cities = [cities cities(:, 1)];

    [~, order] = max(V);
    New = cities(:, order);
    New = [New New(:, 1)];

    subplot(1, 2, 1);
    plot(cities(1,1), cities(2,1), 'r*' );   
    plot(cities(1,2), cities(2,2), '+' );   
    hold on;
    plot(cities(1,:), cities(2,:), 'o-' ), xlabel('X axis'), ylabel('Y axis'), title('Original Route');
    axis([0,1,0,1]);

    subplot(1,2,2);
    plot( New(1, 1), New(2, 1), 'r*' );   
    hold on;
    plot( New(1, 2), New(2,2), '+' );   
    hold on;
    plot(New(1, :), New(2, :), 'o-');
    title('TSP solution');
    xlabel('X axis'); ylabel('Y axis');
    title('New Route');
    axis([0, 1, 0, 1]);                         % 设置x轴y轴范围 
    axis on
end