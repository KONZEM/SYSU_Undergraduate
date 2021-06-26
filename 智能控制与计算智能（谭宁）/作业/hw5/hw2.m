% Hopfield������TSP
function hw2()
    clear;
    close;

    % ��ʼ���������
    A = 1.5;
    D = 1;
    Mu = 50;
    Step = 0.01;

    % ����N������֮�����,�����ʼ·������
    N = 30;
    cityfile = fopen('city30.txt', 'rt');
    cities = fscanf( cityfile, '%f %f', [2, inf]);      % 2��n��
    fclose(cityfile);
    Initial_Length = Initial_RouteLength(cities);       % �����ʼ·������(d_12 + d_23 + ... + d_(n-1)n)

    DistanceCity=dist(cities', cities);                 % ����ÿ������֮��ľ��� 
    
    % ��������ĳ�ʼ��
    U = 0.001 * rands(N, N);
    V = 1 ./ (1 + exp(-Mu * U));                        % S����

    % ѵ��
    for k=1:1200      
        times(k) = k;
        % ����du/dt
        dU = DeltaU(V, DistanceCity, A, D);
        % ����u(t)
        U = U + dU * Step;
        % �����������
        V = 1 ./ (1 + exp(-Mu * U));
        % ������������
        E = Energy(V, DistanceCity, A, D);
        Ep(k) = E;
        % ���·���Ϸ���
        [V1, CheckR] = RouteCheck(V); 
    end
    
    % ��ʾ����ͼ
    if(CheckR == 0)
       Final_E = Energy(V1, DistanceCity, A, D);
       Final_Length = Final_RouteLength(V1, cities); %��������·������
       disp('��������'); k
       disp('Ѱ��·������'); V1
       disp('������������:'); Final_E
       disp('��ʼ·��:'); Initial_Length
       disp('���·��:'); Final_Length
       PlotR(V1, cities);  % Ѱ��·����ͼ
    else
        disp('Ѱ��·������:'); V1
        disp('Ѱ��·����Ч,��Ҫ���¶�������������г�ʼ��');
    end

    figure(2);
    plot(times,Ep,'r');
    title('Energy Function Change');
    xlabel('k'); ylabel('E');
end

% ������������
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

% ����du/dt
function du = DeltaU(V, d, A, D)
    [~, n] = size(V);
    t1 = repmat(sum(V, 2) - 1, 1, n);
    t2 = repmat(sum(V, 1) - 1, n, 1);
    PermitV = V(:, 2:n);
    PermitV = [PermitV, V(:, 1)];
    t3 = d * PermitV;
    du = -1 * (A * t1 + A * t2 + D * t3);
end

% ��׼��·���������·���Ϸ��ԣ�Ҫ��ÿ��ÿ��ֻ��һ����1��
function [V1, CheckR] = RouteCheck(V)
    [rows, cols] = size(V);
    V1 = zeros(rows, cols);
    [~, Order] = max(V);                            % OrderΪÿ�����ֵ���к�
    for j = 1:cols
        V1(Order(j), j) = 1;
    end
    C = sum(V1);                                    % �к�
    R = sum(V1');                                   % �к�
    CheckR = sumsqr(C - R);
end

% �����ʼ��·��(s_12 + s_23 + ... + s_(n-1)n)
function L0 = Initial_RouteLength(cities)
    [~, c] = size(cities);
    L0 = 0;
    for i = 2:c
       L0 = L0 + dist(cities(:, i-1)', cities(:, i));
    end
end

% ����������·��
function L = Final_RouteLength(V, cities)
    [~, order] = max(V);
    New = cities(:, order);                     % ��˳��ȡcity������
    New = [New New(:, 1)];
    [~, cs] = size(New);
    L = 0;
    for i = 2:cs
        L = L + dist(New(:, i-1)', New(:, i));
    end
end

% ·��Ѱ����ͼ
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
    axis([0, 1, 0, 1]);                         % ����x��y�᷶Χ 
    axis on
end