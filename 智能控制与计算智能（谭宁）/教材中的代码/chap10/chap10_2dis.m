function [pop]=qiujuli(pop)
global x y
[s,t]=size(pop);

for i=1:1:s
   dd=0;
   pos=pop(i,1:t-1);
   pos=[pos pos(:,1)];
   for j=1:1:t-1
        m=pos(j);
        n=pos(j+1);
        dd=dd+sqrt((x(m)-x(n))^2+(y(m)-y(n))^2);
   end
   pop(i,t)=dd;
end