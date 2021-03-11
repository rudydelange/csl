close all
clear all
clc

%% Discrete Matrices
load('matrices.mat')

phi = Ad.A; % A matrix discrete
gamma = Ad.B;    % B matrix discrete
C = Ad.C;
D = Ad.D;

%% Pole Placement
%P = [-1, -1.1, -1, -1.1];
P = [-0.1, -0.1, -0.2, -0.2];


% Solve observer gain K for desired Poles P
K = place(phi.',C.',P).';

%% Check observability 
ohm = obsv(phi,C);
observability = length(phi) - rank(ohm); % If zero --> observable

%% Observer
% returns xhat

data = readtable('exceldata21.xlsx');
data = table2array(data);
U1 = [data(:,5) data(:,1)];
U2 = [data(:,5) data(:,2)];


y1 = [data(:,5) data(:,3)+273.15];
y2 = [data(:,5) data(:,4)+273.15];
tout = data(:,5);
h = tout(2)-tout(1);

sim('observermodel')

