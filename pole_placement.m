% Control Systems Lab (2020-2021) - Group 3 
close all; clear all; clc

%% Load White-Box Models
load('syst_TS1_TS2_TH1_TH2.mat')

%% State

% natural frequency and damping ratio
[wn,zeta,poles] = damp(syst);
P = 1.5*poles;
P(1) = P(2);

Poles_PP = P;

% Check open loop eigenvalues
Ecl = eig(A);

% Check for Controllability
Contr = ctrb(A,B);
Contr_check = length(A) - rank(Contr); % It is full rank thus controllable

% Generate L matrix
L  = place(A,B,P);

% Check Closed Loop Eigenvalues;
Acl = A-B*L;
Ecl = eig(Acl);

% Close Loop System
syscl = ss(Acl,B,C,D);
figure(1)
step(syscl)

% Solve for Lr
Ldc = dcgain(syscl);
Lr = inv(Ldc);

% Scaled Close Loop System
figure(2)
syscl_scaled = ss(Acl,B*Lr,C,D);
step(syscl_scaled)

save('L_Lr_Pole_Placement.mat','L','Lr','Poles_PP')