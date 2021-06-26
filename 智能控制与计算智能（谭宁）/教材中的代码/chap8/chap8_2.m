%CMAC Approximation for nonlinear model
clear all;
close all;

xite=0.20;
alfa=0.05;

M=500;
N=100;
c=3;

w=zeros(N,1);
w_1=w;w_2=w;d_w=w;
u_1=0;y_1=0;
ts=0.05;
for k=1:1:200
time(k)=k*ts;

u(k)=sign(sin(k*ts));

xmin=-1.0; 
xmax=1.0;

for i=1:1:c
    s(k,i)=round((u(k)-xmin)*M/(xmax-xmin))+i;   %Quantity:U-->AC
    ad(i)=mod(s(k,i),N)+1;          %Hash transfer:AC-->AP
end

sum=0;
for i=1:1:c
   sum=sum+w(ad(i));
end
yn(k)=sum;
y(k)=u_1^3+y_1/(1+y_1^2);   %Nonlinear model

error(k)=y(k)-yn(k);
for i=1:1:c
  ad(i)=mod(s(k,i),N)+1;
  j=ad(i);
  d_w(j)=xite*error(k);
  w(j)=w_1(j)+d_w(j)+alfa*(w_1(j)-w_2(j));
end
%%%% Parameters Update %%%%
w_2=w_1;w_1=w;
u_1=u(k);
y_1=y(k);
end
figure(1);
subplot(211);
plot(time,y,'b',time,yn,'r');
xlabel('time(s)');ylabel('y,yn');
subplot(212);
plot(time,y-yn,'k');
xlabel('time(s)');ylabel('error');