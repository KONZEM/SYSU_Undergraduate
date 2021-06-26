clear all;
close all;
%��1����ʼ������Ⱥ�㷨����
min=-2.048;max=2.048;%����λ�÷�Χ
Vmax=1;Vmin=-1;%�����˶��ٶȷ�Χ
c1=1.3;c2=1.7;  %ѧϰ����[0��4]

wmin=0.10;wmax=0.90;%����Ȩ��
G=100;          % ����������
Size=50;        %��ʼ��Ⱥ�������Ŀ

for i=1:G
    w(i)=wmax-((wmax-wmin)/G)*i;  %�����Ż����У�Ӧ��������Ȩ��
end  

for i=1:Size
    for j=1:2
        x(i,j)=min+(max-min)*rand(1);     %�����ʼ��λ��
        v(i,j)=Vmin +(Vmax-Vmin)*rand(1); %�����ʼ���ٶ�
    end
end

%��2������������ӵ���Ӧ�ȣ�����ʼ��Pi��plocal�����Ÿ���BestS
for i=1:Size
    p(i)=chap10_3func(x(i,:));
    y(i,:)=x(i,:);
    
    if i==1
        plocal(i,:)=chap10_3lbest(x(Size,:),x(i,:),x(i+1,:));
    elseif i==Size
        plocal(i,:)=chap10_3lbest(x(i-1,:),x(i,:),x(1,:));
        else 
        plocal(i,:)=chap10_3lbest(x(i-1,:),x(i,:),x(i+1,:));
    end
end

BestS=x(1,:);%��ʼ�����Ÿ���BestS
for i=2:Size
    if chap10_3func(x(i,:))>chap10_3func(BestS)
        BestS=x(i,:);
    end
end

%��3��������ѭ��
for kg=1:G
    for i=1:Size
        
      M=1;
      if M==1
         v(i,:)=w(kg)*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(plocal(i,:)-x(i,:));%�ֲ�Ѱ�ţ���Ȩ��ʵ���ٶȵĸ���
      elseif M==2
         v(i,:)=w(kg)*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(BestS-x(i,:));      %ȫ��Ѱ�ţ���Ȩ��ʵ���ٶȵĸ���
      end
          for j=1:2   %����ٶ��Ƿ�Խ��
            if v(i,j)<Vmin
                v(i,j)=Vmin;
            elseif  x(i,j)>Vmax
                v(i,j)=Vmax;
            end
          end
        x(i,:)=x(i,:)+v(i,:)*1; %ʵ��λ�õĸ���
        for j=1:2   %���λ���Ƿ�Խ��
            if x(i,j)<min
                x(i,j)=min;
            elseif  x(i,j)>max
                x(i,j)=max;
            end
        end         
%����Ӧ����,��������Ⱥ�㷨����ֲ�����
       if rand>0.60
            k=ceil(2*rand);
            x(i,k)=min+(max-min)*rand(1);
       end
%��4���жϺ͸���
       if i==1
            plocal(i,:)=chap10_3lbest(x(Size,:),x(i,:),x(i+1,:));
        elseif i==Size
            plocal(i,:)=chap10_3lbest(x(i-1,:),x(i,:),x(1,:));
        else 
            plocal(i,:)=chap10_3lbest(x(i-1,:),x(i,:),x(i+1,:));
        end
       
       if chap10_3func(x(i,:))>p(i) %�жϵ���ʱ��λ���Ƿ�Ϊ���ŵ��������������ʱ��������
          p(i)=chap10_3func(x(i,:));
          y(i,:)=x(i,:);
        end
        if p(i)>chap10_3func(BestS)
            BestS=y(i,:);
        end
    end
Best_value(kg)=chap10_3func(BestS);
end
figure(1);
kg=1:G;
plot(kg,Best_value,'r','linewidth',2);
xlabel('generations');ylabel('Fitness function');
display('Best Sample=');disp(BestS);
display('Biggest value=');disp(Best_value(G));