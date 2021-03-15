close all; clear all; clc

%% Load White-Box Models
load('matrices.mat')

%% State

% Check open loop eigenvalues
Ecl = eig(A);

P = [-0.91 -0.91 -0.81 -0.81];
% P = [-0.2 -0.2 -0.1 -0.1];
%P = [-0.98 0.99 0.98 0.99];

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

save('L_Lr_Pole_Placement.mat','L','Lr')