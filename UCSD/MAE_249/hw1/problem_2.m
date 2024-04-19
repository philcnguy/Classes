clear all; clc; clf;

%% Problem 2a

b1 = 15;
n = 3;
l = 10;

theta_1 = linspace(0, pi / 2, 50);
V_1 = b1^3 / (4 * pi * n^2) * sin(theta_1).^2 .* cos(theta_1);

figure(1)
plot(theta_1,V_1)
title("Pneumatic Artificial Muscle Volume vs. Angle")
xlabel("Angle (rad)");
ylabel("Volume (cm^3)");

%% Problem 2b

b2 = 25;

theta_2 = linspace(0, pi / 2, 50);
V_2 = b2^3 / (4 * pi * n^2) * sin(theta_2).^2 .* cos(theta_2);

figure(2)
plot(theta_2,V_2)
title("Pneumatic Artificial Muscle Volume vs. Angle")
xlabel("Angle (rad)");
ylabel("Volume (cm^3)");