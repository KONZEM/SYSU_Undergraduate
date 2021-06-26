close all;

figure(1);
plot(t,x1(:,1),'r',t,x1(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('position tracking for link 1');

figure(2);
plot(t,x2(:,1),'r',t,x2(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('position tracking for link 2');

figure(3);
plot(t,tol1(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input of link 1');

figure(4);
plot(t,tol2(:,1),'r','linewidth',2);
xlabel('time(s)');ylabel('control input of link 2');

figure(5);
plot(t,f1(:,1),'r',t,f1(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('f1 and fn1');

figure(6);
plot(t,f2(:,1),'r',t,f2(:,2),'b','linewidth',2);
xlabel('time(s)');ylabel('f2 and fn2');