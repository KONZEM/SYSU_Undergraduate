%Define N+1 triangle membership function
clear all;
close all;
N=6;

x=-3:0.01:3;
for i=1:N+1
    f(i)=-3+6/N*(i-1);
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
