close all; clear all; clc
load('matrices.mat') 

ref = [tout, (40+273.15)*ones(2500,1), (35+273.15)*ones(2500,1)];

duration = 2500; % seconds
ref1 = randi([25+273 50+273]);
duration1 = randi([200 750]);
j1 = 1; j2 = 1;
for i=1:duration
    if j1 <= duration1
        u1(i) = ref1;
        j1 = j1 + 1;
    else
        j1 = 1;
        ref1 = randi([25+273 50+273]);
        duration1 = randi([200 750]);
        u1(i) = ref1;
    end  
end
ref1=u1; 
figure(1); plot(ref1); hold on; plot(ref1); 
ref = [tout,ref1.',ref1.'-3];

save('reference.mat','ref');