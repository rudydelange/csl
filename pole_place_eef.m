close all; clear all; clc
format long;
load('matrices.mat')

% A = Ad.A;
% B = Ad.B;
% C = Ad.C;
% D = Ad.D;


Ecl = eig(A)

P = [-0.91 -0.91 -0.81 -0.81];
% P = [-0.2 -0.2 -0.1 -0.1];
%P = [-0.98 0.99 0.98 0.99];

L  = place(A,B,P)

Acl = A-B*L;
Ecl = eig(Acl)

syscl = ss(Acl,B,C,D);
figure(1)
step(syscl)

Kdc = dcgain(syscl);
Lr = inv(Kdc)

figure(2)
syscl_scaled = ss(Acl,B*Lr,C,D);
step(syscl_scaled)

filename = 'LandLr.mat';
save('LandLr.mat','L','Lr')