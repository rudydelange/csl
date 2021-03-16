close all; clear all; clc

load('syst_TS1_TS2_TH1_TH2.mat')
load('K_matrix_final.mat')
load('L_Lr_Pole_Placement_final.mat') %Pole Placement
%load('L_Lr_LQR_final.mat') % LQR

init_temp = 20 + 273.15;

% nep_u = [tout, (15)*ones(2500,1),(15)*ones(2500,1)];
% nep_y = [tout, (290)*ones(2500,1),(290)*ones(2500,1)];
%% Create reference temperature

ref = [tout, (35+273.15)*ones(2500,1), (35+273.15)*ones(2500,1)];

% duration = 2500; % seconds
% ref1 = randi([25+273 50+273]);
% duration1 = randi([200 750]);
% j1 = 1; j2 = 1;
% for i=1:duration
%     if j1 <= duration1
%         u1(i) = ref1;
%         j1 = j1 + 1;
%     else
%         j1 = 1;
%         ref1 = randi([25+273 50+273]);
%         duration1 = randi([200 750]);
%         u1(i) = ref1;
%     end  
% end
% ref1=u1; 
% figure(1); plot(ref1); hold on; plot(ref1); 
% ref = [tout,ref1.',ref1.'];

sim('full_model_arduino_final')
