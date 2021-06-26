%Fuzzy approaching
clear all;
close all;

L1=-3;L2=3;
L=L2-L1;

h=0.2;
N=L/h+1;
T=0.01;

x=L1:T:L2;
for i=1:N
    e(i)=L1+L/(N-1)*(i-1);
end

c=0;d=0;
for j=1:N
   if j==1
		u=trimf(x,[e(1),e(1),e(2)]);      %The first MF
   elseif j==N
		u=trimf(x,[e(N-1),e(N),e(N)]);  %The last MF
	else
	   u=trimf(x,[e(j-1),e(j),e(j+1)]);
   end
   hold on;
   plot(x,u);
   c=c+sin(e(j))*u;
   d=d+u;
end
xlabel('x');ylabel('Membership function');

for k=1:L/T+1
    f(k)=c(k)/d(k);
end
    
y=sin(x);
figure(2);
plot(x,f,'b',x,y,'r');
xlabel('x');ylabel('Approaching');
figure(3);
plot(x,f-y,'r'); 
xlabel('x');ylabel('Approaching error');