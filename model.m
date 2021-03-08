close all; clear all; clc

syms T_H1 T_H2 T_S1 T_S2
x = [T_H1; T_H2; T_S1; T_S2];
y = [T_S1; T_S2];

syms T_H1dot T_H2dot T_S1dot T_S2dot
xdot = [T_H1dot;T_H2dot;T_S1dot;T_S2dot];

syms Q1 Q2
u = [Q1; Q2];

%% Parameters
U = 10.2021;
Us = 13.8985;
cp = 501.9208;
eps = 0.9000;
tau = 24.4408;
m = 0.0052;
A = 0.0009;
As = 0.0004;
alpha1 = 0.0114;
alpha2 = 0.0079;

sigma = 5.67e-8;
Tamb1 = 19.4037+7;
Tamb2 = 18.4262+6.5;
% syms U Us cp eps tau m A As alpha1 alpha2 Tamb sigma

%% Model equations

% Heat Transfer Exchange Between 1 and 2
Q_C12 = Us*As*(T_H2-T_H1);              % convection
Q_R12 = eps*sigma*As*(T_H2^4 - T_H1^4); % radiation

% Heat equations for the heaters
dTH1dt = (1.0/(m*cp))*(U*A*(Tamb1 - T_H1) ...
        + eps*sigma*A*(Tamb1^4 - T_H1^4) ...
        + Q_C12 + Q_R12 ...
        + alpha1*Q1);
dTH2dt = (1.0/(m*cp))*(U*A*(Tamb2 - T_H2) ...
        + eps*sigma*A*(Tamb2^4 - T_H2^4) ...
        - Q_C12 - Q_R12 ...
        + alpha2*Q2);
    
% Coupling between heater and temperature sensor
dTC1dt = (1.0/tau)*(T_H1 - T_S1);
dTC2dt = (1.0/tau)*(T_H2 - T_S2);

xdot = [dTH1dt; dTH2dt; dTC1dt; dTC2dt];

%% Model Matrices

Am = simplify(jacobian(xdot,x));
Bm = simplify(jacobian(xdot,u));
Cm = [0,0,1,0;0,0,0,1]; % simplify(transpose(jacobian(x,y)))
Dm = [0,0;0,0];         % simplify(jacobian(y,u))

% Model equations using matrices
xdot = simplify(Am*x + Bm*u)
y = simplify(Cm*x + Dm*u)
