close all; clear all; clc

load('matrices.mat')
load('K_matrix.mat')
load('L_matrix.mat')
load('discretemodel.mat')
load('pole_placement_matrices.mat')
load('lqr_matrices.mat')

L = L_lqr;
Lr = Lr_lqr;

ref = [tout, (30+273.15)*ones(2500,1), (30+273.15)*ones(2500,1)];

sim('observer_controller_model')
