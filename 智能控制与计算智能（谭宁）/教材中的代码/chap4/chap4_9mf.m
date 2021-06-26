clear all;
close all;
L1=-pi/2;L2=pi/2;
L=L2-L1;

h=pi/2;
N=L/h;
T=0.01;

x=L1:T:L2;
for i=1:N+1
    e(i)=L1+L/N*(i-1);
end
w=trimf(x,[e(1),e(2),e(3)]);              %The middle MF
plot(x,w,'r','linewidth',2);

for j=1:N
   if j==1
		w=trimf(x,[e(1),e(1),e(2)]);      %The first MF
   elseif j==N
		w=trimf(x,[e(N),e(N+1),e(N+1)]);  %The last MF
   end
   hold on;
   plot(x,w,'b','linewidth',2);
end
xlabel('x');ylabel('Membership function');
legend('First Rule','Second rule');