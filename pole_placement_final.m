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

% Generate L matrix
L  = place(A,B,P);

% Check Closed Loop Eigenvalues;
Acl = A-B*L;
Ecl = eig(Acl);

% Close Loop System
syscl = ss(Acl,B,C,D);
% figure(1)
% step(syscl)

% Solve for Lr
Ldc = dcgain(syscl);
Lr = inv(Ldc);

% Scaled Close Loop System
% figure(2)
syscl_scaled = ss(Acl,B*Lr,C,D);
% step(syscl_scaled)

% Create step response plot of unscaled and scaled system
figure(1); grid on;
set(gcf, 'Position', [600, 400, 600, 500]);
step(syscl); hold on;
step(syscl_scaled);  title('Step Response of Closed-Loop System (Pole-Placement)', 'Interpreter', 'Latex');
legend('Unscaled Response', 'Scaled', 'Interpreter', 'Latex', 'Location', 'SouthEast');
set(gca, 'Fontsize', 12); xlabel('Time', 'Interpreter', 'Latex'); ylabel('Amplitude', 'Interpreter', 'Latex');

save('L_Lr_Pole_Placement_final.mat','L','Lr','Poles_PP')