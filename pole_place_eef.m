close all; clear all; clc
format long;
load('matrices.mat')

A = A;
B = B;
C = C;
D = D;

Ecl = eig(A);

cont_sys = ss(A,B,C,D);

Contr = ctrb(A,B);
Contr_check = length(A) - rank(Contr); % It is full rank thus controllable

%[wn,zeta,P] = damp(cont_sys);

%P = P*1.5

P=[-0.061372786488167
  -0.061372786488167
  -0.017546331167598
  -0.017546331167598] 

%P = 1.5*P

% Place poles of system @ desired location & Create Gain Matrix L
L  = place(A,B,P);


Acl = A-B*L;
Ecl = eig(Acl)

syscl = ss(Acl,B,C,D);

figure(1)
step(syscl)

Kdc = dcgain(syscl);
Lr = inv(Kdc);

figure(2)
syscl_scaled = ss(Acl,B*Lr,C,D);
step(syscl_scaled)

filename = 'LandLr.mat';
save('LandLr.mat','L','Lr','P');