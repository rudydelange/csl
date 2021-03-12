% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load White-Box Models
load('matrices.mat');

%% State
% Create continuous state space object
sys = d2c(Ad,'zoh');
% Create discrete state space object
% sys = Ad
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
Q = [1 0 0 0;   % Penalize bad performance
     0 1 0 0;
     0 0 350 0;
     0 0 0 350];
R = [1 0; 0 1];  % Penalize effort
K = lqr(A,B,Q,R); % Create Gain Matrix K (LQR)

% Check Closed Loop Eigenvalues;
Acl = A - B*K;
Ecl = eig(Acl);

% Close Loop System
syscl = ss(Acl, B, C, D);
figure(2);
step(syscl)

% Solve for Kr
Kdc = dcgain(syscl);
Kr = inv(Kdc); % Inverse of dcgain for scaling

% Scaled Close Loop System
syscl_lqr_scaled = ss(Acl, B*Kr, C, D);

% Feedforward Gain G
% G = -inv(C*inv(A-B*K)*B);

% Run
figure(1);
step(syscl_lqr_scaled); % Closed-loop system (Continuous time)

%% Save Workspace
save('lqr_whitebox.mat');

%% Compute U

U_ref = (reference(3, :).*Kr);
U_feed = (K.' .* [300, 300, 300, 300; 300, 300, 300, 300].');
U_input = U_ref - U_feed;
