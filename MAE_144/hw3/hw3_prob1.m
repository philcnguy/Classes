clear all; clc; clf;

s = tf('s');
a0 = 0.1;
b0 = 0.1;
d = 6;

num = b0;
den = s + a0;
G = num / den;

num_delay = num * (1 - d*s/2 + (d*2)^2/12);
den_delay = den * (1 + d*s/2 + (d*s)^2/12);
G_delay = num_delay / den_delay;

figure(1)
bode(G);
title("Bode Plot with No Delay");

figure(2)
bode(G_delay);
title("Bode Plot with Delay");

alpha = 0.1;
beta = 5;
gamma = 1;

K_u = 0.8;
D_P = K_u;

figure(3)
rlocus(G_delay * D_P / (1 + G_delay * D_P));
figure(4)
bode(G_delay * D_P / (1 + G_delay * D_P))

omega_u = 0.588; % from Bode plot
T_u = 1 / omega_u;
K_p = alpha * K_u;
T_I = beta * T_u;
T_D = gamma * T_u;

D_PID = K_p * T_D * (s^2 + s/T_D + 1/(T_I*T_D)) / s;

figure(5)
rlocus(G_delay * D_PID / (1 + G_delay * D_PID));
figure(6)
bode(G_delay * D_PID / (1 + G_delay * D_PID));

% 
% 
% omega_u = 0.3;
% 
% T_u = 1 / omega_u;
% K_p = alpha * K_u;
% T_I = beta * T_u;
% T_D = gamma * T_u;
% 
% D_PID = K_p * T_D * (s^2 + s/T_D + 1/(T_I*T_D)) / s;
% 
% figure(3)
% bode(G_delay * D_PID / (1 + G_delay * D_PID));
% 
% figure(4)
% rlocus(G_delay * D_P / (1 + G_delay * D_P));
% figure(5)
% bode(G_delay * D_P / (1 + G_delay * D_P))