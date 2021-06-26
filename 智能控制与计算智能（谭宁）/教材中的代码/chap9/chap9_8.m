%Discrete RBF control for Motor
clear all;
close all;
ts=0.001;  %Sampling time

node=10;
gama=5;
c=0;
b=4;

h=zeros(node,1);
kp=40;kv=20;
q_1=0;dq_1=0;tol_1=0;
xk=[0 0];
w_1=zeros(node,1);

A=[0   1;
  -kp -kv];
B=[0;1];
Q=[2000 0;
   0 2000];
P=lyap(A',Q);
eig(P);
k1=0.01;
for k=1:1:10000
time(k) = k*ts;

qd(k)=0.50*sin(k*ts);
dqd(k)=0.50*cos(k*ts);
ddqd(k)=-0.50*sin(k*ts);

tSpan=[0 ts];
para=tol_1;            %D/A
[t,xx]=ode45('chap9_8plant',tSpan,xk,[],para);   %Plant
xk=xx(length(xx),:);   %A/D

q(k)=xk(1); 
%dq(k)=xk(2);
dq(k)=(q(k)-q_1)/ts;
ddq(k)=(dq(k)-dq_1)/ts;

e(k)=q(k)-qd(k);
de(k)=dq(k)-dqd(k); 
xi=[e(k);de(k)];
for j=1:1:node
    h(j)=exp(-norm(xi-c)^2/(2*b*b));
end
for i=1:1:node
    S=2;
    if S==1
        w(i,1)=w_1(i,1)+ts*(gama*h(i)*xi'*P*B-k1*gama*norm(xi)*w_1(i,1)); % Adaptive law
    elseif S==2  
        k1=ts*(gama*h(i)*xi'*P*B-k1*gama*norm(xi)*w_1(i,1));
        k2=ts*(gama*h(i)*xi'*P*B-k1*gama*norm(xi)*(w_1(i,1)+1/3*k1));
        k3=ts*(gama*h(i)*xi'*P*B-k1*gama*norm(xi)*(w_1(i,1)+1/6*k1+1/6*k2));
        k4=ts*(gama*h(i)*xi'*P*B-k1*gama*norm(xi)*(w_1(i,1)+1/8*k1+3/8*k3));
        k5=ts*(gama*h(i)*xi'*P*B-k1*gama*norm(xi)*(w_1(i,1)+1/2*k1-3/2*k3+2*k4));
        w(i,1)=w_1(i,1)+1/6*(k1+4*k4+k5);
    end
end
g=9.8;m=1;l=1;
D0=4/3*m*l^2;
d_D=0.8*D0;;
C0=2;
d_C=0.8*C0;
G0(k)=m*g*l*cos(q(k));
d_G(k)=0.8*G0(k);
d(k)=0.5*sin(k*ts);

f(k)=inv(D0)*(d_D*ddq(k)+d_C*dq(k)+d_G(k)+d(k));
fp(k)=w'*h;
% Control input
M=2;
if M==1      %No compensation
    tol(k)=D0*(ddqd(k)-kv*de(k)-kp*e(k))+C0*dq(k)+G0(k);
elseif M==2  %Neural network compensation
    tol(k)=D0*(ddqd(k)-kv*de(k)-kp*e(k))+C0*dq(k)+G0(k)-D0*fp(k);
end
q_1=q(k);
dq_1=dq(k);
w_1=w;
tol_1=tol(k);
end
figure(1);
subplot(211);
plot(time,qd,'r',time,q,'b');
xlabel('time(s)'),ylabel('Position tracking of single link');
subplot(212);
plot(time,qd-q,'r');
xlabel('time(s)'),ylabel('Position tracking error of single link');
figure(2);
plot(time,tol);
xlabel('time(s)'),ylabel('Control input of single link');
if M==2
    figure(3);
    plot(time,f,'r',time,fp,'b');
    xlabel('time(s)'),ylabel('f and fp');
end