close all; clear all; clc

%% Optimized parameters from white box
areahat = 0.0009;     
areashat=  0.0004;
tauhat =    24.4408;
masshat = 0.0052;
emishat = 0.9000;
boltz = 5.67e-8;
cphat = 501.9208;
uhat = 10.2021;
alpha1hat = 0.0114;
alpha2hat = 0.0079;
ushat = 13.8985;

Tamb1 = 273.15+19.4037+7;
Tamb2 = 273.15+18.4262+6.5;

%% Data from experiment 
data = readtable('exceldata22.xlsx');
data = table2array(data);
tout = data(:,5);

h = tout(2)-tout(1);
y1 = data(:,3)+273.15;
y2 = data(:,4)+273.15;
x0 = [y1(1);y2(1)];  %Initial guess

% ref1 = [tout, (15)*ones(2500,1)];
% ref2 = [tout, (15)*ones(2500,1)];

% duration = 2500; % seconds
% ref1 = randi([10 20]);
% duration1 = randi([200 750]);
% j1 = 1; j2 = 1;
% for i=1:duration
%     if j1 <= duration1
%         u1(i) = ref1;
%         j1 = j1 + 1;
%     else
%         j1 = 1;
%         ref1 = randi([10 20]);
%         duration1 = randi([200 750]);
%         u1(i) = ref1;
%     end  
% end
% ref1=u1; 
% figure(1); plot(ref1); hold on; plot(ref1); 
% ref11 = [tout,ref1.'];
% ref22 = [tout,ref1.'];
% 
% 
%  sim('nlmodelLIN')

%% Linearization of non-linear continuous time model at operating point: [300 300 300 300], [35 35]
[A,B,C,D] = linmod('nlmodelLIN', [3.101097756283022e+02 3.077085609758263e+02 3.101097756283022e+02 3.077085609758263e+02], [15 15]);
syst = ss(A,B,C,D);

%% Change order of continuous matrices 
% A([1,5,2,6,3,7,4,8,9,13,10,14,11,15,12,16]) = A([11,15,12,16,9,13,10,14,3,7,4,8,1,5,2,6]);
% B([1,5,2,6,3,7,4,8]) = B([3,7,4,8,1,5,2,6]);
% C([1,3,2,4,5,7,6,8]) = C([5,7,6,8,1,3,2,4]);

%% Create a discrete state-space model 
Ad = c2d(syst,h,'zoh');

%% Change order of discrete matrices 
% Ad.A([1,5,2,6,3,7,4,8,9,13,10,14,11,15,12,16]) = Ad.A([11,15,12,16,9,13,10,14,3,7,4,8,1,5,2,6]);
% Ad.B([1,5,2,6,3,7,4,8]) = Ad.B([3,7,4,8,1,5,2,6]);
% Ad.C([1,3,2,4,5,7,6,8]) = Ad.C([5,7,6,8,1,3,2,4]);

[wn,zeta] = damp(syst)

%% Save variables in file 
filename = 'matrices.mat';
save(filename)
