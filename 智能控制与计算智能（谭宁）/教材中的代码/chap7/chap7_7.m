%RBF function
clear all;
close all;

c=[-3 -1.5 0 1.5 3];

M=1;
if M==1
    b=0.50*ones(5,1);
elseif M==2
    b=1.50*ones(5,1);
end

h=[0,0,0,0,0]';

ts=0.001;
for k=1:1:2000
   
time(k)=k*ts;

%RBF function
x(1)=3*sin(2*pi*k*ts);
   
for j=1:1:5
    h(j)=exp(-norm(x-c(:,j))^2/(2*b(j)*b(j)));
end

x1(k)=x(1);
%First Redial Basis Function
h1(k)=h(1);
%Second Redial Basis Function
h2(k)=h(2);
%Third Redial Basis Function
h3(k)=h(3);
%Fourth Redial Basis Function
h4(k)=h(4);
%Fifth Redial Basis Function
h5(k)=h(5);
end
figure(1);
plot(x1,h1,'b');
figure(2);
plot(x1,h2,'g');
figure(3);
plot(x1,h3,'r');
figure(4);
plot(x1,h4,'c');
figure(5);
plot(x1,h5,'m');
figure(6);
plot(x1,h1,'b');
hold on;plot(x1,h2,'g');
hold on;plot(x1,h3,'r');
hold on;plot(x1,h4,'c');
hold on;plot(x1,h5,'m');
xlabel('Input value of Redial Basis Function');ylabel('Membership function degree');