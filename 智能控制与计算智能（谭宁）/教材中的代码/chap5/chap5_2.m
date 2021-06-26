%Fuzzy approaching
clear all;
close all;

T=0.1;
x1=-1:T:1;
x2=-1:T:1;

L=2;
h=0.2;
N=L/h+1;

for i=1:1:N     %N MF
  for j=1:1:N
    e1(i)=-1+L/(N-1)*(i-1);
    e2(j)=-1+L/(N-1)*(j-1);
	 gx(i,j)=0.52+0.1*e1(i)^3+0.28*e2(j)^3-0.06*e1(i)*e2(j);
	end
end

df=zeros(L/T+1,L/T+1);
cf=zeros(L/T+1,L/T+1);
for m=1:1:N                       %u1 change from 1 to N
   if m==1
		u1=trimf(x1,[-1,-1,-1+L/(N-1)]);   %First u1
   elseif m==N
		u1=trimf(x1,[1-L/(N-1),1,1]);      %Last u1
   else
   	u1=trimf(x1,[e1(m-1),e1(m),e1(m+1)]); 
   end
figure(1);
hold on;
plot(x1,u1);
xlabel('x1');ylabel('Membership function');

for n=1:1:N                              %u2 change from 1 to N
   if n==1
      u2=trimf(x2,[-1,-1,-1+L/(N-1)]);   %First u2  
   elseif n==N
      u2=trimf(x2,[1-L/(N-1),1,1]);      %Last u2
   else 
      u2=trimf(x2,[e2(n-1),e2(n),e2(n+1)]);
   end
figure(2);
hold on;
plot(x2,u2);
xlabel('x2');ylabel('Membership function');

	for i=1:1:L/T+1
      for j=1:1:L/T+1
        d=df(i,j)+u1(i)*u2(j);
        df(i,j)=d;
        c=cf(i,j)+gx(m,n)*u1(i)*u2(j);
        cf(i,j)=c; 
      end
   end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:L/T+1
    for j=1:1:L/T+1
        f(i,j)=cf(i,j)/df(i,j);
        y(i,j)=0.52+0.1*x1(i)^3+0.28*x2(j)^3-0.06*x1(i)*x2(j);
    end
end
figure(3);
subplot(211);
surf(x1,x2,f);
title('f(x)');
subplot(212);
surf(x1,x2,y);
title('g(x)');
figure(4);
surf(x1,x2,f-y);
title('Approaching error');