%RBF approximation test
clear all;
close all;

alfa=0.05;
xite=0.3;
x=[0,0]';

%The parameters design of Guassian Function
%The input of RBF (u(k),y(k)) must be in the effect range of Guassian function overlay
%The value of b represents the widenth of Guassian function overlay

bj=1.5;    %The width of Guassian function
%The value of c represents the center position of Guassian function overlay
%the NN structure is 2-m-1: i=2; j=1,2,...,m; k=1
M=3;   %Different hidden nets number
if M==1   %only one hidden net
m=1;
c=0;
elseif M==2    
m=3;
c=1/3*[-1 0 1;
      -1 0 1];
elseif M==3
m=7;
c=1/9*[-3 -2 -1 0 1 2 3;
       -3 -2 -1 0 1 2 3];
end
w=zeros(m,1);
w_1=w;w_2=w_1;
y_1=0;

ts=0.001;
for k=1:1:5000
   
time(k)=k*ts;
u(k)=sin(k*ts);

y(k)=u(k)^3+y_1/(1+y_1^2);  

x(1)=u(k);
x(2)=y(k);
   
for j=1:1:m
    h(j)=exp(-norm(x-c(:,j))^2/(2*bj^2));
end
ym(k)=w'*h';
em(k)=y(k)-ym(k);

d_w=xite*em(k)*h';
w=w_1+ d_w+alfa*(w_1-w_2);
   
y_1=y(k);
w_2=w_1;w_1=w;

x1(k)=x(1);
for j=1:1:m
    H(j,k)=h(j);
end

if k==5000
    figure(1);
    for j=1:1:m
        plot(x1,H(j,:),'linewidth',2);
        hold on;
    end
    xlabel('Input value of Redial Basis Function');ylabel('Membership function degree');
end
end
figure(2);
subplot(211);
plot(time,y,'r',time,ym,'b:','linewidth',2);
xlabel('time(s)');ylabel('y and ym');
legend('Ideal value','Approximation value');
subplot(212);
plot(time,y-ym,'r','linewidth',2);
xlabel('time(s)');ylabel('Approximation error');