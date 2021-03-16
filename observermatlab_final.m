close all
clear all
clc
%% Choose type of controller
% Pole Placement: n = 1
% LQR: n = 2
n = 1;

%% Discrete Matrices
load('syst_TS1_TS2_TH1_TH2.mat')
load('L_Lr_Pole_Placement_final.mat','Poles_PP')

%% Choosing the type of controller
switch n
    % Pole Placement for controller: pole placement
    case 1
        P = [Poles_PP]*5;
   
    % Pole Placement for controller: LQR
    case 2
        P = [Poles_PP]*5;
        disp('fix')
end

%% Solve observer gain K for desired Poles P
K = place(A.',C.',P).'

%% Check observability 
ohm = obsv(A,C);
observability = length(A) - rank(ohm); % If zero --> observable

%% Observer
% returns xhat

data = readtable('exceldata22.xlsx');
data = table2array(data);
U1 = [data(:,5) data(:,1)];
U2 = [data(:,5) data(:,2)];


y1 = [data(:,5) data(:,3)+273.15-x0(1)];
y2 = [data(:,5) data(:,4)+273.15-x0(2)];
tout = data(:,5);
h = tout(2)-tout(1);

% y1 = medfilt1(y1,8); % median filter to remove noise from signal
% y2 = medfilt1(y2,8);

% y1(1,2) = y1(2,2);
% y2(1,2) = y2(2,2);

% y1 = [data(:,5) 28*ones(5400,1)+273.15];
% y2 = [data(:,5) 28*ones(5400,1)+273.15];
% U1 = [data(:,5) 15*ones(5400,1)];
% U2 = [data(:,5) 15*ones(5400,1)];

sim('observermodel_final')

%% Save K-matrix
save('K_matrix_final.mat','K')