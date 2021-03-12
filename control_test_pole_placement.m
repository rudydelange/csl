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
% Create Reference Temperature Sequences
seq_1 = linspace(0,273, 100/Ts); % Linear increase for reference heat to 50 degrees
lin_50 = linspace(273, 273, 50/Ts); % Linear  
seq_2 = linspace(150, 1499-150, (1399-101)/Ts); % Timevector for Sinusoidal Input heater
wave_h1 = 10*sin(seq_2*0.05)+273; % Create sinusoidal wave input heater 1 starting from 50 degrees
% figure(1); hold on; plot(wave_h1);
wave_h2 = 10*sin((seq_2*0.05)+pi)+273; % Create sinusoidal wave input heater 2 starting from 70 degrees
% figure(2); hold on; plot(wave_h2);

% Concatenate Reference Temperature Sequences
reference = zeros(length(seq_1)+length(seq_2),2);
reference(1:length(seq_1),:) = [seq_1.',seq_1.'];
reference(length(seq_1)+1:length(seq_1)+length(lin_50),:) = [lin_50.', lin_50.'];
reference(length(seq_1)+length(lin_50)+1:end,:) = [wave_h1(43:1290).', wave_h2(43:1290).'];

% Plot Reference Temperature
figure(1); clf; 
set(gcf, 'Position', [600, 400, 600, 500]);
plot(reference);
title('Reference Temperature', 'Interpreter', 'Latex');
grid on; set(gca, 'Fontsize', 12); legend('Reference Temperature Heater 1', 'Reference Temperature Heater 2', 'Reference Temperature Heater 2', 'Location','southeast', 'Interpreter', 'Latex')
xlabel('Temperature [K]', 'Interpreter', 'Latex'); ylabel('Time [s]', 'Interpreter', 'Latex');

%% Run Closed Loop System with Reference as Input
% Convert Continuous Time Closed Loop System to Discrete Time
syscl_pp_discrete = c2d(syscl_pp_scaled, Ts, 'zoh');
% Simulate Time Response
timevector = [(1:Ts:length(reference)+1).', (1:Ts:length(reference)+1).'];
pp_sim = lsim(syscl_pp_discrete, "r", reference, timevector(:,1));
% Plot Simulation Results
figure(2); clf;
set(gcf, 'Position', [600, 400, 600, 500]);

plot(pp_sim(:,1), ...
        'color', [0, 0, 1, 1], ...
        'LineWidth', 2); hold on;
title('White-Box Simulation - Pole Placement', 'Interpreter', 'Latex');
plot(pp_sim(:,2), ...
        'color', [1, 0, 0, 1], ...
        'LineWidth', 2);
plot(reference(:,1), ...
        'color', [0, 0, 1, 0.5], ...
        'LineWidth', 1);
plot(reference(:,2), ...
        'color', [1, 0, 0, 0.5], ...
        'LineWidth', 1);
grid on; set(gca, 'Fontsize', 12); legend('Output Heater 1', 'Output Heater 2', 'Reference Temperature Heater 1', 'Reference Temperature Heater 2', 'Location','southeast', 'Interpreter', 'Latex');
xlabel('Temperature [K]', 'Interpreter', 'Latex'); ylabel('Time [s]', 'Interpreter', 'Latex');
ylim([255, 290]); hold off;