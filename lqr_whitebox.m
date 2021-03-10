% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load White-Box Models
load('matrices.mat');

%% State
% Create state space object
sys = Ad;
% Retrieve state matrices from whitebox model
A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;
% Check open loop eigenvalues
E = eig(A);

% Check for Controllability
Contr = ctrb(A,B);
Contr_check = length(A) - rank(Contr); % It is full rank thus controllable

% Control Law (LQR)
Q = [100 0 0 0;   % Penalize bad performance
     0 100 0 0;
     0 0 1 0;
     0 0 0 1];
R = [10 0; 0 10];  % Penalize effort
K = lqr(A,B,Q,R); % Create Gain Matrix K (LQR)

% Check Closed Loop Eigenvalues;
Acl = A - B*K;
Ecl = eig(Acl);

% Close Loop System
syscl = ss(Acl, B, C, D);

% Solve for Kr
Kdc = dcgain(syscl)
Kr = inv(Kdc); % Inverse of dcgain for scaling

% Scaled Close Loop System
syscl_scaled = ss(Acl, B*Kr, C, D);

% Run
figure(1);
step(syscl_scaled);
