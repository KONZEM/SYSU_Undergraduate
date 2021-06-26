function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
x=[u(1);u(2)];

load K_file;
ut1=-K1*x;
ut2=-K2*x;

L1=-pi/2;L2=pi/2;
L=L2-L1;

N=2;   
for i=1:N+1
    e(i)=L1+L/N*(i-1);
end

w1=trimf(x(1),[e(1),e(2),e(3)]);        %The middle
if x(1)<=0
   w2=trimf(x(1),[e(1),e(1),e(2)]);     %The first 
else
   w2=trimf(x(1),[e(2),e(3),e(3)]);     %The last
end
%h1+h2
ut=(w1*ut1+w2*ut2)/(w1+w2);
sys(1)=ut;