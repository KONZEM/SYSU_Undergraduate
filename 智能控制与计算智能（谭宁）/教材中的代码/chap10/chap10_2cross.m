function [pop]=chap10_4cross(pop)
[s,t]=size(pop);
pop_1=pop;
n=randperm(s);   %����Ⱥ�������
for i=1:2:s

%ѡ��������������
   m=randperm(t-3)+1;
   crosspoint(1)=min(m(1),m(2));
   crosspoint(2)=max(m(1),m(2));
%����ȡ���н���   
   x1=n(i);
   x2=n(i+1);
%��x1������x2���滥��   
   middle=pop(x1,1:crosspoint(1));
   pop(x1,1:crosspoint(1))=pop(x2,1:crosspoint(1));
   pop(x2,1:crosspoint(1))=middle;
%��x1������x2���滥��   
   middle=pop(x1,crosspoint(2)+1:t);
   pop(x1,crosspoint(2)+1:t)=pop(x2,crosspoint(2)+1:t);
   pop(x2,crosspoint(2)+1:t)=middle;
%���x1������ظ��Բ��õ�x1����
    for j=1:crosspoint(1)
      while find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j))
         zhi=find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j)); %ȷ���ظ���λ��
         temp=pop(x2,crosspoint(1)+zhi);
         pop(x1,j)=temp;
      end
   end
%���x1������ظ��Բ��õ�x1����   
   for j=crosspoint(2)+1:t-1
      while find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j))
         zhi=find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j)); %ȷ���ظ���λ��
         temp=pop(x2,crosspoint(1)+zhi);
         pop(x1,j)=temp;
      end
   end
%���x2������ظ��Բ��õ�x2����
    for j=1:crosspoint(1)
      while find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j))
         zhi=find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j)); %ȷ���ظ���λ��
         temp=pop(x1,crosspoint(1)+zhi);
         pop(x2,j)=temp;
     end
   end
%���x2������ظ��Բ��õ�x2����   
   for j=crosspoint(2)+1:t-1
      while find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j))
         zhi=find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j)); %ȷ���ظ���λ��
         temp=pop(x1,crosspoint(1)+zhi);
         pop(x2,j)=temp;
      end
   end
end
%���ɵ�����Ⱥ�뽻��ǰ�Ƚϣ���ȡ��������
[pop]=chap10_2dis(pop);
for i=1:s
    if pop_1(i,t)<pop(i,t)
       pop(i,:)=pop_1(i,:);
    end
end