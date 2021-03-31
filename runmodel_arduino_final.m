close all; clear all; clc

load('syst_TS1_TS2_TH1_TH2.mat')
load('K_matrix_final.mat')
%load('L_Lr_Pole_Placement_final.mat') %Pole Placement
load('L_Lr_LQR_final.mat') % LQR

init_temp = 20 + 273.15;

y0 = [300; 300];
u0 = [15; 15];
x0 = [300;300;300;300];

%% Discrete states
phi = Ad.A;
gamma = Ad.B;

% nep_u = [tout, (15)*ones(2500,1),(15)*ones(2500,1)];
% nep_y = [tout, (290)*ones(2500,1),(290)*ones(2500,1)];
%% Create reference temperature

%ref = [tout, (32+273.15)*ones(2500,1), (32+273.15)*ones(2500,1)];

% duration = 2500; % seconds
% ref1 = randi([25+273 50+273]);
% duration1 = randi([300 750]);
% j1 = 1; j2 = 1;
% for i=1:duration
%     if j1 <= duration1
%         u1(i) = ref1;
%         j1 = j1 + 1;
%     else
%         j1 = 1;
%         ref1 = randi([25+273 50+273]);
%         duration1 = randi([300 750]);
%         u1(i) = ref1;
%     end  
% end
% ref1=u1;
ref1 = zeros(2500,1);
for i=1:450
    ref1(i) = 36;
end
for i=451:900
    ref1(i) = 47;
end
for i=901:1600
    ref1(i) = 40;
end
for i=1601:2150
    ref1(i) = 34;
end
for i=2151:2500
    ref1(i) = 45;
end

ref1 = ref1+273.15;

ref2=ref1-3;
figure(1); plot(ref1-273.15); hold on; plot(ref2-273.15); hold off; title('Reference temperatures', 'Interpreter', 'Latex'); xlabel('time [s]', 'Interpreter', 'Latex'); ylabel('temperature [degrees]', 'Interpreter', 'Latex'); legend('refenence 1','reference 2', 'Interpreter', 'Latex');
ref = [tout,ref1,ref2];
%ref = [(tout(1):tout(600)).',ref1.',ref2.'];
%ref = [(ref(1):ref(5)).',[300;300;300;300;300],[295;295;295;295;295]]

sim('full_model_arduino_final')


%% Save Output Simulink & Plot Reference versus Temperature
sim_output = ans;
 
sim_output_data_y = get(sim_output, 'simout_y');
sim_output_data_xhat = get(sim_output, 'simout_xhat');
sim_output_data_u = get(sim_output, 'simout_u');


% Plot Reference versus Output Data
figure(2); grid on;
title('Reference vs Sensor output', 'Interpreter', 'Latex')
plot(ref(:,2)-273.15); hold on; 
plot(ref(:,3)-273.15); 
plot(sim_output_data_y.time,sim_output_data_y.data);
xlabel('Time [s]', 'Interpreter', 'Latex'); ylabel('Temperature [degrees]', 'Interpreter', 'Latex');
xlim([0 2500])
legend('Reference Heater 1', 'Reference Heater 2', 'Sensor 1', 'Sensor 2', 'Interpreter', 'Latex');

figure(3)
plot(sim_output_data_xhat.time,sim_output_data_xhat.data)
title('Incremental bserver states', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Incremental temperature', 'Interpreter', 'Latex')
legend('Sensor 1','Sensor 2', 'Heater 1', 'Heater 2', 'Interpreter', 'Latex')
xlim([0 2500])

figure(4)
plot(sim_output_data_u.time,sim_output_data_u.data)
title('Heater inputs Q1 and Q2', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Heater input [\%]', 'Interpreter', 'Latex')
legend('Q1','Q2','Interpreter', 'Latex')
xlim([0 2500])

figure(5)
plot(sim_output_data_xhat.time,sim_output_data_xhat.data+300-273.15)
title('Observer states', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Temperature [degrees]', 'Interpreter', 'Latex')
legend('Sensor 1','Sensor 2', 'Heater 1', 'Heater 2', 'Interpreter', 'Latex')
xlim([0 2500])