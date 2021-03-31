function e = costfun(x,T_S1_real,T_S2_real)
% cost function for nonlinear parameter tuning
% x contains the candidate parameters and T_S1_real,T_S2_real the experimental output signal

% Assign parameters in workspace
assignin('base','uhat',x(1));        % Assign uhat in workspace    
assignin('base','ushat',x(2));           
assignin('base','cphat',x(3));           
assignin('base','emishat',x(4));         
assignin('base','tauhat',x(5));          
assignin('base','masshat',x(6));         
assignin('base','areahat',x(7));         
assignin('base','areashat',x(8));        
assignin('base','alpha1hat',x(9));       
assignin('base','alpha2hat',x(10));      


sim('nlmodel');                     % Simulate nonlinear model using current candidate parameter
                                       
e1 = T_S1_real-T_S1;                % Calculate the error between real sensor temperatures and simulated ones
e2 = T_S2_real-T_S2;

e = [e1; e2]; 

figure(2); stairs(tm,[T_S1_real T_S1]); xlabel('time [s]'); ylabel('Sensor temperature [K]'); title('Parameter estimation (white box) with validation data'); legend('Real Ts1','Simulated Ts1');xlim([0,5400]);
figure(3); stairs(tm,[T_S2_real T_S2]); xlabel('time [s]'); ylabel('Sensor temperature [K]'); title('Parameter estimation (white box) with validation data'); legend('Real Ts2','Simulated Ts2');xlim([0,5400]);