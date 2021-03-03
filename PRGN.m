% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc

%% TCLab Initialization
tclab;

%% Random Input Noise
% Generate Periodic Random Gaussian Input Signal (Entire Frequency Range)
% NumChannel = 1;     % Number of channels
% Period = 250 %1572;        % Amount of samples within period
% NumPeriod = 1;      % Number of periods
% u1 = idinput([Period,NumChannel,NumPeriod],'sine');    % Create signal over entire frequency range
% u2 = idinput([Period,NumChannel,NumPeriod],'sine');    % Create signal over entire frequency range
% 
% figure(1)
% plot(u1)
% figure(2)
% plot(u2)
% hold off

i = 1;
go1 = true;
while go1
    temperature1 = randi([0 100]);
    duration1 = randi([1 8]);
    for j=i:i+duration1
        if i == 3000
            go1 = false;
        else
            u1(j) = temperature1;
            i = i + 1;
        end
    end
end
i = 1;
go2 = true;
while go2
    temperature2 = randi([0 100]);
    duration2 = randi([1 8]);
    for j=i:i+duration2
        if i == 3000
            go2 = false;
        else
            u2(j) = temperature2;
            i = i + 1;
        end
    end
end
figure(1); plot(u1); hold on; plot(u2);

u1 = transpose(u1);
u2 = transpose(u2);

% % Generate PRBS (Pseudo Random Binary Sequence)
% Band = [0 1];   % Specify clock period
% Range = [0 100]; % Switch values between 0 and 100
% prbs = idinput(250, 'prbs', Band, Range); % Create 250 samples
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
disp('Start')

% iter = length(prbs); % PRBS
iter = length(u1); %PRGIS
k = 1;
time2 = zeros(1,iter);
treshold_temp = 60; % [degrees]

tStart = tic;
for i = 1:iter
    tic;    % Start stopwatch

    % Read Temp
    t1 = T1C();
    t2 = T2C();
    
    % Define different states
    if  t1 >= 70 || t2 >= 70            % Define abort treshold
        n = 0;
    elseif t1 >= treshold_temp && k == 1 || t2 >= treshold_temp && k == 1     % Define treshold
        cooling_down_temp = randi([25 50]);     % define minimum cooling down temperature [degrees]
        n = 1;
    elseif k == 2                       % Apply heat
        n = 2;
    else                                % Exception --> abort
        n = 3;
    end

    
    switch n
    case 0
        % Abort process + turn off heaters
        disp('TOO HOT --> QUIT!!!')
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
        break
        
    case 1
        % Turn off heaters
        disp(['Treshold reached! Turn off heaters! ',num2str(i)])
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
        k = 2;

    case 2
        % Turn off heaters until minimum temperature
        disp(['Treshold reached! Turn off heaters until ', num2str(cooling_down_temp), ' deg. ', num2str(i)])
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
        if t1 < cooling_down_temp && t2 < cooling_down_temp
            k = 1;
        end
        
    case 3
        % Heat with PRBS
        disp(['Turn on Heaters 1 & 2 with PRBS. ', num2str(i)])
        % ht1 = prbs(j,:) * 100         % PRBS
        % ht1 = 50 + u1(i,:) * 25;      % PRGIS (full frequency band)
        % ht2 = 50 + u2(i,:) * 25;      % PRGIS 
        ht1 = u1(i,:);
        ht2 = u2(i,:);
        
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
        % Exception
        disp('Something went wrong boii')
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
        break
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
    time = linspace(0,n*1.2+2,n);

    clf
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

%         t_pause = max(0.01,1.0-t);
%         total_duration = total_duration + t + t_pause;
    t = toc
    %time2(i) = t + max(0.01,1.2-t);
    pause(max(0.01,1.2-t))
end
tEnd = toc(tStart)

total_duration = sum(time2);
disp(['total_duration = ', num2str(sum(time2)), 'seconds'])

disp('Turning off heaters!')
h1(0);
h2(0);
disp('Heaters have been turned of!')

% Write to Excel
disp('Write to Excel')T
U = [h1s.', h2s.'];
Y = [t1s.', t2s.'];
excelMatrix = [U, Y,time.'];
filename = 'exceldata.xlsx'; 
writematrix(excelMatrix, filename, 'Sheet', 1, 'Range', 'A1')

%%
% 30*60/105*100:     30min*60sec/105*100=[#iteraties]
% 52.4044 iter/min