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

%% Save Output Simulink & Filter Data
sim_output = ans;
 
% Plot Reference versus Output Data
sim_output_data = get(sim_output, 'simout');
figure(1); grid on;
title('Reference versus Ouput Temperature', 'Interpreter', 'Latex');
plot(sim_output_data);
xlabel('Time [s]', 'Interpreter', 'Latex'); ylabel('Temperature [K]', 'Interpreter', 'Latex');
legend('Reference Heater 1', 'Reference Heater 1', 'Output Heater 1', 'Output Heater 2', 'Interpreter', 'Latex');

% Filter Output Data -> Set before scope 3 directly after output y of simulated process
time_series_mean = mean(sim_output_data); % Retrieve mean assuming zero mean
interval = [0.01 5]; % Specify filter interval in Hz
time_series_notch = idealfilter(sim_output_data, interval, 'notch'); % Apply notch filter
time_series_notch_mean = time_series_notch + time_series_mean; % Return mean
% Plot Filtered output data
figure(2);
title('Reference versus Filtered Ouput Temperature', 'Interpreter', 'Latex');
plot(ref1); hold on; grid on;
plot(ref1);
plot(time_series_notch_mean);
legend('Reference Heater 1', 'Reference Heater 1', 'Filtered Output Heater 1', 'Filtered Output Heater 2', 'Interpreter', 'Latex');
xlabel('Time [s]', 'Interpreter', 'Latex'); ylabel('Temperature [K]', 'Interpreter', 'Latex');

% Retrieve Simulink Data
 function myfunc
    a = sim('observer_controller_model', 'SimulationMode', 'normal')
    b = a.get('simout')
    assignin('base', 'b', b);
 end