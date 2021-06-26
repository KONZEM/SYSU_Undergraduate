%Single Neural Adaptive Controller
clear all;
close all;

x=[0,0,0]';

xite=0.40;

w1_1=0.10;
w2_1=0.10;
w3_1=0.10;

e_1=0;
e_2=0; 
y_1=0;y_2=0;
u_1=0;u_2=0;

ts=0.001;
for k=1:1:1000
    time(k)=k*ts;
    r(k)=0.5*sign(sin(2*2*pi*k*ts));
    y(k)=0.368*y_1+0.26*y_2+0.1*u_1+0.632*u_2;
    e(k)=r(k)-y(k);
   
%Adjusting Weight Value by supervised Heb learning algorithm 
   w1(k)=w1_1+xite*e(k)*u_1*x(1);
   w2(k)=w2_1+xite*e(k)*u_1*x(2);
   w3(k)=w3_1+xite*e(k)*u_1*x(3);
   K=0.12;   
   
   x(1)=e(k)-e_1;
   x(2)=e(k);
   x(3)=e(k)-2*e_1+e_2;

   w=[w1(k),w2(k),w3(k)];
	u(k)=u_1+K*w*x;        %Control law

e_2=e_1;
e_1=e(k);
   
u_2=u_1;u_1=u(k);
y_2=y_1;y_1=y(k);
   
w1_1=w1(k);
w2_1=w2(k);
w3_1=w3(k);
end
figure(1);
plot(time,r,'b',time,y,'r');
xlabel('time(s)');ylabel('Position tracking');
figure(2);
plot(time,e,'r');
xlabel('time(s)');ylabel('error');
figure(3);
plot(time,w1,'r');
xlabel('time(s)');ylabel('w1');
figure(4);
plot(time,w2,'r');
xlabel('time(s)');ylabel('w2');
figure(5);
plot(time,w3,'r');
xlabel('time(s)');ylabel('w3');