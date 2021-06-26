clear all;
close all;

A=[0.5;1;0.1];
B=[0.1,1,0.6];
C=[0.4,1];

%Compound of A and B
for i=1:3
   for j=1:3
      AB(i,j)=min(A(i),B(j));
   end
end
%Transfer to Column
T1=[];
for i=1:3
   T1=[T1;AB(i,:)'];
end
%Get fuzzy R
for i=1:9
   for j=1:2
      R(i,j)=min(T1(i),C(j));
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A1=[1,0.5,0.1];
B1=[0.1,0.5,1];

for i=1:3
   for j=1:3
      AB1(i,j)=min(A1(i),B1(j));
   end
end
%Transfer to Row
T2=[];
for i=1:3
   T2=[T2,AB1(i,:)];
end
%Get output C1
for i=1:9
   for j=1:2
      D(i,j)=min(T2(i),R(i,j));
      C1(j)=max(D(:,j));
   end
end
C1