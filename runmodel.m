close all; clear all; clc

load('matrices.mat')          %These are the continuous matrices (A,B,C,D) and a discrete system (Ad.A,Ad.B,Ad.C,Ad.D)
load('matrices_observer.mat') %Matrices for observer: Phi, gamma, C, D and gain K
% load('LandLr.mat'); %         %L and Lr for controller using pole placement
load('LQR_L_LR.mat');        %L and Lr for controller using LQR



% ref = [tout, (30+273.15)*ones(2500,1), (30+273.15)*ones(2500,1)];
init_temp = 30+273.15;

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
ref = [tout,ref1.',ref1.'-3];

sim('observer_controller_model')

%% Save Output Simulink & Plot Reference versus Temperature
sim_output = ans;
 
% Plot Reference versus Output Data
sim_output_data = get(sim_output, 'simout');
figure(1); grid on;
title('Reference versus Ouput Temperature', 'Interpreter', 'Latex');
plot(ref(:,2)); hold on; 
plot(ref(:,3)); 
plot(sim_output_data);
xlabel('Time [s]', 'Interpreter', 'Latex'); ylabel('Temperature [K]', 'Interpreter', 'Latex');
xlim([25 2500])
legend('Reference Heater 1', 'Reference Heater 1', 'Output Heater 1', 'Output Heater 2', 'Interpreter', 'Latex');

% Retrieve Simulink Data
 function myfunc
    a = sim('observer_controller_model', 'SimulationMode', 'normal')
    b = a.get('simout')
    assignin('base', 'b', b);
 end