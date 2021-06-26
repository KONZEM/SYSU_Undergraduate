close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,y(:,1)-y(:,2),'r');
xlabel('time(s)');ylabel('Position tracking error');

figure(3);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');