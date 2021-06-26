%Fuzzy PID Control
close all;
clear all;

a=readfis('fuzzpid');   %Load fuzzpid.fis

ts=0.001;
sys=tf(5.235e005,[1,87.35,1.047e004,0]);
dsys=c2d(sys,ts,'tustin');
[num,den]=tfdata(dsys,'v');

u_1=0.0;u_2=0.0;u_3=0.0;
y_1=0;y_2=0;y_3=0;

x=[0,0,0]';

e_1=0;
ec_1=0;

kp0=0.40;
kd0=1.0;
ki0=0.0;

for k=1:1:3000
time(k)=k*ts;

r(k)=sign(sin(2*pi*k*ts));
%Using fuzzy inference to tunning PID
k_pid=evalfis([e_1,ec_1],a);
kp(k)=kp0+k_pid(1);
ki(k)=ki0+k_pid(2);
kd(k)=kd0+k_pid(3);
u(k)=kp(k)*x(1)+kd(k)*x(2)+ki(k)*x(3);

if k==300     % Adding disturbance(1.0v at time 0.3s)
   u(k)=u(k)+1.0;
end

y(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(1)*u(k)+num(2)*u_1+num(3)*u_2+num(4)*u_3;
e(k)=r(k)-y(k);
%%%%%%%%%%%%%%Return of PID parameters%%%%%%%%%%%%%%%
   u_3=u_2;
   u_2=u_1;
   u_1=u(k);
   
   y_3=y_2;
   y_2=y_1;
   y_1=y(k);
   
   x(1)=e(k);            % Calculating P
   x(2)=e(k)-e_1;        % Calculating D
   x(3)=x(3)+e(k)*ts;    % Calculating I

   ec_1=x(2);
   e_2=e_1;
   e_1=e(k);
end

figure(1);
plot(time,r,'b',time,y,'r');
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,e,'r');
xlabel('time(s)');ylabel('error');
figure(3);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');
figure(4);
plot(time,kp,'r');
xlabel('time(s)');ylabel('kp');
figure(5);
plot(time,ki,'r');
xlabel('time(s)');ylabel('ki');
figure(6);
plot(time,kd,'r');
xlabel('time(s)');ylabel('kd');