% estimate (fine-tune) a parameter in a nonlinear Simulink model

clear all; clc; close all;
parai = [10,10,500,0.9,24,0.004,0.001,0.0002,0.01,0.0075];
% parai = [10,10,0.01,0.0075];

% 
% areahat = 0.0013;      %7.0496e-04;
% areashat=  2.2836e-04;
% %tauhat =    30.3393;
% masshat = 0.0042;
% emishat = 0.8949;
% boltz = 5.67e-8;
% %cphat = 114.609;
% uhat = 7.545;
% alpha1hat = 0.0112;
% alpha2hat = 0.0075;
% %ushat = 53.7736;

%parai = [10,10,500,0.9,24,0.004,0.001,0.0002,0.01,0.0075];
% areahat = 0.001;  
% areashat=  0.0002;
% tauhat =    24;
% masshat = 0.004;
% emishat = 0.9;
boltz = 5.67e-8;
% cphat = 500;


areahat = 0.001;      %7.0496e-04;
areashat=  0.0002;
tauhat =    24;
masshat = 0.004;
emishat = 0.9;
boltz = 5.67e-8;
cphat = 500;
uhat = 10;
ushat = 10;
alpha1hat = 0.01;
alpha2hat = 0.0075;



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

data = readtable('exceldata18.xlsx');
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
x0 = [y1(1);y2(1)]; % initial state (voor integratiebereik) & gelijk aan Tamb



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nonlinear optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OPT = optimset('MaxIter',100,'TolX',1e-8); % options


%parai = [10,10,500,0.9,24,0.004,0.001,0.0002,0.01,0.0075];
%parai = [0.01,10];

lb = [1,10,  100,   0.5, 0.1,0.0001,0.0001,0.00001,0.0001  ,0.0001];
ub = [20,40,  800,   0.99,50,0.01,0.01,0.001,0.1,0.1];


f = @(x)costfun(x,y1,y2); % anonymous function for passing extra input arguments to the costfunction
[parahat,fcost,~,exitflag,output] = lsqnonlin(f,parai,lb,ub,OPT)