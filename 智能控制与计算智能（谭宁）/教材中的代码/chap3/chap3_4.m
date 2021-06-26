clear all;
close all;
A=[0.8,0.7;
   0.5,0.3];
B=[0.2,0.4;
   0.6,0.9];
%Compound of A and B
for i=1:2
   for j=1:2
      AB(i,j)=max(min(A(i,:),B(:,j)'))
	end
end

%Compound of B and A
for i=1:2
   for j=1:2
      BA(i,j)=max(min(B(i,:),A(:,j)'))
	end
end