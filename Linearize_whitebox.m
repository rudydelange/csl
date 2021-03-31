% Control Systems Lab (2020-2021) - Group 3
close all; clear all; clc

%% Optimized parameters from white box
areahat = 0.0009;     
areashat = 0.0004;
tauhat =  24.4408;
masshat = 0.0052;
emishat = 0.9000;
boltz = 5.67e-8;
cphat = 501.9208;
uhat = 10.2021;
alpha1hat = 0.0114;
alpha2hat = 0.0079;
ushat = 13.8985;

Tamb1 = 273.15+19.4037+7;
Tamb2 = 273.15+18.4262+6.5;

%% Data from experiment 
data = readtable('exceldata22.xlsx');
data = table2array(data);
tout = data(:,5);

h = tout(2)-tout(1);
y1 = data(:,3)+273.15;
y2 = data(:,4)+273.15;
x0 = [y1(1);y2(1)];  %Initial guess

%% Linearization of non-linear continuous time model at operating point: [300 300 300 300], [15 15]
[A,B,C,D] = linmod('nlmodelLIN', [300 300 300 300], [15 15]);
syst = ss(A,B,C,D);

%% Create a discrete state-space model 
Ad = c2d(syst,h,'zoh');

%% Save variables in file 
filename = 'syst_TS1_TS2_TH1_TH2.mat';
save(filename)