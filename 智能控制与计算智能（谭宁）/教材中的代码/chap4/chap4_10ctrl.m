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
ut3=-K3*x;
ut4=-K4*x;

L1=-pi;L2=pi;
L=L2-L1;

h=pi/2;
N=L/h;

for i=1:N+1
    e(i)=L1+L/N*(i-1);
end

% w1
w1=trimf(x(1),[e(2),e(3),e(4)]);        %Rule 1:x1 is to zero

% w2, Rule 2: x1 is about +-pi/2,but smaller
if x(1)<=0
   w2=trimf(x(1),[e(2),e(2),e(3)]);
else
   w2=trimf(x(1),[e(3),e(4),e(4)]);      
end

% w3, Rule 3: x1 is about +-pi/2,but bigger
if x(1)<0
    w3=trimf(x(1),[e(1),e(2),e(2)]);
else
    w3=trimf(x(1),[e(4),e(4),e(5)]);
end

% w4, Rule 4: x1 is about +-pi
if x(1)<0
   w4=trimf(x(1),[e(1),e(1),e(2)]); 
else
   w4=trimf(x(1),[e(4),e(5),e(5)]); 
end
w1+w2+w3+w4;
ut=(w1*ut1+w2*ut2+w3*ut3+w4*ut4)/(w1+w2+w3+w4);
sys(1)=ut;