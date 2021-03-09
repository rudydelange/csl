% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load Blackbox Models
load('blackboxidentification_detrend_2.mat');

%% State
% Retrieve state matrices from BJ model
[A, B, C, D] = polydata(bj_7th_lsqnonlin);
% Convert symbolic to double
% [A] = double([A{:,:}]); % symbolic -> double (cell type)
% 
% [B] = double([B{:}]); 
% 
% [C] = double([C{:}]);
% 
% [D] = double([D{:}]);


% Create state space object
sys = ss(A, B, C, D);

% Check open loop eigenvalues
E = eig(A);

% Desired closed loop eigenvalues
P = [-2 -1];

% Solve for K using pole placement
K = place(A, B, P);

% Check for closed loop eigenvalues
Acl = A - B*K;
Ecl = eig(Acl);

% Create closed loop system
syscl = ss(Acl, B, C, D);

% Check step response
figure(1); hold on;
step(sys);
figure(2); hold on;
step(syscl);

% Solve for Kr
Kdc = dcgain(syscl);
Kr = 1/Kdc; % inverse of the DC gain that can be used for scaling the system

% Create scaled input closed
syscl_scaled = ss(Acl, B*Kr, C, D);
figure(3); hold on;
step(syscl_scaled);