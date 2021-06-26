%Fuzzy Control for washer
clear all;
close all;

a=newfis('fuzz_wash');

a=addvar(a,'input','x',[0,100]);                %Fuzzy Stain
a=addmf(a,'input',1,'SD','trimf',[0,0,50]);
a=addmf(a,'input',1,'MD','trimf',[0,50,100]);
a=addmf(a,'input',1,'LD','trimf',[50,100,100]);

a=addvar(a,'input','y',[0,100]);                %Fuzzy Axunge
a=addmf(a,'input',2,'NG','trimf',[0,0,50]);
a=addmf(a,'input',2,'MG','trimf',[0,50,100]);
a=addmf(a,'input',2,'LG','trimf',[50,100,100]);

a=addvar(a,'output','z',[0,60]);                %Fuzzy Time
a=addmf(a,'output',1,'VS','trimf',[0,0,10]);
a=addmf(a,'output',1,'S','trimf',[0,10,25]);
a=addmf(a,'output',1,'M','trimf',[10,25,40]);
a=addmf(a,'output',1,'L','trimf',[25,40,60]);
a=addmf(a,'output',1,'VL','trimf',[40,60,60]);

rulelist=[1 1 1 1 1;                            %Edit rule base
   		  1 2 3 1 1;
          1 3 4 1 1;
          
          2 1 2 1 1;
          2 2 3 1 1;
          2 3 4 1 1;
          
          3 1 3 1 1;
          3 2 4 1 1;
          3 3 5 1 1];
          
a=addrule(a,rulelist);
showrule(a)                         %Show fuzzy rule base

a1=setfis(a,'DefuzzMethod','mom');  %Defuzzy
writefis(a1,'wash');                %Save to fuzzy file "wash.fis"
a2=readfis('wash');

figure(1);
plotfis(a2);
figure(2);
plotmf(a,'input',1);
figure(3);
plotmf(a,'input',2);
figure(4);
plotmf(a,'output',1);

ruleview('wash');  %Dynamic Simulation

x=60;
y=70;
z=evalfis([x,y],a2)   %Using fuzzy inference