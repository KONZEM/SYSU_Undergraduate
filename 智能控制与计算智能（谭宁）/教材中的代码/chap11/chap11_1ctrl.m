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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 8;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0 0];
function sys=mdlOutputs(t,x,u)
q1d=u(1);dq1d=u(2);
q2d=u(3);dq2d=u(4);

q1=u(5);dq1=u(6);
q2=u(7);dq2=u(8);

e1=q1d-q1;
e2=q2d-q2;
e=[e1 e2]';
de1=dq1d-dq1;
de2=dq2d-dq2;
de=[de1 de2]';

Kp=[100 0;0 100];
Kd=[500 0;0 500];

M=2;
if M==1
    Tol=Kd*de;       %D Type
elseif M==2
    Tol=Kp*e+Kd*de;  %PD Type
elseif M==3
    Tol=Kd*exp(0.8*t)*de;  %Exponential Gain D Type
end
sys(1)=Tol(1);
sys(2)=Tol(2);