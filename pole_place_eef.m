% Control Systems Lab - Group 3 - Pole Placement Script
close all; clear all; clc
format long;
%% Load Data & Create State-Space
load('matrices.mat')
% Assign Matrices
A = A;
B = B;
C = C;
D = D;
% Check eigenvalues of Open-Loop A matrix
Eop = eig(A);
% Create State Space for system
cont_sys = ss(A,B,C,D); % Sample time 1.004
% Check controlability of the system
Contr = ctrb(A,B);
Contr_check = length(A) - rank(Contr); % It is full rank thus controllable

%% Find & Place Poles for System Dynamics

% Old values
% p1 = -2*exp(-zeta(1)*wn(1)*h)*cos(wn*h*sqrt(1-zeta(1)^2))
% P = [0.000000001 0.000000002 0.000000001 0.000000002];
% P = exp(P.*h);% Poles in z-domain
% P = [-0.0283 -0.0117 -0.0212 -0.0088];
% P = [-0.98 -0.98 -0.99 -0.99]; %Edge of Stability --> Oscillations

% Find Natural Frequency, Damping and Poles of Closed-Loop System
[wn,zeta,P] = damp(cont_sys);
nat_freq = wn;   % Natural frequency
damp = zeta;     % Damping is 1 (and not < 1) so the system is not underdamped 
poles = P        % Poles all lie in LHP and are within unit circle (stable system)

faulty_pole1 = -2.*damp.*nat_freq; % 2e orde -> moet naar 4e orde -> dan pas pole placement
faulty_pole2 = -nat_freq.^2; % 2e orde -> SISO (MIMO) -> kan alleen toepassen als je cross-coupling weg laat
% Gebruik gewoon random polen en als dat stabiel is vergelijken.

damp_alter = (1.1.*zeta).*ones(4,1); 

magic_pole = -damp_alter .* nat_freq

% Place poles of system @ desired location & Create Gain Matrix L
L  = place(A,B,poles);

% Create Closed-Loop A matrix
Acl = A-B*L;
Ecl = eig(Acl); % Check eigenvalues

% Create State-Space of Closed-Loop System
syscl = ss(Acl,B,C,D);

% Create Step-response of Closed-Loop System
% figure(1);
% step(syscl);

% Scale the Gain to 1 (for Step Response)
Kdc = dcgain(syscl);
Lr = inv(Kdc);

eig(syscl);

% Plot the Step-Response of the Scaled Closed-Loop System
% figure(2);
syscl_scaled = ss(Acl,B*Lr,C,D); % Create Scaled Closed-Loop System
% step(syscl_scaled);

%% Save Feedback & Reference Gain
filename = 'LandLr.mat';
save('LandLr.mat','L','Lr');