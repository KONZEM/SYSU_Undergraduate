function [pop]=mutate(pop)
[s,t]=size(pop);

pop_1=pop;
for i=1:2:s
   m=randperm(t-3)+1;
%���ȡ������
   mutatepoint(1)=min(m(1),m(2));
   mutatepoint(2)=max(m(1),m(2));
%���õ��ñ��췽����������������м䲿��λ��
   mutate=round((mutatepoint(2)-mutatepoint(1))/2-0.5);
   for j=1:mutate
      zhong=pop(i,mutatepoint(1)+j);
      pop(i,mutatepoint(1)+j)=pop(i,mutatepoint(2)-j);
      pop(i,mutatepoint(2)-j)=zhong;
   end
end

[pop]=chap10_2dis(pop);%���ɵ�����Ⱥ�����ǰ�Ƚϣ���ȡ��������
for i=1:s
   if pop_1(i,t)<pop(i,t)
      pop(i,:)=pop_1(i,:);
   end
end