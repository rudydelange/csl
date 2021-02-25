% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc

%% TCLab Initialization
tclab;

%% Random Input Noise
% Generate Periodic Random Gaussian Input Signal (Entire Frequency Range)
NumChannel = 1;     % Number of channels
Period = 100;        % Amount of samples within period
NumPeriod = 1;      % Number of periods
u = idinput([Period,NumChannel,NumPeriod],'rgs');    % Create signal over entire frequency range

u1 = iddata([], u, 0.01); % Sample time of 0.01 seconds
figure(1); hold on;
plot(u1)

% Generate Periodic Random Gaussian Input Signal (Passband)
Band = [0 0.5]; % 0 to 0.5 times Nyquist frequency
u2 = idinput([Period,NumChannel,NumPeriod],'rgs', Band);

u2 = iddata([],u2,0.01);
figure(2); hold on;
plot(u2)

% Generate PRBS (Pseudo Random Binary Sequence)
Band = [0 1];   % Specify clock period
Range = [0 1]; % Switch values between 0 and 1
prbs = idinput(250, 'prbs', Band, Range); % Create 250 samples
% figure(3); hold on;
% plot(prbs);    % Plot pattern



%% Specify Initial Values for Heaters
% Create empty arrays for sensor data
t1s = [];
t2s = [];
h1s = [];
h2s = [];
% Initial heater values
ht1 = 0;
ht2 = 0;
h1(ht1); % Initial temperature equals 0
h2(ht2); % '' ''

%% Turn on Heaters
disp('Starting heater 1!')

% iter = length(prbs); % PRBS
iter = length(u); %PRGIS
k = 1;
for i = 1:iter
    for j = 1:iter
        tic;        % Start stopwatch
        
        % Read Temp
        t1 = T1C();
        t2 = T2C();
        % Define treshold
        if  t1 >= 60 || t2 >= 60
            n = 0;
        elseif t1 >= 40 && k == 1 || t2 >= 40 && k == 1
            n = 1;
        elseif k > 1
            n = 2;
        else
            n = 3;
        end
        
        switch n
        case 0
            disp('TOO HOT --> QUIT!!!')
            ht1 = 0;
            ht2 = 0;
            h1(ht1);
            h2(ht2);
            break
        case 1
            % Turn off heaters
            disp('Treshold reached! Turn off heaters!')
            ht1 = 0;
            ht2 = 0;
            h1(ht1);
            h2(ht2);
            k = k + 1
            
        case 2
            % Turn off heaters
            disp('Treshold reached! Turn off heaters! 2 ')
            ht1 = 0;
            ht2 = 0;
            h1(ht1);
            h2(ht2);
            
            k = k + 1
            if k == 10
                k = 1;
            end
        case 3
            % Start Heater with PRBS
            disp('Turn on Heater 1 with PRBS')
%             ht1 = prbs(j,:) * 100 % PRBS
            ht1 = 50 + u(j,:) * 20   % PRGIS (full frequency band) - mean:50% output
            ht2 = 50 + u(j,:) * 20   % heater 1
            if ht1>100
                ht1 = 100;
            end
            if ht1<0
                ht1 = 0;
            end                
            if ht2>100
                ht2 = 100;
            end
            if ht2<0
                ht2 = 0;
            end
            h1(ht1);
            h2(ht2);
        otherwise
            disp('Something went wrong boii')
        end

        % LED brightness
        brightness1 = (t1 - 30)/50.0;  % <30degC off, >100degC full brightness
        brightness2 = (t2 - 30)/50.0;  % <30degC off, >100degC full brightness
        brightness = max(brightness1,brightness2);
        brightness = max(0,min(1,brightness)); % limit 0-1
        led(brightness);

        % Plot heater and temperature data
        h1s = [h1s, ht1];
        h2s = [h2s, ht2];
        t1s = [t1s, t1];
        t2s = [t2s, t2];

        n = length(t1s);
        time = linspace(0,n+1,n);

        clf
%         figure(1)
        subplot(2,1,1)
        plot(time,t1s,'r.','MarkerSize',10);
        hold on
        plot(time,t2s,'b.','MarkerSize',10);
        ylabel('Temperature (degC)')
        legend('Temperature 1','Temperature 2','Location','NorthWest')
        subplot(2,1,2)
        plot(time,h1s,'r-','LineWidth',2);
        hold on
        plot(time,h2s,'b--','LineWidth',2);
        ylabel('Heater (0-5.5 V)')
        xlabel('Time (sec)')
        legend('Heater 1','Heater 2','Location','NorthWest')
        drawnow;
        t = toc;
        pause(max(0.01,1.0-t))
    end
end

disp('Turning off heaters!')
h1(0);
h2(0);

disp('Heaters have been turned of!')

%% Comments
% 30 seconden signaal, hoge amplitude -> programmeren in het script dat als
% temperatuur boven 70 graden komt en dan zet je hem uit