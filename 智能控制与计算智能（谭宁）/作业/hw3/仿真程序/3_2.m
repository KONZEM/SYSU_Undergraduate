close;
clear;

a=readfis('fuzzpid');   %Load fuzzpid.fis

ts=0.5;
s = tf('s');
sys = exp(-0.5*s)/(10*s+1);
dsys=c2d(sys,ts,'tustin');
[num,den]=tfdata(dsys,'v');

u_1=0.0;u_2=0.0;
y_1=0;

x=[0,0,0]';

e_1=0;
ec_1=0;

kp0=5;
kd0=1.0;
ki0=0.0;

for k=1:1:500
time(k)=k*ts;

r(k)=30;
%Using fuzzy inference to tunning PID
k_pid=evalfis([e_1,ec_1],a);
kp(k)=kp0+k_pid(1);
ki(k)=ki0+k_pid(2);
kd(k)=kd0+k_pid(3);
u(k)=kp(k)*x(1)+kd(k)*x(2)+ki(k)*x(3)+60;

y(k)=-den(2)*y_1+num(2)*u_2;
e(k)=r(k)-y(k);
%%%%%%%%%%%%%%Return of PID parameters%%%%%%%%%%%%%%%
   u_2=u_1;
   u_1=u(k);
   
   y_1=y(k);
   
   x(1)=e(k);            % Calculating P
   x(2)=e(k)-e_1;        % Calculating D
   x(3)=x(3)+e(k)*ts;    % Calculating I

   ec_1=x(2);
   e_2=e_1;
   e_1=e(k);
%    disp(ec_1);
end

figure(1);
plot(time,r,'b',time,y,'r');
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,e,'r');
xlabel('time(s)');ylabel('error');
% figure(3);
% plot(time,u,'r');
% xlabel('time(s)');ylabel('u');
% figure(4);
% plot(time,kp,'r');
% xlabel('time(s)');ylabel('kp');
% figure(5);
% plot(time,ki,'r');
% xlabel('time(s)');ylabel('ki');
% figure(6);
% plot(time,kd,'r');
% xlabel('time(s)');ylabel('kd');