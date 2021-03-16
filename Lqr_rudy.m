% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load White-Box Models
load('matrices.mat');

%% State
% Create continuous state space object
%sys = d2c(Ad,'zoh');
% Create discrete state space object
% sys = Ad
% Retrieve state matrices from whitebox model
% A = sys.A;
% B = sys.B;
% C = sys.C;
% D = sys.D;
% Check open loop eigenvalues
E = eig(A);

% Check for Controllability
Contr = ctrb(A,B);
Contr_check = length(A) - rank(Contr); % It is full rank thus controllable

% Control Law (LQR)
Q = [350 0 0 0;   % Penalize bad performance
     0 750 0 0;
     0 0 350 0;
     0 0 0 750];
%R = [0.008 0; 0 0.008];  % Penalize effort
R = [0.5 0; 0 0.5];  % Penalize effort
L = lqr(A,B,Q,R); % Create Gain Matrix K (LQR)

% Observer poles: P = [-0.49, -0.491, -0.49, -0.491];

% Check Closed Loop Eigenvalues;
Acl = A - B*L;
Ecl = eig(Acl)

% Close Loop System
syscl = ss(Acl, B, C, D);
figure(2);
step(syscl)

% Solve for Kr
Ldc = dcgain(syscl);
Lr = inv(Ldc); % Inverse of dcgain for scaling

% Scaled Close Loop System
syscl_lqr_scaled = ss(Acl, B*Lr, C, D);

% Feedforward Gain G
% G = -inv(C*inv(A-B*K)*B);

% Run
figure(1);
step(syscl_lqr_scaled); % Closed-loop system (Continuous time)

%% Save Workspace
filename = 'LQR_L_LR.mat';
save('LQR_L_LR.mat','L','Lr')

%% Compute U
% 
% U_ref = (reference(3, :).*Kr);
% U_feed = (K.' .* [300, 300, 300, 300; 300, 300, 300, 300].');
% U_input = U_ref - U_feed;