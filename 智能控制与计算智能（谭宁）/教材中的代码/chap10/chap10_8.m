clear all;
close all;
load de1_file;

MinX=[0 0 0 0];  %参数搜索范围
MaxX=[5 5 5 5];

%设计粒子群参数
Size=80;   %种群规模
CodeL=4;   %参数个数

F= 0.80;        % 变异因子：[1,2]
cr =0.6;      % 交叉因子
G=500;              % 最大迭代次数 
%初始化种群的个体
for i=1:1:CodeL       
    X(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1);
end

BestS=X(1,:); %全局最优个体
for i=2:Size
    if chap10_8obj(X(i,:),y,N)<chap10_8obj(BestS,y,N)        
        BestS=X(i,:);
    end
end
Ji=chap10_8obj(BestS,y,N);
%进入主要循环，直到满足精度要求
for kg=1:1:G
     time(kg)=kg;
%变异
    for i=1:Size
        r1 = 1;r2=1;r3=1;r4=1;
        while(r1 == r2|| r1 ==r3 || r2 == r3 || r1 == i|| r2 ==i || r3 == i||r4==i ||r1==r4||r2==r4||r3==r4 )
            r1 = ceil(Size * rand(1));
            r2 = ceil(Size * rand(1));
            r3 = ceil(Size * rand(1));
            r4 = ceil(Size * rand(1));
        end
        h(i,:)=BestS+F*(X(r1,:)-X(r2,:));
        %h(i,:)=X(r1,:)+F*(X(r2,:)-X(r3,:));

        for j=1:CodeL  %检查值是否越界
            if h(i,j)<MinX(j)
                h(i,j)=MinX(j);
            elseif h(i,j)>MaxX(j)
                h(i,j)=MaxX(j);
            end
        end        
%交叉
        for j = 1:1:CodeL
              tempr = rand(1);
              if(tempr<cr)
                  v(i,j) = h(i,j);
               else
                  v(i,j) = X(i,j);
               end
        end
%选择        
        if(chap10_8obj(v(i,:),y,N)<chap10_8obj(X(i,:),y,N))
            X(i,:)=v(i,:);
        end
%判断和更新       
       if chap10_8obj(X(i,:),y,N)<Ji %判断当此时的指标是否为最优的情况
          Ji=chap10_8obj(X(i,:),y,N);
          BestS=X(i,:);
        end
    end
Best_J(kg)=chap10_8obj(BestS,y,N);
end
display('true value: g=1,h=2,k1=1,k2=0.5');

BestS    %最佳个体
Best_J(kg)%最佳目标函数值

figure(1);%指标函数值变化曲线
plot(time,Best_J(time),'r','linewidth',2);
xlabel('Time');ylabel('Best J');