%RBF Supervisory Control
clear all;
close all;

ts=0.001;
sys=tf(1000,[1,50,2000]);
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

y_1=0;y_2=0;
u_1=0;u_2=0;
e_1=0;

xi=0;
x=[0,0]';

b=0.5*ones(4,1);
c=[-2 -1 1 2];
w=rands(4,1);
w_1=w;
w_2=w_1;

xite=0.30; 
alfa=0.05;

kp=25;
kd=0.3;
for k=1:1:1000
    time(k)=k*ts;
S=1;
if S==1
   r(k)=0.5*sign(sin(2*2*pi*k*ts));  %Square Signal
elseif S==2
   r(k)=0.5*(sin(3*2*pi*k*ts));      %Square Signal
end

y(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
e(k)=r(k)-y(k);

xi=r(k);
   
for j=1:1:4
    h(j)=exp(-norm(xi-c(:,j))^2/(2*b(j)*b(j)));
end
un(k)=w'*h';
    
%PD Controller
up(k)=kp*x(1)+kd*x(2);

M=2;
if M==1      %Only Using PID Control
   u(k)=up(k); 
elseif M==2  %Total control output
	u(k)=up(k)+un(k);
end

if u(k)>=10
   u(k)=10;
end
if u(k)<=-10
   u(k)=-10;
end   
if k==400
   u(k)=u(k)+6.0;
end

%Update NN Weight
d_w=-xite*(un(k)-u(k))*h';
w=w_1+ d_w+alfa*(w_1-w_2);

w_2=w_1;
w_1=w;
u_2=u_1;
u_1=u(k);
y_2=y_1;
y_1=y(k);

x(1)=e(k);                %Calculating P
x(2)=(e(k)-e_1)/ts;       %Calculating D
e_1=e(k);
end
figure(1);
plot(time,r,'r',time,y,'b');
xlabel('time(s)');ylabel('r and y');
figure(2);
subplot(311);
plot(time,un,'b');
xlabel('time(s)');ylabel('un');
subplot(312);
plot(time,up,'k');
xlabel('time(s)');ylabel('up');
subplot(313);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');