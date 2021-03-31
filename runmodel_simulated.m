% Control Systems Lab (2020-2021) - Group 3 
close all; clear all; clc

%% Load data
load('syst_TS1_TS2_TH1_TH2.mat')
load('K_matrix.mat')
%load('L_Lr_Pole_Placement.mat') %Pole Placement
load('L_Lr_LQR.mat') % LQR

init_temp = 20 + 273.15;

% Define linearization point
y0 = [300; 300];
u0 = [15; 15];
x0 = [300;300;300;300];

%% Discrete states
phi = Ad.A;
gamma = Ad.B;

%% Create random reference temperature

duration = 2500; % [seconds]
ref1 = randi([25+273 50+273]); % [K]
duration1 = randi([300 750]); % [seconds]
j1 = 1; j2 = 1;
for i=1:duration
    if j1 <= duration1
        u1(i) = ref1;
        j1 = j1 + 1;
    else
        j1 = 1;
        ref1 = randi([25+273 50+273]);
        duration1 = randi([300 750]);
        u1(i) = ref1;
    end  
end
ref1 = u1;
ref2 = ref1-3;
figure(1); plot(ref1-273.15); hold on; plot(ref2-273.15); hold off; title('Reference temperatures', 'Interpreter', 'Latex'); xlabel('time [s]', 'Interpreter', 'Latex'); ylabel('temperature [degrees]', 'Interpreter', 'Latex'); legend('refenence 1','reference 2', 'Interpreter', 'Latex');

ref = [tout,ref1.',ref2.'];

%% Run Simulink model with TCLab
sim('full_model_simulated')

%% Save Output Simulink & Plot 
sim_output_simulated = ans;
 
sim_output_data_y_simulated = get(sim_output_simulated, 'simout_y_simulated');
sim_output_data_xhat_simulated = get(sim_output_simulated, 'simout_xhat_simulated');
sim_output_data_u_simulated = get(sim_output_simulated, 'simout_u_simulated');


% Plot Reference versus Output Data
figure(2); grid on;
title('Reference vs Sensor output', 'Interpreter', 'Latex')
plot(ref(:,2)-273.15); hold on; 
plot(ref(:,3)-273.15); 
plot(sim_output_data_y_simulated.time,sim_output_data_y_simulated.data-273.15);
xlabel('Time [s]', 'Interpreter', 'Latex'); ylabel('Temperature [degrees]', 'Interpreter', 'Latex');
xlim([0 2500])
legend('Reference Heater 1', 'Reference Heater 2', 'Sensor 1', 'Sensor 2', 'Interpreter', 'Latex');

figure(3)
plot(sim_output_data_xhat_simulated.time,sim_output_data_xhat_simulated.data)
title('Incremental bserver states', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Incremental temperature', 'Interpreter', 'Latex')
legend('Sensor 1','Sensor 2', 'Heater 1', 'Heater 2', 'Interpreter', 'Latex')
xlim([0 2500])

figure(4)
plot(sim_output_data_u_simulated.time,sim_output_data_u_simulated.data)
title('Heater inputs Q1 and Q2', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Heater input [\%]', 'Interpreter', 'Latex')
legend('Q1','Q2','Interpreter', 'Latex')
xlim([0 2500])

figure(5)
plot(sim_output_data_xhat_simulated.time,sim_output_data_xhat_simulated.data+300-273.15)
title('Observer states', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Temperature [degrees]', 'Interpreter', 'Latex')
legend('Sensor 1','Sensor 2', 'Heater 1', 'Heater 2', 'Interpreter', 'Latex')
xlim([0 2500])