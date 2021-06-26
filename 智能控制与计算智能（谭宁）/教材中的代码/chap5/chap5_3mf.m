clear all;
close all;
 
L1=-pi/3;
L2=pi/3;
L=L2-L1;

T=L*1/1000;

x=L1:T:L2;
figure(1);
for i=1:1:5
    gs=-[(x+pi/3-(i-1)*pi/6)/(pi/12)].^2;
	u=exp(gs);
	hold on;
	plot(x,u);
end
xlabel('x');ylabel('Membership function degree');