close all
clear all
clc

%% Discrete Matrices
load('matrices.mat')

phi = Ad.A; % A matrix discrete
gamma = Ad.B;    % B matrix discrete
C = Ad.C;
D = Ad.D;

%% Pole Placement
%e = x - xhat --> edot = ... = (phi-K*C)*e

syms lambda k1 k2 k3 k4 k5 k6 k7 k8
K = [k1, k2; k3, k4; k5, k6; k7, k8]; % observer gain

eq1 = det(lambda*eye(4) - (phi - K*C));

% pick eigenvalues: (lambda + 1)^2 <-- poles at p = -1
P = (lambda + 1)^4;

% %% Solve the det eqation for desired observer dynamics
% eq1_lambda4 = simplify(jacobian(jacobian(eq1, lambda)/2,lambda));
% 
% eq1_lambda2 = simplify(jacobian(jacobian(eq1, lambda)/2,lambda));
% eq1_lambda = simplify(jacobian(eq1-eq1_lambda2*lambda^2, lambda));
% eq1_rest = simplify(eq1 - eq1_lambda2*lambda^2 - eq1_lambda*lambda);
% 
% [k1,k2,k3,k4,k5,k6,k7,k8] = solve(eq1_lambda2 == 1,eq1_lambda == 2, eq1_rest == 1, k1,k2,k3,k4,k5,k6,k7,k8);
% gives K

P = [-1];

acker(phi,C.',P)
%K_new = [k1, k2; k3, k4; k5, k6; k7, k8]
%% Observer
% returns xhat
%sim('observer')