% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load White-box Model
load('matrices.mat')

% Convert discrete SS to continuous
whitebox_continuous = d2c(Ad,'zoh')

%% Load LQR Controller
load('lqr_whitebox.mat')

%% Run Controller Over System
% Create feedback loop
sys_pp_control = feedback('whitebox_continuous, syscl_lqr_scaled');