clear all;
close all;
load pso1_file;

%�޶�λ�ú��ٶȵķ�Χ
MinX=[0 0 0 0];  %����������Χ
MaxX=[5 5 5 5];
Vmax=1;
Vmin=-1;           % �޶��ٶȵķ�Χ 

%�������Ⱥ����
Size=80;   %��Ⱥ��ģ
CodeL=4;    %��������

c1=1.3;c2=1.7;          % ѧϰ���ӣ�[1,2]
wmax=0.90;wmin=0.10;    % ����Ȩ����Сֵ:(0,1)
G=500;                  % ����������
%(1)��ʼ����Ⱥ�ĸ���
for i=1:G         %����ʱ��Ȩ��
    w(i)=wmax-((wmax-wmin)/G)*i;  
end  
for i=1:1:CodeL       %ʮ���Ƹ����Ʊ���
    X(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1); 
    v(:,i)=Vmin+(Vmax-Vmin)*rand(Size,1);%�����ʼ���ٶ�
end
%��2����ʼ���������ź�ȫ�����ţ��ȼ���������ӵ�Ŀ�꺯��������ʼJi��BestS
for i=1:Size
    Ji(i)=chap10_5obj(X(i,:),y,N);
    Xl(i,:)=X(i,:);     %Xl���ھֲ��Ż�
end

BestS=X(1,:); %ȫ�����Ÿ����ʼ��
for i=2:Size
    if chap10_5obj(X(i,:),y,N)<chap10_5obj(BestS,y,N)
        BestS=X(i,:);
    end
end
%��3��������Ҫѭ����ֱ�����㾫��Ҫ��
 for kg=1:1:G
     times(kg)=kg;
    for i=1:Size
       v(i,:)=w(kg)*v(i,:)+c1*rand*(Xl(i,:)-X(i,:))+c2*rand*(BestS-X(i,:));%��Ȩ��ʵ���ٶȵĸ���
          for j=1:CodeL   %����ٶ��Ƿ�Խ��
            if v(i,j)<Vmin
                v(i,j)=Vmin;
            elseif  v(i,j)>Vmax
                v(i,j)=Vmax;
            end
          end
        X(i,:)=X(i,:)+v(i,:); %ʵ��λ�õĸ���
        for j=1:CodeL%���λ���Ƿ�Խ��
            if X(i,j)<MinX(j)
                X(i,j)=MinX(j);
            elseif X(i,j)>MaxX(j)
                X(i,j)=MaxX(j);
            end
        end         
%����Ӧ����,��������ֲ�����
       if rand>0.8
            k=ceil(4*rand);   %ceilΪ����ȡ��
            X(i,k)=5*rand; 
       end
%��4���жϺ͸���       
       if chap10_5obj(X(i,:),y,N)<Ji(i) %�ֲ��Ż����жϵ���ʱ��λ���Ƿ�Ϊ���ŵ����
          Ji(i)=chap10_5obj(X(i,:),y,N);
          Xl(i,:)=X(i,:);
       end
        
        if Ji(i)<chap10_5obj(BestS,y,N)  %ȫ���Ż�
          BestS=Xl(i,:);
        end
    end
Best_J(kg)=chap10_5obj(BestS,y,N);
end
display('true value: g=1,h=2,k1=1,k2=0.5');

BestS    %��Ѹ���
Best_J(kg)%���Ŀ�꺯��ֵ

figure(1);%Ŀ�꺯��ֵ�仯����
plot(times,Best_J(times),'r','linewidth',2);
xlabel('Times');ylabel('Best J');