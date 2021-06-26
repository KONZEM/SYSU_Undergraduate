%BP Training for MIMO and Multi-samples
clear all;
close all;

xite=0.50;
alfa=0.05;

w2=rands(6,2);
w2_1=w2;w2_2=w2_1;

w1=rands(3,6);
w1_1=w1;w1_2=w1;
dw1=0*w1;

I=[0,0,0,0,0,0]';
Iout=[0,0,0,0,0,0]';
FI=[0,0,0,0,0,0]';

OUT=2;
k=0;
E=1.0;
NS=3;

while E>=1e-020
k=k+1;   
times(k)=k;

for s=1:1:NS   %MIMO Samples  
xs=[1,0,0;
   0,1,0;
   0,0,1];     %Ideal Input
ys=[1,0;
   0,0.5;
   0,1];       %Ideal Output

x=xs(s,:);
for j=1:1:6   
    I(j)=x*w1(:,j);
    Iout(j)=1/(1+exp(-I(j)));
end

yl=w2'*Iout;
yl=yl';

el=0;
y=ys(s,:);
for l=1:1:OUT
   el=el+0.5*(y(l)-yl(l))^2;    %Output error
end
es(s)=el;

E=0;
if s==NS
   for s=1:1:NS
      E=E+es(s);
   end
end
ey=y-yl;

w2=w2_1+xite*Iout*ey+alfa*(w2_1-w2_2);

for j=1:1:6
   S=1/(1+exp(-I(j)));
   FI(j)=S*(1-S);
end

for i=1:1:3
   for j=1:1:6
       dw1(i,j)=xite*FI(j)*x(i)*(ey(1)*w2(j,1)+ey(2)*w2(j,2));
   end
end
w1=w1_1+dw1+alfa*(w1_1-w1_2);

w1_2=w1_1;w1_1=w1;
w2_2=w2_1;w2_1=w2;
end   %End of for
Ek(k)=E;
end   %End of while
figure(1);
plot(times,Ek,'r');
xlabel('k');ylabel('E');

save wfile w1 w2;