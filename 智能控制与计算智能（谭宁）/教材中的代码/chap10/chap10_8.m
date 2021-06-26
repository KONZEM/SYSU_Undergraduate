clear all;
close all;
load de1_file;

MinX=[0 0 0 0];  %����������Χ
MaxX=[5 5 5 5];

%�������Ⱥ����
Size=80;   %��Ⱥ��ģ
CodeL=4;   %��������

F= 0.80;        % �������ӣ�[1,2]
cr =0.6;      % ��������
G=500;              % ���������� 
%��ʼ����Ⱥ�ĸ���
for i=1:1:CodeL       
    X(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1);
end

BestS=X(1,:); %ȫ�����Ÿ���
for i=2:Size
    if chap10_8obj(X(i,:),y,N)<chap10_8obj(BestS,y,N)        
        BestS=X(i,:);
    end
end
Ji=chap10_8obj(BestS,y,N);
%������Ҫѭ����ֱ�����㾫��Ҫ��
for kg=1:1:G
     time(kg)=kg;
%����
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

        for j=1:CodeL  %���ֵ�Ƿ�Խ��
            if h(i,j)<MinX(j)
                h(i,j)=MinX(j);
            elseif h(i,j)>MaxX(j)
                h(i,j)=MaxX(j);
            end
        end        
%����
        for j = 1:1:CodeL
              tempr = rand(1);
              if(tempr<cr)
                  v(i,j) = h(i,j);
               else
                  v(i,j) = X(i,j);
               end
        end
%ѡ��        
        if(chap10_8obj(v(i,:),y,N)<chap10_8obj(X(i,:),y,N))
            X(i,:)=v(i,:);
        end
%�жϺ͸���       
       if chap10_8obj(X(i,:),y,N)<Ji %�жϵ���ʱ��ָ���Ƿ�Ϊ���ŵ����
          Ji=chap10_8obj(X(i,:),y,N);
          BestS=X(i,:);
        end
    end
Best_J(kg)=chap10_8obj(BestS,y,N);
end
display('true value: g=1,h=2,k1=1,k2=0.5');

BestS    %��Ѹ���
Best_J(kg)%���Ŀ�꺯��ֵ

figure(1);%ָ�꺯��ֵ�仯����
plot(time,Best_J(time),'r','linewidth',2);
xlabel('Time');ylabel('Best J');