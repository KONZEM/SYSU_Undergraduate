function f =evaluate_localbest(x1,x2,x3)%求解粒子环形邻域中的局部最优个体
K0=[x1;x2;x3];
K1=[chap10_3func(x1),chap10_3func(x2),chap10_3func(x3)];
[maxvalue index]=max(K1);
plocalbest=K0(index,:);
f=plocalbest;