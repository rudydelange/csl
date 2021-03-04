% Control Systems Lab (2020-2021) - Group 3 - Black Box Pole Zero Plots
%% Pole-Zero Plots
% ARX
figure(1);
iopzmap(arx_2nd,arx_4th,arx_7th);
%legend(arx_2nd,'r',arx_2nd,'b',arx_4th,'g',arx_4th,'y',arx_7th,'c',arx_7th,'m');
legend;
% ARMAX
figure(2);
iopzmap(amx_2nd_lsqnonlin,amx_4th_lsqnonlin,amx_7th_lsqnonlin);
legend;
% OE
figure(3);
iopzmap(oe_2nd_lsqnonlin,oe_4th_lsqnonlin,oe_7th_lsqnonlin);
legend;
% BJ
figure(4); 
iopzmap(bj_2nd_lsqnonlin,bj_4th_lsqnonlin,bj_7th_lsqnonlin);
legend;