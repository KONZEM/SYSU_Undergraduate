function [pop]=mutate(pop)
[s,t]=size(pop);

pop_1=pop;
for i=1:2:s
   m=randperm(t-3)+1;
%随机取两个点
   mutatepoint(1)=min(m(1),m(2));
   mutatepoint(2)=max(m(1),m(2));
%采用倒置变异方法法倒置两个点的中间部分位置
   mutate=round((mutatepoint(2)-mutatepoint(1))/2-0.5);
   for j=1:mutate
      zhong=pop(i,mutatepoint(1)+j);
      pop(i,mutatepoint(1)+j)=pop(i,mutatepoint(2)-j);
      pop(i,mutatepoint(2)-j)=zhong;
   end
end

[pop]=chap10_2dis(pop);%生成的新种群与变异前比较，并取两者最优
for i=1:s
   if pop_1(i,t)<pop(i,t)
      pop(i,:)=pop_1(i,:);
   end
end