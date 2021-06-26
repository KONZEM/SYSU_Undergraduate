close all;

figure(1);
plot(t,x(:,1),'r',t,x(:,2),'b');
xlabel('time(s)');ylabel('angle and angle speed response');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('control input');