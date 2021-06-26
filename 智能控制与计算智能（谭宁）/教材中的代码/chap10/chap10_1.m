%Generic Algorithm for function f(x1,x2) optimum
clear all;
close all;

%Parameters
Size=80;   
G=100;     
CodeL=10;
 
umax=2.048;
umin=-2.048;

E=round(rand(Size,2*CodeL));    %Initial Code

%Main Program
for k=1:1:G
time(k)=k;

for s=1:1:Size
m=E(s,:);
y1=0;y2=0;

%Uncoding
m1=m(1:1:CodeL);
for i=1:1:CodeL
   y1=y1+m1(i)*2^(i-1);
end
x1=(umax-umin)*y1/1023+umin;
m2=m(CodeL+1:1:2*CodeL);
for i=1:1:CodeL
   y2=y2+m2(i)*2^(i-1);
end
x2=(umax-umin)*y2/1023+umin;

F(s)=100*(x1^2-x2)^2+(1-x1)^2;
end

Ji=1./F;
%****** Step 1 : Evaluate BestJ ******
BestJ(k)=min(Ji);

fi=F;                          %Fitness Function
[Oderfi,Indexfi]=sort(fi);     %Arranging fi small to bigger
Bestfi=Oderfi(Size);           %Let Bestfi=max(fi)
BestS=E(Indexfi(Size),:);      %Let BestS=E(m), m is the Indexfi belong to max(fi)
bfi(k)=Bestfi;

%****** Step 2 : Select and Reproduct Operation******
   fi_sum=sum(fi);
   fi_Size=(Oderfi/fi_sum)*Size;
   
   fi_S=floor(fi_Size);        %Selecting Bigger fi value
   
   kk=1;
   for i=1:1:Size
      for j=1:1:fi_S(i)        %Select and Reproduce 
       TempE(kk,:)=E(Indexfi(i),:);  
         kk=kk+1;              %kk is used to reproduce
      end
   end
   
%************ Step 3 : Crossover Operation ************
pc=0.60;
n=ceil(20*rand);
for i=1:2:(Size-1)
    temp=rand;
    if pc>temp                  %Crossover Condition
    for j=n:1:20
        TempE(i,j)=E(i+1,j);
        TempE(i+1,j)=E(i,j);
    end
    end
end
TempE(Size,:)=BestS;
E=TempE;
   
%************ Step 4: Mutation Operation **************
%pm=0.001;
%pm=0.001-[1:1:Size]*(0.001)/Size; %Bigger fi, smaller Pm
%pm=0.0;    %No mutation
pm=0.1;     %Big mutation

   for i=1:1:Size
      for j=1:1:2*CodeL
         temp=rand;
         if pm>temp                %Mutation Condition
            if TempE(i,j)==0
               TempE(i,j)=1;
            else
               TempE(i,j)=0;
            end
        end
      end
   end
   
%Guarantee TempPop(30,:) is the code belong to the best individual(max(fi))
TempE(Size,:)=BestS;
E=TempE;
end
 
Max_Value=Bestfi
BestS
x1
x2
figure(1);
plot(time,BestJ); 
xlabel('Times');ylabel('Best J');
figure(2);
plot(time,bfi);
xlabel('times');ylabel('Best F');