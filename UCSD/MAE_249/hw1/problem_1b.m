clear all; clc; clf

%% Problem 1b

t = linspace(0, 20, 81);

P_in = 20; % kPa
R = 1.4e6; % 1 / (m * s)
C = 2.5 / (1.25 * 1000 * 1000); % m * s^2

P = length(zeros(1,81));

P(1) = 0;
for i = 2:81
    if (mod(i,4) == 2)
        P(i:i+2) = (P(i-1) - P_in) * exp(-t(2:4) / (R * C)) + P_in;
    elseif (mod(i,4) == 1)
        P(i) = P(i-1) * exp(-t(2) / (R * C));
    end
end

figure(1)
plot(t, P);
title("Fluidic Elastomer Actuator Pressure vs Time");
xlabel("Time (s)");
ylabel("Pressure (kPa)");

%% Problem 1c
h_c = 1.4;
h_b = 1.6;
L_channel = 1.2;
N_channel = 7;
L = 11.6;
E = 0.8 * 1000; % kPa

eps_A = (P / E) * (h_c / (h_b - h_c));
theta = 2 * N_channel * atan(L_channel * eps_A / h_c);
tip_displacement = L ./ theta .* (1 - cos(theta));

figure(2)
plot(t, tip_displacement);
title("Fluidic Elastomer Actuator Tip Displacement vs Time");
xlabel("Time (s)");
ylabel("Tip Displacement (cm)");