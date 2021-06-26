function dx=Plant(t,x,flag,para)
dx=zeros(2,1);
g=9.8;m=1;l=1;

D0=4/3*m*l^2;
d_D=0.8*D0;
C0=2;
d_C=0.8*C0;
G0=m*g*l*cos(x(1));
d_G=0.8*G0;

D=D0-d_D;
C=C0-d_C;
G=G0-d_G;
d=0.5*sin(t);

tol=para;

dx(1)=x(2);
dx(2)=inv(D)*(tol+d-C*x(2)-G);