%Model Reference Aapative RBF Control
clear all;
close all;
    
u_1=0;
y_1=0;
ym_1=0;

x=[0,0,0]';
c=[-3 -2 -1 1 2 3;
   -3 -2 -1 1 2 3;
   -3 -2 -1 1 2 3];
b=2*ones(6,1);
w=rands(6,1);

xite=0.35;
alfa=0.05;
h=[0,0,0,0,0,0]';
 
c_1=c;c_2=c;
b_1=b;b_2=b;
w_1=w;w_2=w;

ts=0.001;
for k=1:1:3000
time(k)=k*ts;

r(k)=0.5*sin(2*pi*k*ts);
ym(k)=0.6*ym_1+r(k);

y(k)=(-0.1*y_1+u_1)/(1+y_1^2);  %Nonlinear plant

for j=1:1:6
    h(j)=exp(-norm(x-c(:,j))^2/(2*b(j)*b(j)));
end
u(k)=w'*h;
      
ec(k)=ym(k)-y(k);
dyu(k)=sign((y(k)-y_1)/(u(k)-u_1));

   d_w=0*w;
   for j=1:1:6
      d_w(j)=xite*ec(k)*h(j)*dyu(k);
   end
   w=w_1+d_w+alfa*(w_1-w_2);
   
   M=1;
   if M==1
   d_b=0*b;
   for j=1:1:6
      d_b(j)=xite*ec(k)*w(j)*h(j)*(b(j)^-3)*norm(x-c(:,j))^2*dyu(k);
   end
   b=b_1+d_b+alfa*(b_1-b_2);
   
   d_c=0*c;
   for j=1:1:6
     for i=1:1:3
      d_c(i,j)=xite*ec(k)*w(j)*h(j)*(x(i)-c(i,j))*(b(j)^-2)*dyu(k);
     end
   end
   c=c_1+d_c+alfa*(c_1-c_2);
   elseif M==2
       b=b_1;
       c=c_1;
   end
%Return of parameters   
   u_1=u(k);
   y_1=y(k);
   ym_1=ym(k);
    
   x(1)=r(k);
   x(2)=ec(k);
   x(3)=y(k);   
   
   w_2=w_1;w_1=w;
   c_2=c_1;c_1=c;
   b_2=b_1;b_1=b;
end
figure(1);
plot(time,ym,'r',time,y,'b');
xlabel('time(s)');ylabel('ym,y');
figure(2);
plot(time,ym-y,'r');
xlabel('time(s)');ylabel('tracking error');