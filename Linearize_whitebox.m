close all; clear all; clc

areahat = 0.0009;     
areashat=  0.0004;
tauhat =    24.4408;
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

data = readtable('exceldata21.xlsx');
data = table2array(data);
tout = data(:,5);

h = tout(2)-tout(1);
x0 = [0;0];

[A,B,C,D] = linmod('nlmodelLIN', [300 300 300 300], [60 60]);
syst = ss(A,B,C,D);
Ad = c2d(syst,h,'zoh');

Ad.A([1,5,2,6,3,7,4,8,9,13,10,14,11,15,12,16]) = Ad.A([11,15,12,16,9,13,10,14,3,7,4,8,1,5,2,6]);
Ad.B([1,5,2,6,3,7,4,8]) = Ad.B([3,7,4,8,1,5,2,6]);
Ad.C([1,3,2,4,5,7,6,8]) = Ad.C([5,7,6,8,1,3,2,4]);

Ad



