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
% e = x - xhat --> edot = ... = (phi-K*C)*e
% det(lambda*eye(4) - (phi - K*C));

% Design desired poles characteristic
% P = (lambda + 1)^4;
P = [-1, -1, -1.1, -1.1];

% Solve observer gain K for desired Poles P
K = place(phi.',C.',P).'

%% Check observability 
ohm = obsv(phi,C);
observability = length(phi) - rank(ohm); % If zero --> observable

%% Observer
% returns xhat
sim('observermodel')

