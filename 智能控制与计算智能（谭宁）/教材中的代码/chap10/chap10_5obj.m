function J=obj(X,y,N)%********计算个体目标函数值
  gp=X(1);
  hp=X(2);
  k1p=X(3);
  k2p=X(4);

  xmin=-4;
  xmax=4;
  
for i=1:1:N
    x(i)=xmin+(i-1)*0.10;
    x_abs=abs(x(i));
    if x_abs<=gp
       yp(i)=0;
    elseif x_abs>gp&&x_abs<=hp
       yp(i)=k1p*(x(i)-gp*sign(x(i)));
    elseif x_abs>=hp
       yp(i)=k2p*(x(i)-hp*sign(x(i)))+k1p*(hp-gp)*sign(x(i));
    end
end

E=yp-y;
J=0;
    for i=1:1:N
        J=J+0.5*E(i)*E(i);
    end
end