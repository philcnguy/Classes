clear all; clc; clf

%% Problem 1b

t1 = linspace(0, 20, 81);

P_in = 20; % kPa
R = 1.4e6; % 1 / (m * s)
C = 2.5 / (1.25 * 1000 * 1000); % m * s^2

P1 = zeros(1,81);

P1(1) = 0;
for i = 2:81
    if (mod(i,4) == 2)
        P1(i:i+2) = (P1(i-1) - P_in) * exp(-t1(2:4) / (R * C)) + P_in;
    elseif (mod(i,4) == 1)
        P1(i) = P1(i-1) * exp(-t1(2) / (R * C));
    end
end

figure(1)
plot(t1, P1);
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

eps_A_1 = (P1 / E) * (h_c / (h_b - h_c));
theta_1 = 2 * N_channel * atan(L_channel * eps_A_1 / h_c);
tip_displacement_1 = L ./ theta_1 .* (1 - cos(theta_1));

figure(2)
plot(t1, tip_displacement_1);
title("Fluidic Elastomer Actuator Tip Displacement vs Time");
xlabel("Time (s)");
ylabel("Tip Displacement (cm)");

%% Problem 1d

t2 = linspace(0, 50, 401);

P2 = zeros(1,401);

P2(1) = 0;
for i = 2:401
    if (mod(i,8) == 2)
        P2(i) = (P2(i-1) - P_in) * exp(-t2(2) / (R * C)) + P_in;
    else
        P2(i) = P2(i-1) * exp(-t2(2) / (R * C));
    end
end

figure(3)
plot(t2, P2);
title("Fluidic Elastomer Actuator Pressure vs Time");
xlabel("Time (s)");
ylabel("Pressure (kPa)");

eps_A_2 = (P2 / E) * (h_c / (h_b - h_c));
theta_2 = 2 * N_channel * atan(L_channel * eps_A_2 / h_c);
tip_displacement_2 = L ./ theta_2 .* (1 - cos(theta_2));

figure(4)
plot(t2, tip_displacement_2);
title("Fluidic Elastomer Actuator Tip Displacement vs Time");
xlabel("Time (s)");
ylabel("Tip Displacement (cm)");
