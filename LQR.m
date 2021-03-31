% Control Systems Lab (2020-2021) - Group 3 
close all; clear all; clc;

%% Load White-Box Models
load('syst_TS1_TS2_TH1_TH2.mat')

%% State

% Check open loop eigenvalues
E = eig(A);

% Check for Controllability
Contr = ctrb(A,B);
Contr_check = length(A) - rank(Contr); % It is full rank thus controllable

Q = [1000 0 0 0;   % Penalize bad performance. Beste resultaat.
     0 1000 0 0;
     0 0 1000 0;
     0 0 0 1000];
R = [0.5 0; 0 0.5];  % Penalize effort. Beste resultaat.
L = lqr(A,B,Q,R) % Create Gain Matrix K (LQR)

% Observer poles: P = [-0.49, -0.491, -0.49, -0.491];

% Check Closed Loop Eigenvalues;
Acl = A - B*L;
Ecl = eig(Acl);

% Close Loop System
syscl = ss(Acl, B, C, D);
figure(2);
step(syscl)

% Solve for Kr
Ldc = dcgain(syscl);
Lr = inv(Ldc) % Inverse of dcgain for scaling

% Scaled Close Loop System
syscl_lqr_scaled = ss(Acl, B*Lr, C, D);

% Feedforward Gain G
% G = -inv(C*inv(A-B*K)*B);

% Run
figure(1);
step(syscl_lqr_scaled); % Closed-loop system (Continuous time)

%% Save Workspace
save('L_Lr_LQR.mat','L','Lr')
