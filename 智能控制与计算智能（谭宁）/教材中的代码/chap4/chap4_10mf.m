clear all;
close all;
L1=-pi;L2=pi;
L=L2-L1;

h=pi/2;
N=L/h;
T=0.01;

x=L1:T:L2;
for i=1:N+1
    e(i)=L1+L/N*(i-1);
end
figure(2);
% w1
w1=trimf(x,[e(2),e(3),e(4)]);        %Rule 1:x1 is to zero
plot(x,w1,'r','linewidth',2);
% w2, Rule 2: x1 is about +-pi/2,but smaller
   w2=trimf(x,[e(2),e(2),e(3)]);
hold on
plot(x,w2,'b','linewidth',2);
   w2=trimf(x,[e(3),e(4),e(4)]);      
hold on
plot(x,w2,'b','linewidth',2);

% w3, Rule 3: x1 is about +-pi/2,but bigger
    w3=trimf(x,[e(1),e(2),e(2)]);
hold on;
plot(x,w3,'g','linewidth',2);
    w3=trimf(x,[e(4),e(4),e(5)]);
hold on;
plot(x,w3,'g','linewidth',2);

% w4, Rule 4: x1 is about +-pi
    w4=trimf(x,[e(1),e(1),e(2)]); 
    hold on;
    plot(x,w4,'k','linewidth',2);
    w4=trimf(x,[e(4),e(5),e(5)]); 
    hold on;
 plot(x,w4,'k','linewidth',2);