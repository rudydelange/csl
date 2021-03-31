% Control Systems Lab (2020-2021) - Group 3 - Black Box
close all; clear all; clc

%% TCLab Initialization
tclab;

%% Generate random heater inputs 
duration = 5400; % [seconds]
temperature1 = randi([0 100]); temperature2 = randi([0 100]); % Heater input [%]
duration1 = randi([50 200]); duration2 = randi([50 200]);
j1 = 1; j2 = 1;
for i=1:duration
    if j1 <= duration1
        u1(i) = temperature1;
        j1 = j1 + 1;
    else
        j1 = 1;
        temperature1 = randi([0 100]);
        duration1 = randi([50 200]);
        u1(i) = temperature1;
    end
    if j2 <= duration2
        u2(i) = temperature2;
        j2 = j2 + 1;
    else
        j2 = 1;
        temperature2 = randi([0 100]);
        duration2 = randi([50 200]);
        u2(i) = temperature2;
    end        
end
figure(1); plot(u1); hold on; plot(u2); title('Heater inputs'); legend('Heater 1 [%]','Heater 2 [%]') 
u1 = transpose(u1);
u2 = transpose(u2);

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
treshold_temp = 55; % [degrees]

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
        disp('TOO HOT --> QUIT!')
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
        break
        
    case 1
        % Treshold reached! Turn off heaters!
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
        k = 2;

    case 2
        % Turn off heaters until cooling down temperature
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
        if t1 < cooling_down_temp && t2 < cooling_down_temp
            k = 1;
        end
        
    case 3
        % Heaters on
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
        disp('Something went wrong')
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
    %%%%time = linspace(0,n*1.2+2,n);
    time = linspace(0,n*1.0+1,n);

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

    t = toc;
    pause(max(0.01,1.0-t))
end

disp('Turning off heaters!')
h1(0);
h2(0);
disp('Heaters have been turned of!')

% Write to Excel
disp('Write to Excel')
U = [h1s.', h2s.'];
Y = [t1s.', t2s.'];
excelMatrix = [U, Y,time.'];
filename = 'exceldata.xlsx'; 
writematrix(excelMatrix, filename, 'Sheet', 1, 'Range', 'A1')
