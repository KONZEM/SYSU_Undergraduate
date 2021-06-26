clear all;
close all;

g=9.8;m=2.0;M=8.0;l=0.5;
a=l/(m+M);beta=cos(88*pi/180);

a1=4*l/3-a*m*l;
A1=[0 1;g/a1 0];
B1=[0 ;-a/a1];

a2=4*l/3-a*m*l*beta^2;

A2=[0 1;2*g/(pi*a2) 0];
B2=[0;-a*beta/a2];

A3=[0 1;2*g/(pi*a2) 0];
B3=[0;a*beta/a2];

A4=[0 1;0 0];
B4=[0;a/a1];

P=[-3-3i;-3+3i];     %Stable poles
K1=place(A1,B1,P)
K2=place(A2,B2,P)
K3=place(A3,B3,P)
K4=place(A4,B4,P)

save K_file K1 K2 K3 K4;