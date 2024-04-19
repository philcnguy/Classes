clear all; clc; clf;

%% Problem 2a

b = 15;
n = 3;
l = 10;

theta = linspace(0, pi / 2, 50);
V = b^3 / (4 * pi * n^2) * sin(theta).^2 .* cos(theta);

figure(1)
plot(theta,V)
title("Pneumatic Artificial Muscle Volume vs. Angle")
xlabel("Angle (rad)");
ylabel("Volume (cm^3)");