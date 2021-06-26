close all;

figure(1);
plot(t,y(:,1),'r',t,y(:,2),'b');
xlabel('time(s)');ylabel('Position tracking');

figure(2);
plot(t,u(:,1),'r');
xlabel('time(s)');ylabel('Control input');

figure(3);
plot(t,fx(:,1),'r',t,fx(:,2),'b');
xlabel('time(s)');ylabel('fx and estiamted fx');

figure(4);
plot(t,gx(:,1),'r',t,gx(:,2),'b');
xlabel('time(s)');ylabel('gx and estimated gx');