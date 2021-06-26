%Fuzzy RBF Approximation
clear all;
close all;

xite=0.50;
alfa=0.05;

bj=1.0;
c=[-1 -0.5 0 0.5 1;
   -1.5 -1 0 1 1.5];
w=rands(25,1);

w_1=w;
w_2=w_1;

u_1=0.0;
y_1=0.0;

ts=0.001;
for k=1:1:50000
time(k)=k*ts;
   
u(k)=sin(0.1*k*ts);
y(k)=u(k)+y_1/(1+y_1^2);

x=[u(k),y(k)]';                     % Layer1:input
f1=x;                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:2                         % Layer2:fuzzation
   for j=1:1:5
      net2(i,j)=-(f1(i)-c(i,j))^2/bj^2;
   end
end
for i=1:1:2
   for j=1:1:5
   f2(i,j)=exp(net2(i,j));
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:1:5                        % Layer3:fuzzy inference(49 rules)
    m1(j)=f2(1,j);
	m2(j)=f2(2,j);
end

for i=1:1:5
	for j=1:1:5
   	 ff3(i,j)=m2(i)*m1(j);
	end
end
f3=[ff3(1,:),ff3(2,:),ff3(3,:),ff3(4,:),ff3(5,:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f4=w_1'*f3';                      % Layer4:output
ym(k)=f4;                   

e(k)=y(k)-ym(k);

d_w=0*w_1;
for j=1:1:25
    d_w(j)=xite*e(k)*f3(j);
end
w=w_1+d_w+alfa*(w_1-w_2);
  
   u_1=u(k);
   y_1=y(k);
   
   w_2=w_1;
   w_1=w;
end
figure(1);
plot(time,y,'r',time,ym,'-.b','linewidth',2);
xlabel('time(s)');ylabel('Approximation');
legend('y','ym');
figure(2);
plot(time,y-ym,'r','linewidth',2);
xlabel('time(s)');ylabel('Approximation error');
legend('y-ym');