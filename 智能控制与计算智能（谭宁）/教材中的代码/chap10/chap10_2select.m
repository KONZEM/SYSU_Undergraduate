function [pop]=select(pop,c)
[s,t]=size(pop);
m11=(pop(:,t));
m11=m11';
mmax=zeros(1,c);
mmin=zeros(1,c);

num=1;
while num<c+1   %ȡ������c������
   [a,mmax(num)]=max(m11);  %ѡ��ǰ�������ֵ������¼������Ÿ�mmax(num)
   m11(mmax(num))=0;
   num=num+1;
end

num=1;
while num<c+1  %ȡ����С��c������
   [b,mmin(num)]=min(m11);
   m11(mmin(num))=a;
   num=num+1;
end

for i=1:c
   pop(mmax(i),:)=pop(mmin(i),:);  %�þ�����c�������滻����С��c������
end