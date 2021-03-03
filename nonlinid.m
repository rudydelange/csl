% estimate (fine-tune) a parameter in a nonlinear Simulink model

clear all; clc; close all;
%para = [0.5,0.5,0.5,0.5,0.5];     % "true" parameter value
% parai = [0.02,0.04,0.05,0.08,0.02];   % initial guess
%parai = [0.0006,0.0004,-5.6397,-4.8346,1.2361];
% parai = [0.0354,0.0238,48.8364,212.1712,0.0242]
parai = [0.01,0.0075,10,10,500];

% x0 = [318;313]; % initial state (voor integratiebereik) 

area = 0.001;
area_s = 0.0002;
tau = 24;
m = 0.004;
emis = 0.9;
boltz = 5.67e-8;
Tamb = 18+273;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% design input excitation signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T = 100;    % length of experiment
% h = 0.05;   % sampling interval
% ts = 10;    % estimated settling time of the process
% A = 1;      % amplitude of GBN
% U1 = [h*(0:T/h)' gbn(T,ts,A,h,1)]; % input signal (first colum contains

%A =1; % sampling instants, second actual input signal)
% U2 = [h*(0:T/h)' gbn(T,ts,A,h,1)];                                
%U2 = U1; %Kennelijk wordt Us (Heat transfer coefficient between heaters)
%weird als je exact dezelfde input aanlegd. Wrs zijn er dan meerdere
%oplossingen omdat er eigenlijk geen transfer plaats kan vinden ofzo?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% implement the experimental data of the setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T = 100;    % length of experiment
% h = 0.05;   % sampling interval
% ts = 10;    % estimated settling time of the process
% A = 1;      % amplitude of GBN

data = readtable('exceldata8_wacketijd.xlsx');
data = table2array(data);
U1 = [data(:,5) data(:,1)];
U2 = [data(:,5) data(:,2)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data collection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sim('nlsysid');     % this simulates the real system, which is affected by noise
                    % ouput data available in variable y in the workspace
                    %(LET OP IN NLSYSID MOET HET ZONDER 'HAT' ZIJN)
tout = data(:,5);
h = tout(2)-tout(1);
y1 = data(:,3)+273.15;
y2 = data(:,4)+273.15;
x0 = [y1(1);y2(1)]; % initial state (voor integratiebereik) 
%x0 = [318;313];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nonlinear optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OPT = optimset('MaxIter',100,'TolX',1e-8); % options
lb = [-Inf,-Inf,-Inf,-Inf,-Inf];
ub = [Inf,Inf,Inf,Inf,Inf];
f = @(x)costfun(x,y1,y2); % anonymous function for passing extra input arguments to the costfunction
%[parahat,fval]= lsqnonlin(f,parai,lb,ub,OPT); % actual optimization
[parahat,fcost,~,exitflag,output] = lsqnonlin(f,parai,lb,ub,OPT)
%[para parahat]
% [x,fval,exitflag,output]  = simulannealbnd(f,parai,lb,ub,OPT)
