function [pop]=select(pop,c)
[s,t]=size(pop);
m11=(pop(:,t));
m11=m11';
mmax=zeros(1,c);
mmin=zeros(1,c);

num=1;
while num<c+1   %取距离大的c个样本
   [a,mmax(num)]=max(m11);  %选择当前样本最大值，并纪录样本编号给mmax(num)
   m11(mmax(num))=0;
   num=num+1;
end

num=1;
while num<c+1  %取距离小的c个样本
   [b,mmin(num)]=min(m11);
   m11(mmin(num))=a;
   num=num+1;
end

for i=1:c
   pop(mmax(i),:)=pop(mmin(i),:);  %用距离大的c个样本替换距离小的c个样本
end