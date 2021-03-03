function e = costfun(x,y1,y2)
% cost function for nonlinear parameter tuning
% x contains the candidate parameters, U is the experimental input signal
% and y is the experiemental output signal

assignin('base','alpha1hat',x(1));       % assign bhat in workspace
assignin('base','alpha2hat',x(2));       % assign bhat in workspace
assignin('base','uhat',x(3));            % assign bhat in workspace
assignin('base','ushat',x(4));           % assign bhat in workspace
assignin('base','cphat',x(5));           % assign bhat in workspace



sim('nlmodel');                         % simulate nonlinear model using current candidate parameter (LET OP IN NLMODEL MOET HET MET HAT ZIJN)
                                        % the nonlinear model is built on
                                        % top of the real system, but of
                                        % course in this case there is no
                                        % noise
e1 = y1-ym1;  
e2 = y2-ym2;

e = [e1; e2]; 

figure(1); plot(tm,[y1 ym1]); xlabel('time [s]'); ylabel('Sensor temperature [K]');
figure(2); plot(tm,[y2 ym2]); xlabel('time [s]'); ylabel('Sensor temperature [K]'); % intermediate fit
%pause
%stairs
