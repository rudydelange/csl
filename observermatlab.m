close all
clear all
clc
%% Choose type of controller
% Pole Placement: n = 1
% LQR: n = 2
n = 1;

%% Discrete Matrices
load('matrices.mat')

% phi = A; % A matrix discrete
% gamma = B;    % B matrix discrete
% C = C;
% D = D;

phi = Ad.A; % A matrix discrete
gamma = Ad.B;    % B matrix discrete
C = Ad.C;
D = Ad.D;

%% Choosing the type of controller
switch n
    % Pole Placement for controller: pole placement
    case 1
        % P = [-0.49, -0.491, -0.49, -0.491]; % werkt zonder arduino model met median filter in matlab
        % P = [-0.0091, -0.0091, -0.009, -0.009]; % met noise zonder arduino beeeeeeeeetje ok
        % P = [0.10, 0.10,0.80, 0.80]; % best nice met noise zonder arduino
        P = [0.81, 0.81,0.80, 0.80]; % weinig noise, wel offset van th1 th2
    % Pole Placement for controller: LQR
    case 2
        P = [-0.49, -0.491, -0.49, -0.491];
end

%% Solve observer gain K for desired Poles P
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


y1 = [data(:,5) data(:,3)+273.15];
y2 = [data(:,5) data(:,4)+273.15];
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

%% Save K-matrix
save('K_matrix.mat','K')
save('discretemodel.mat','phi','gamma','C','D')