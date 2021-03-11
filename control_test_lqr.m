 % Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load White-box Model
load('matrices.mat');
% Convert discrete SS to continuous
whitebox_continuous = d2c(Ad,'zoh');

%% Load Data
% temp_dat1 = xlsread('temperature_correct_1_v2.xlsx'); % Training set
% temp_dat2 = xlsread('temperature_correct_2_v2.xlsx'); % Validation set
% 
% % Segment heater input from data
% heater_input_1 = temp_dat1(:,1:2);
% heater_input_2 = temp_dat2(:,1:2);
% 
% % Segment time vector from data
% time_1 = temp_dat1(:,5);
% time_2 = temp_dat2(:,5);
% ts = time_1(2,:); % sample time data

% Segment sample time
[A,B,C,D,Ts] = ssdata(Ad);

%% Load LQR Controller
load('lqr_whitebox.mat');

%% Reference Temperature Vector
seq_1 = linspace(0,273, 100/Ts); % Linear increase for reference heat to 50 degrees
lin_50 = linspace(273, 273, 50/Ts); % Linear  
seq_2 = linspace(150, 1499-150, (1399-101)/Ts); % Timevector for Sinusoidal Input heater
wave_h1 = 10*sin(seq_2*0.05)+273; % Create sinusoidal wave input heater 1 starting from 50 degrees
% figure(1); hold on; plot(wave_h1);
wave_h2 = 10*sin((seq_2*0.05)+pi)+273; % Create sinusoidal wave input heater 2 starting from 70 degrees
% figure(2); hold on; plot(wave_h2);

reference = zeros(length(seq_1)+length(seq_2),2);
reference(1:length(seq_1),:) = [seq_1.',seq_1.'];
reference(length(seq_1)+1:length(seq_1)+length(lin_50),:) = [lin_50.', lin_50.'];
reference(length(seq_1)+length(lin_50)+1:end,:) = [wave_h1(43:1290).', wave_h2(43:1290).'];
plot(reference);
%% Run Controller Over System
% feedin = [1 2] % Feed in data
% feedout = [1 2] % Feed out data
% Create feedback loop
sys_pp_control = feedback(whitebox_continuous, syscl_lqr_scaled);
sys_pp_control = minreal(sys_pp_control); % minimum realization and pole-zero cancellation
sys_pp_control_discrete = c2d(sys_pp_control, ts, 'zoh'); % discrete time controller
% Simulate time response
timevector = 
lsim(sys_pp_control_discrete, reference, length(reference), [0,0,20,20,0,0,20,20])