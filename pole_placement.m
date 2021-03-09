% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load White-Box Models
load('matrices.mat');

%% State
% Create state space object
sys = Ad;
% Retrieve state matrices from BJ model
A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;
% Check open loop eigenvalues
E = eig(A);
% Desired closed loop eigenvalues
P = [-0.98 -0.98 -0.99 -0.99];
% Solve for K using pole placement
K = place(A, B, P);

% Check for closed loop eigenvalues
Acl = A - B*K;
Ecl = eig(Acl);

% Create closed loop system
syscl = ss(Acl, B, C, D);

% Check step response
figure(1);
step(sys);
figure(2);
step(syscl);

% Solve for Kr
Kdc = dcgain(syscl);
Kr = inv(Kdc); % inverse of the DC gain that can be used for scaling the system

% Create scaled input closed
syscl_scaled = ss(Acl, B*Kr, C, D);
figure(3); 
step(syscl_scaled);