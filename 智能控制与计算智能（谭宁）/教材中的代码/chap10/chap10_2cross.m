function [pop]=chap10_4cross(pop)
[s,t]=size(pop);
pop_1=pop;
n=randperm(s);   %将种群随机排序
for i=1:2:s

%选择两个随机交叉点
   m=randperm(t-3)+1;
   crosspoint(1)=min(m(1),m(2));
   crosspoint(2)=max(m(1),m(2));
%任意取两行交叉   
   x1=n(i);
   x2=n(i+1);
%将x1左面与x2左面互换   
   middle=pop(x1,1:crosspoint(1));
   pop(x1,1:crosspoint(1))=pop(x2,1:crosspoint(1));
   pop(x2,1:crosspoint(1))=middle;
%将x1右面与x2右面互换   
   middle=pop(x1,crosspoint(2)+1:t);
   pop(x1,crosspoint(2)+1:t)=pop(x2,crosspoint(2)+1:t);
   pop(x2,crosspoint(2)+1:t)=middle;
%检查x1左面的重复性并得到x1左面
    for j=1:crosspoint(1)
      while find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j))
         zhi=find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j)); %确定重复的位置
         temp=pop(x2,crosspoint(1)+zhi);
         pop(x1,j)=temp;
      end
   end
%检查x1右面的重复性并得到x1右面   
   for j=crosspoint(2)+1:t-1
      while find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j))
         zhi=find(pop(x1,crosspoint(1)+1:crosspoint(2))==pop(x1,j)); %确定重复的位置
         temp=pop(x2,crosspoint(1)+zhi);
         pop(x1,j)=temp;
      end
   end
%检查x2左面的重复性并得到x2左面
    for j=1:crosspoint(1)
      while find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j))
         zhi=find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j)); %确定重复的位置
         temp=pop(x1,crosspoint(1)+zhi);
         pop(x2,j)=temp;
     end
   end
%检查x2右面的重复性并得到x2右面   
   for j=crosspoint(2)+1:t-1
      while find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j))
         zhi=find(pop(x2,crosspoint(1)+1:crosspoint(2))==pop(x2,j)); %确定重复的位置
         temp=pop(x1,crosspoint(1)+zhi);
         pop(x2,j)=temp;
      end
   end
end
%生成的新种群与交叉前比较，并取两者最优
[pop]=chap10_2dis(pop);
for i=1:s
    if pop_1(i,t)<pop(i,t)
       pop(i,:)=pop_1(i,:);
    end
end