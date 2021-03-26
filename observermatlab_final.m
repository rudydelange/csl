close all
clear all
clc

%% Discrete Matrices
load('syst_TS1_TS2_TH1_TH2.mat')
load('L_Lr_Pole_Placement_final.mat','Poles_PP')

phi = Ad.A;
gamma = Ad.B;

% Linearization point
y0 = [300; 300];
u0 = [15; 15];
x0 = [300;300;300;300];

% Poles for observer
P = [Poles_PP]*2;

%% Solve observer gain K for desired Poles P
K = place(A.',C.',P).'

%% Check observability 
ohm = obsv(A,C);
observability = length(A) - rank(ohm); % If zero --> observable

%% Observer
% returns xhat

data = readtable('exceldata22.xlsx');
data = table2array(data);
U1 = [data(:,5) data(:,1)];
U2 = [data(:,5) data(:,2)];


y1 = [data(:,5) data(:,3)+273.15];
y2 = [data(:,5) data(:,4)+273.15];
tout = data(:,5);
h = tout(2)-tout(1);

sim('observermodel_final')

%% Plot figures of the data

figure(1);
plot(simout_xhat.time,simout_xhat.data+300-273.15)
grid on
title('Observer states', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Temperature [degrees]', 'Interpreter', 'Latex')
legend('Sensor 1','Sensor 2', 'Heater 1', 'Heater 2', 'Interpreter', 'Latex')
xlim([0 2500])
ylim([18 38])

figure(2);
plot(y1(:,1),y1(:,2)-273.15,y2(:,1),y2(:,2)-273.15)
grid on
title('Sensor outputs', 'Interpreter', 'Latex')
xlabel('Time [s]', 'Interpreter', 'Latex')
ylabel('Temperature [degrees]', 'Interpreter', 'Latex')
legend('Sensor 1','Sensor 2', 'Interpreter', 'Latex')
xlim([0 2500])


%% Save K-matrix
save('K_matrix_final.mat','K')