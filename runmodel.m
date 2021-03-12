close all; clear all; clc

load('matrices.mat')
load('K_matrix.mat')
load('L_matrix.mat')
load('discretemodel.mat')
load('pole_placement_matrices.mat')
load('lqr_matrices.mat')
load('LandLr.mat');
% L = L_lqr;
% Lr = Lr_lqr;

ref = [tout, (50+273.15)*ones(2500,1), (50+273.15)*ones(2500,1)];

sim('observer_controller_model')

% [Ax,Bx,Cx,Dx] = dlinmod('observer_controller_model')
% systcl = ss(Ax,Bx,Cx,Dx);
% ksystem = dcgain(systcl)
