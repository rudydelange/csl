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

init_temp = 20 + 273.15;

% nep_u = [tout, (15)*ones(2500,1),(15)*ones(2500,1)];
% nep_y = [tout, (290)*ones(2500,1),(290)*ones(2500,1)];
%% Create reference temperature

ref = [tout, (50+273.15)*ones(2500,1), (50+273.15)*ones(2500,1)];

duration = 2500; % seconds
ref1 = randi([25+273 50+273]);
duration1 = randi([200 750]);
j1 = 1; j2 = 1;
for i=1:duration
    if j1 <= duration1
        u1(i) = ref1;
        j1 = j1 + 1;
    else
        j1 = 1;
        ref1 = randi([25+273 50+273]);
        duration1 = randi([200 750]);
        u1(i) = ref1;
    end  
end
ref1=u1; 
figure(1); plot(ref1); hold on; plot(ref1); 
ref = [tout,ref1.',ref1.'];

sim('observer_controller_model')
