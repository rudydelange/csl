% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc;
%% Read Excel Data
temp_dat_1 = xlsread('temperature_new_1.xlsx')
temp_dat_2 = xlsread('temperature_new_2.xlsx')

%% Open System Identification GUI
systemIdentification;