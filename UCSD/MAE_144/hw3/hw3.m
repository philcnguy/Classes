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

omega_I = 1 / T_I;
omega_D = 1 / T_D;

figure(5)
rlocus(G_delay * D_PID / (1 + G_delay * D_PID));
figure(6)
bode(G_delay * D_PID / (1 + G_delay * D_PID));

%%
% K_u = 3.2;
% D_P = K_u;
% omega_u = 0.3;
% T_u = 1 / omega_u;
% K_p = alpha * K_u;
% T_I = beta * T_u;
% T_D = gamma * T_u;
% 
% D_PID = K_p * T_D * (s^2 + s/T_D + 1/(T_I*T_D)) / s;

G_total = G_delay * D_PID / (1 + G_delay * D_PID);

t = 0:0.01:5;

u = zeros(size(t));
u(t >= 0 & t < 1) = 35;
u(t >= 1 & t < 4) = 45;
u(t >= 4 & t < 5) = 20;

[y, ~, x] = lsim(G_total, u, t);

figure(7)
plot(t, y + 20, 'LineWidth', 2);
xlabel('Time (hours)');
ylabel('Temperature (degrees C)');
title('Temperature of the Water Bath over Time');
grid on;

%%

G_delay_discrete = c2d(G_delay,2);

figure(8)
rlocus(G_delay_discrete);
figure(9)
bode(G_delay_discrete);

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