%Define N+1 triangle membership function
clear all;
close all;
N=2;

x=0:0.1:100;
for i=1:N+1
    f(i)=100/N*(i-1);
end

u=trimf(x,[f(1),f(1),f(2)]);
figure(1);
plot(x,u);

for j=2:N
    u=trimf(x,[f(j-1),f(j),f(j+1)]);
    hold on;
    plot(x,u);
end
u=trimf(x,[f(N),f(N+1),f(N+1)]);
hold on;
plot(x,u);
xlabel('x');
ylabel('Degree of membership');