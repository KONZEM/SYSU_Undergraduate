clear;
clc;
fuzzy;
a = newfis("fuzzf");

a = addvar(a, 'input', 'e', [-30, 30]);
a = addmf(a, 'input', 1, 'NB', 'zmf', [-30, -10]);
a = addmf(a, 'input', 1, 'NM', 'trimf', [-30, -20, 0]);
a = addmf(a, 'input', 1, 'NS', 'trimf', [-30, -10, 10]);
a = addmf(a, 'input', 1, 'Z', 'trimf', [-20, 0, 20]);
a = addmf(a, 'input', 1, 'PS', 'trimf', [-10, 10, 30]);
a = addmf(a, 'input', 1, 'PM', 'trimf', [0, 20, 30]);
a = addmf(a, 'input', 1, 'PB', 'smf', [10, 30]);

a = addvar(a, 'input', 'ec', [-30, 30]);
a = addmf(a, 'input', 2, 'NB', 'zmf', [-30, -10]);
a = addmf(a, 'input', 2, 'NM', 'trimf', [-30, -20, 0]);
a = addmf(a, 'input', 2, 'NS', 'trimf', [-30, -10, 10]);
a = addmf(a, 'input', 2, 'Z', 'trimf', [-20, 0, 20]);
a = addmf(a, 'input', 2, 'PS', 'trimf', [-10, 10, 30]);
a = addmf(a, 'input', 2, 'PM', 'trimf', [0, 20, 30]);
a = addmf(a, 'input', 2, 'PB', 'smf', [10, 30]);
% a = addmf(a, 'input', 2, 'NB', 'zmf', [-90, -30]);
% a = addmf(a, 'input', 2, 'NM', 'trimf', [-90, -60, 0]);
% a = addmf(a, 'input', 2, 'NS', 'trimf', [-90, -30, 30]);
% a = addmf(a, 'input', 2, 'Z', 'trimf', [-60, 0, 60]);
% a = addmf(a, 'input', 2, 'PS', 'trimf', [-30, 30, 90]);
% a = addmf(a, 'input', 2, 'PM', 'trimf', [0, 60, 90]);
% a = addmf(a, 'input', 2, 'PB', 'smf', [20, 90]);

a = addvar(a, 'output', 'u', [-60, 60]);
% a = addmf(a, 'output', 1, 'NB', 'zmf', [-120, -40]);
% a = addmf(a, 'output', 1, 'NM', 'trimf', [-120, -80, 0]);
% a = addmf(a, 'output', 1, 'NS', 'trimf', [-120, -40, 40]);
% a = addmf(a, 'output', 1, 'Z', 'trimf', [-80, 0, 80]);
% a = addmf(a, 'output', 1, 'PS', 'trimf', [-40, 40, 120]);
% a = addmf(a, 'output', 1, 'PM', 'trimf', [0, 80, 120]);
% a = addmf(a, 'output', 1, 'PB', 'smf', [40, 120]);
a = addmf(a, 'output', 1, 'NB', 'zmf', [-60, -20]);
a = addmf(a, 'output', 1, 'NM', 'trimf', [-60, -40, 0]);
a = addmf(a, 'output', 1, 'NS', 'trimf', [-60, -20, 20]);
a = addmf(a, 'output', 1, 'Z', 'trimf', [-40, 0, 40]);
a = addmf(a, 'output', 1, 'PS', 'trimf', [-20, 20, 60]);
a = addmf(a, 'output', 1, 'PM', 'trimf', [0, 40, 60]);
a = addmf(a, 'output', 1, 'PB', 'smf', [20, 60]);

rulelist=[1 1 1 1 1;         %Edit rule base
          1 2 1 1 1;
          1 3 2 1 1;
          1 4 2 1 1;
          1 5 3 1 1;
          1 6 3 1 1;
          1 7 4 1 1;
   
          2 1 1 1 1;
          2 2 2 1 1;
          2 3 2 1 1;
          2 4 3 1 1;
          2 5 3 1 1;
          2 6 4 1 1;
          2 7 5 1 1;
          
          3 1 2 1 1;
          3 2 2 1 1;
          3 3 3 1 1;
          3 4 3 1 1;
          3 5 4 1 1;
          3 6 5 1 1;
          3 7 5 1 1;
          
          4 1 2 1 1;
          4 2 3 1 1;
          4 3 3 1 1;
          4 4 4 1 1;
          4 5 5 1 1;
          4 6 5 1 1;
          4 7 6 1 1;
          
          5 1 3 1 1;
          5 2 3 1 1;
          5 3 4 1 1;
          5 4 5 1 1;
          5 5 5 1 1;
          5 6 6 1 1;
          5 7 6 1 1;
          
          6 1 3 1 1;
          6 2 4 1 1;
          6 3 5 1 1;
          6 4 5 1 1;
          6 5 6 1 1;
          6 6 6 1 1;
          6 7 7 1 1;
       
          7 1 4 1 1;
          7 2 5 1 1;
          7 3 5 1 1;
          7 4 6 1 1;
          7 5 6 1 1;
          7 6 7 1 1;
          7 7 7 1 1];

a = addrule(a, rulelist); 
% showrule(a);

a1 = setfis(a, 'DefuzzMethod', 'mom');
% writefis(a1, 'fuzzf');

% a2 = readfis('fuzzf');
% disp('----------------------------------------');
% disp('fuzzy controller table:  e=[-30, 30]    ');
% disp('----------------------------------------');
% 
% Ulist = zeros(1, 61);
% 
% for i = 1:61
%     e(i) = -31+i;
%     Ulist(i) = evalfis(e(i), a2);
% end
% 
% Ulist = ceil(Ulist);

% figure(1);
% plotfis(a2);
% figure(2);
% plotmf(a, 'input', 1);
% figure(3);
% plotmf(a, 'output', 1);