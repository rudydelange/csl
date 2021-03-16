close all; clear all; clc
format long;
load('matrices.mat')

A = A;
B = B;
C = C;
D = D;

Ecl = eig(A);

cont_sys = ss(A,B,C,D);

%p1 = -2*exp(-zeta(1)*wn(1)*h)*cos(wn*h*sqrt(1-zeta(1)^2))

% P = [0.000000001 0.000000002 0.000000001 0.000000002];
% P = exp(P.*h);%poles in z-domain

Contr = ctrb(A,B);
Contr_check = length(A) - rank(Contr); % It is full rank thus controllable

[wn,zeta,P] = damp(cont_sys);

% P = [-0.0283 -0.0117 -0.0212 -0.0088];


%P = [-0.98 -0.98 -0.99 -0.99]; %Rand van stabiliteit --> daarom oscilleren


L  = place(A,B,P);

Acl = A-B*L;
Ecl = eig(Acl);

syscl = ss(Acl,B,C,D);
figure(1);
step(syscl);

Kdc = dcgain(syscl);
Lr = inv(Kdc);

figure(2)
syscl_scaled = ss(Acl,B*Lr,C,D);
step(syscl_scaled);

filename = 'LandLr.mat';
save('LandLr.mat','L','Lr');