%Membership function for Young People
clear all;
close all;

for k=1:1:1001
	x(k)=(k-1)*0.10;
if x(k)>=0&x(k)<=25
   y(k)=1.0;
else
   y(k)=1/(1+((x(k)-25)/5)^2);
end
end
plot(x,y,'k');
xlabel('X Years');ylabel('Degree of membership');
