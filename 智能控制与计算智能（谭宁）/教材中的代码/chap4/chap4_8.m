%Sugeno type fuzzy model
clear all;
close all;

ts2=newfis('ts2','sugeno');

ts2=addvar(ts2,'input','X',[0 5]);
ts2=addmf(ts2,'input',1,'little','gaussmf',[1.8 0]);
ts2=addmf(ts2,'input',1,'big','gaussmf',[1.8 5]);

ts2=addvar(ts2,'input','Y',[0 10]);
ts2=addmf(ts2,'input',2,'little','gaussmf',[4.4 0]);
ts2=addmf(ts2,'input',2,'big','gaussmf',[4.4 10]);

ts2=addvar(ts2,'output','Z',[-3 15]);
ts2=addmf(ts2,'output',1,'first area','linear',[-1 1 -3]);
ts2=addmf(ts2,'output',1,'second area','linear',[1 1 1]);
ts2=addmf(ts2,'output',1,'third area','linear',[0 -2 2]);
ts2=addmf(ts2,'output',1,'fourth area','linear',[2 1 -6]);

rulelist=[1 1 1 1 1;
          1 2 2 1 1;
          2 1 3 1 1;
          2 2 4 1 1];

ts2=addrule(ts2,rulelist);
showrule(ts2);

figure(1);
subplot 211;
plotmf(ts2,'input',1);
xlabel('x'),ylabel('MF Degree of input 1');
subplot 212;
plotmf(ts2,'input',2);
xlabel('x'),ylabel('MF Degree of input 2');

figure(2);
gensurf(ts2);
xlabel('x'),ylabel('y'),zlabel('z');