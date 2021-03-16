close all
clear all
clc

%% Discrete Matrices
load('matrices.mat')

phi = A % 
gamma = B   
C = C
D = D

% phi = Ad.A; % A matrix discrete
% gamma = Ad.B;    % B matrix discrete
% C = Ad.C;
% D = Ad.D;

%% Pole Placement
%P = [-0.98, -0.99, -0.8, -0.8];
P = [-0.49, -0.491, -0.49, -0.491]; %Nice for LQR, nice steady state, but high overshoot
%P = [0.81, 0.81,0.80, 0.80]; %Nice for Pole Placement
%P = [-0.049, -0.0491, -0.049, -0.0491];
%P = [0.98, 0.99, 0.98, 0.99];
%P = [0.01, 0.01, 0.008, 0.008];
%P = [0.81, 0.81, 0.7, 0.7];

% P = [-0.049, -0.0491, -0.0049, -0.00491];
%P = exp(P.*h);%poles in z-domain

P = [-0.005418417683751 -0.011367790266523 -0.040915190992112 -0.040915190992112]

% Solve observer gain K for desired Poles P
K = place(phi.',C.',P).'

%% Check observability 
ohm = obsv(phi,C);
observability = length(phi) - rank(ohm); % If zero --> observable

%% Observer
% returns xhat

data = readtable('exceldata22.xlsx');
data = table2array(data);
U1 = [data(:,5) data(:,1)];
U2 = [data(:,5) data(:,2)];


y1 = [data(:,5) data(:,3)+273.15 - x0(1)];
y2 = [data(:,5) data(:,4)+273.15 - x0(2)];
tout = data(:,5);
h = tout(2)-tout(1);

% y1 = medfilt1(y1,8); % median filter to remove noise from signal
% y2 = medfilt1(y2,8);

y1(1,2) = y1(2,2);
y2(1,2) = y2(2,2);

% y1 = [data(:,5) 28*ones(5400,1)+273.15];
% y2 = [data(:,5) 28*ones(5400,1)+273.15];
% U1 = [data(:,5) 15*ones(5400,1)];
% U2 = [data(:,5) 15*ones(5400,1)];

sim('observermodel')
filename = 'matrices_observer.mat';
save('matrices_observer.mat','K','phi','gamma','C','D')
