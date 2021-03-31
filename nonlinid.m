% Control Systems Lab (2020-2021) - Group 3
% White-box parameter estimation
clear all; clc; close all;

%% Initial guess of parameters
u_init = 10;
us_init = 10;
cp_init = 500;
emis_init = 0.9;
tau_init = 24;
mass_init = 0.004;
area_init = 0.001;
areas_init = 0.0002;
alpha1_init = 0.01;
alpha2_init = 0.0075;

parai = [u_init,us_init,cp_init,emis_init,tau_init,mass_init,area_init,areas_init,alpha1_init,alpha2_init];

%% Constant parameters
boltz = 5.67e-8;

%% Data from experiment 
data = readtable('exceldata20.xlsx'); %Training data set.
%data = readtable('exceldata21.xlsx'); %Validation data set.
data = table2array(data);

Q1 = [data(:,5) data(:,1)];     %Input heater 1
Q2 = [data(:,5) data(:,2)];     %Input heater 2
tout = data(:,5);               %Time 
h = tout(2)-tout(1);            %Sample time
T_S1_real = data(:,3)+273.15;   %Temperature measured by sensor 1 
T_S2_real = data(:,4)+273.15;   %Temperature measured by sensor 2

x0 = [T_S1_real(1);T_S2_real(1)]; % Initial state

%% Plot the multi-level telegraph signal
figure(1)
stairs(Q1(:,1),Q1(:,2));
hold on;
stairs(Q2(:,1),Q2(:,2));
xlabel('time [s]');
ylabel('Heater input [%]');
title('Multi-level telegraph heater input signals,training data set'); 
legend('Heater input Q1','Heater input Q2');
xlim([0,5400]);
hold off;

%% Define ambient temperature using initial state 
Tamb1 = x0(1)+7; 
Tamb2 = x0(2)+6.5;

%% Set the options for the nonlinear optimization
OPT = optimset('MaxIter',100,'TolX',1e-4); 
%OPT.Algorithm = 'levenberg-marquardt'; %Uncomment when using levenberg-marquardt

%% Set the lower and upper bounds for optimization
lb = [9,-40,  490,   0.9, 20,0.0001,0.0001,0.00001,0.0001  ,0.0001];
ub = [11,40,  510,   0.901,25,0.01,0.01,0.001,0.1,0.1];

%% Define the cost function 
f = @(x)costfun(x,T_S1_real,T_S2_real); 

%% Execute the nonlinear optimization
% Here the estimated parameters called 'parahat' are found
[parahat,fcost,~,exitflag,output] = lsqnonlin(f,parai,lb,ub,OPT)


%% Run the non-linear model with the optimized parameters and calculate the fit
sim('nlmodel');

FIT_heater1 = 100 * (1-norm(T_S1_real-T_S1)/norm(T_S1_real-mean(T_S1_real)))
FIT_heater2 = 100 * (1-norm(T_S2_real-T_S2)/norm(T_S2_real-mean(T_S2_real)))



