%To Get maximum value of function f(x1,x2) by Differential Evolution
clear all;
close all;

Size=30;
CodeL=2;

MinX(1)=-2.048;
MaxX(1)=2.048;
MinX(2)=-2.048;
MaxX(2)=2.048;

G=50;

F=1.2;              %��������[0,2]
cr=0.9;             %��������[0.6,0.9]
%��ʼ����Ⱥ
for i=1:1:CodeL       
    P(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1);
end

BestS=P(1,:); %ȫ�����Ÿ���
for i=2:Size
        if(chap10_6obj( P(i,1),P(i,2))>chap10_6obj( BestS(1),BestS(2)))
        BestS=P(i,:);
    end
end

fi=chap10_6obj( BestS(1),BestS(2));
 
%������Ҫѭ����ֱ�����㾫��Ҫ��
 for kg=1:1:G
     time(kg)=kg;
%����
    for i=1:Size
        r1 = 1;r2=1;r3=1;
        while(r1 == r2|| r1 == r3 || r2 == r3 || r1 == i || r2 ==i || r3 == i )
            r1 = ceil(Size * rand(1));
             r2 = ceil(Size * rand(1));
              r3 = ceil(Size * rand(1));
        end
        h(i,:) = P(r1,:)+F*(P(r2,:)-P(r3,:));

        for j=1:CodeL%���λ���Ƿ�Խ��
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
                  v(i,j) = P(i,j);
              end
        end
        
%ѡ��        
        if(chap10_6obj( v(i,1),v(i,2))>chap10_6obj( P(i,1),P(i,2)))
            P(i,:)=v(i,:);
        end
%�жϺ͸���       
       if(chap10_6obj( P(i,1),P(i,2))>fi) %�жϵ���ʱ��λ���Ƿ�Ϊ���ŵ����
          fi=chap10_6obj( P(i,1),P(i,2));
          BestS=P(i,:);
        end
    end
Best_f(kg)=chap10_6obj( BestS(1),BestS(2));
end
BestS     %��Ѹ���
Best_f(kg)%�����ֵ

figure(1);
plot(time,Best_f(time),'k','linewidth',2);
xlabel('Times');ylabel('Best f');