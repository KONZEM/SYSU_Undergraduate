clear all;
close all;
 
L1=-pi/6;
L2=pi/6;
L=L2-L1;

T=L*1/1000;

x=L1:T:L2;
figure(1);
for i=1:1:5
   gs=-[(x+pi/6-(i-1)*pi/12)/(pi/24)].^2;
	u=exp(gs);
	hold on;
	plot(x,u);
end
xlabel('x');ylabel('Membership function degree');