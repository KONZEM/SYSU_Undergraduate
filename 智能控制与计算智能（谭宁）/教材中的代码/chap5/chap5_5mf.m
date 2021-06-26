clear all;
close all;
 
L1=-3;
L2=3;
L=L2-L1;

T=0.001;

x=L1:T:L2;
figure(1);
for i=1:1:6
   if i==1
      u=1./(1+exp(5*(x+2)));
   elseif i==6
      u=1./(1+exp(-5*(x-2)));
   else
   u=exp(-(x+2.5-(i-1)).^2);
end
	hold on;
	plot(x,u);
end
xlabel('x');ylabel('Membership function degree');