%Membership function
clear all;
close all;

M=6;
if M==1          %Guassian membership function
	x=0:0.1:10;
	y=gaussmf(x,[2 5]);
	plot(x,y,'k');
	xlabel('x');ylabel('y');
elseif M==2      %General Bell membership function
	x=0:0.1:10;
	y=gbellmf(x,[2 4 6]);
	plot(x,y,'k');
	xlabel('x');ylabel('y');
elseif M==3      %S membership function
	x=0:0.1:10;
	y=sigmf(x,[2 4]);
	plot(x,y,'k');
	xlabel('x');ylabel('y');
elseif M==4      %Trapezoid membership function
	x=0:0.1:10;
	y=trapmf(x,[1 5 7 8]);
	plot(x,y,'k');
	xlabel('x');ylabel('y');
elseif M==5      %Triangle membership function
	x=0:0.1:10;
	y=trimf(x,[3 6 8]);
	plot(x,y,'k');
	xlabel('x');ylabel('y');
elseif M==6      %Z membership function
	x=0:0.1:10;
	y=zmf(x,[3 7]);
	plot(x,y,'k');
	xlabel('x');ylabel('y');
end