clear all;
close all;

x_min=-2.048;
x_max=2.048;

L=x_max-x_min;
N=101;
for i=1:1:N 
   for j=1:1:N
       x1(i)=x_min+L/(N-1)*(i-1);   %在x1轴上取100点
       x2(j)=x_min+L/(N-1)*(j-1);   %在x2轴上取100点
 	   fx(i,j)=100*(x1(i)^2-x2(j))^2+(1-x1(i))^2;
 	end
 end
figure(1);
surf(x1,x2,fx);
title('f(x)');

display('Maximum value of fx=');
disp(max(max(fx)));