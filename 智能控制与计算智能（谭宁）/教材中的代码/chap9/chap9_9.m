%Discrete controller
clear all;
close all;
ts=0.001;

c1=-0.01;
u_1=0;y_1=0;
fx_1=0;
for k=1:1:20000
time(k)=k*ts;

yd(k)=sin(k*ts);
yd1=sin((k+1)*ts);
%Nonlinear plant
fx(k)=0.5*y_1*(1-y_1)/(1+exp(-0.25*y_1));
y(k)=fx_1+u_1;

e(k)=y(k)-yd(k);

u(k)=yd1-fx(k)-c1*e(k);

y_1=y(k);
u_1=u(k);
fx_1=fx(k);
end
figure(1);
plot(time,yd,'r',time,y,'k:','linewidth',2);
xlabel('time(s)');ylabel('yd,y');
legend('Ideal position signal','Position tracking');
figure(2);
plot(time,u,'r','linewidth',2);
xlabel('time(s)');ylabel('Control input');