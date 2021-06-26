%Fuzzy Control for water tank
clear all;
close all;

a=newfis('fuzz_tank');

a=addvar(a,'input','e',[-3,3]);            %Parameter e
a=addmf(a,'input',1,'NB','zmf',[-3,-1]);
a=addmf(a,'input',1,'NS','trimf',[-3,-1,1]);
a=addmf(a,'input',1,'Z','trimf',[-2,0,2]);
a=addmf(a,'input',1,'PS','trimf',[-1,1,3]);
a=addmf(a,'input',1,'PB','smf',[1,3]);

a=addvar(a,'output','u',[-4,4]);          %Parameter u
a=addmf(a,'output',1,'NB','zmf',[-4,-1]);
a=addmf(a,'output',1,'NS','trimf',[-4,-2,1]);
a=addmf(a,'output',1,'Z','trimf',[-2,0,2]);
a=addmf(a,'output',1,'PS','trimf',[-1,2,4]);
a=addmf(a,'output',1,'PB','smf',[1,4]);

rulelist=[1 1 1 1;         %Edit rule base
          2 2 1 1;
          3 3 1 1;
          4 4 1 1;
          5 5 1 1];
          
a=addrule(a,rulelist);

a1=setfis(a,'DefuzzMethod','mom');  %Defuzzy
writefis(a1,'tank');                %Save to fuzzy file "tank.fis"
a2=readfis('tank');

figure(1);
plotfis(a2);
figure(2);
plotmf(a,'input',1);
figure(3);
plotmf(a,'output',1);

flag=1;
if flag==1
	showrule(a)            %Show fuzzy rule base
	ruleview('tank');      %Dynamic Simulation
end
disp('-------------------------------------------------------');
disp('      fuzzy controller table:e=[-3,+3],u=[-4,+4]       ');
disp('-------------------------------------------------------');

for i=1:1:7
    e(i)=i-4;
    Ulist(i)=evalfis([e(i)],a2);
end
Ulist=round(Ulist)

e=-3;        % Error
u=evalfis([e],a2)   %Using fuzzy inference