close all; clear all; clc

load('matrices.mat')
load('K_matrix.mat')
load('discretemodel.mat')
load('L_Lr_Pole_Placement.mat') %Pole Placement
%load('L_Lr_LQR.mat') % LQR

%%
init_temp = 20 + 273.15;

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

sim('observer_controller_model_arduino')


%% Save Output Simulink & Filter Data
sim_output = ans;
 
% Plot Reference versus Output Data
sim_output_data = get(sim_output, 'simout');
figure(1); grid on;
title('Reference versus Ouput Temperature', 'Interpreter', 'Latex');
plot(sim_output_data);
xlabel('Time [s]', 'Interpreter', 'Latex'); ylabel('Temperature [K]', 'Interpreter', 'Latex');
legend('Reference Heater 1', 'Reference Heater 1', 'Output Heater 1', 'Output Heater 2', 'Interpreter', 'Latex');

% Retrieve Simulink Data
 function myfunc
    a = sim('observer_controller_model', 'SimulationMode', 'normal')
    b = a.get('simout')
    assignin('base', 'b', b);
 end
