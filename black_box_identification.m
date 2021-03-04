% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;
%% Read Excel Data
temp_dat1 = xlsread('temperature_correct_1_v2.xlsx');
temp_dat2 = xlsread('temperature_correct_2_v2.xlsx');
% temp_dat3 = xlsread('temperature_correct_3.xlsx');
% temp_dat1 = xlsread('temperature_correct_oneheater_h1_1.xlsx');
% temp_dat2 = xlsread('temperature_correct_oneheater_h2_1.xlsx');

%% Restructure Data
% Create matrix for each respective dataset, heater & sensor
dat1_h12 = [temp_dat1(:,1), temp_dat1(:,2)]; % dataset 1, heater 1, heater 2
dat1_s12 = [temp_dat1(:,3), temp_dat1(:,4)]; % dataset 1, sensor 1, sensor 2
dat2_h12 = [temp_dat2(:,1), temp_dat2(:,2)]; % dataset 2, heater 1, heater 2
dat2_s12 = [temp_dat2(:,3), temp_dat2(:,4)]; % dataset 2, sensor 1, sensor 2
% dat3_h12 = [temp_dat3(:,1), temp_dat3(:,2)]; % dataset 3, heater 1, heater 2
% dat3_s12 = [temp_dat3(:,3), temp_dat3(:,4)]; % dataset 3, sensor 1, sensor 2
% Time increments per dataset
dat1_t = temp_dat1(2,5); % dataset 1, time increment 
dat2_t = temp_dat2(2,5); % ''   '' 2, ''    ''    ''
% dat3_t = temp_dat3(2,5); % ''   '' 3, ''    ''    ''

%% Removing Mean of Data
dat1_h12_detrend = detrend(dat1_h12); % detrend dataset 1, heater 1, heater 2
dat1_s12_detrend = detrend(dat1_s12); % ''    ''    ''      ''      ''
dat2_h12_detrend = detrend(dat2_h12); % ''    ''    ''      ''      ''
dat2_s12_detrend = detrend(dat2_s12); % ''    ''    ''      ''      ''
% dat3_h12_detrend = detrend(dat3_h12); % ''    ''    ''      ''      ''
% dat3_s12_detrend = detrend(dat3_s12); % ''    ''    ''      ''      ''

%% Open System Identification GUI
systemIdentification;    % start GUI function