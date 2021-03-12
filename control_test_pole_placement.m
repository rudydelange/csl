 % Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;

%% Load White-box Model
load('matrices.mat');
% Convert discrete SS to continuous
whitebox_continuous = d2c(Ad,'zoh');
% Segment sample time
[A,B,C,D,Ts] = ssdata(Ad);

%% Load Pole-Placement Controller
load('pole_placement.mat');

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
figure(1);
plot(reference); legend('Reference Heater 1', 'Reference Heater 2')
%% Run Closed Loop System with Reference as Input
syscl_pp_discrete = c2d(syscl_pp_scaled, Ts, 'zoh'); % discrete time controller
% Simulate time response
timevector = [(1:Ts:length(reference)+1).', (1:Ts:length(reference)+1).'];
figure(2);
lsim(syscl_pp_discrete, "r", reference, timevector(:,1)); grid on; 
legend('Output Heater 1', 'Output Heater 2', 'Location','southeast', 'Interpreter', 'Latex'); 
ylim([250, 290]);