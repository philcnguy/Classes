clear all; clc; clf;

k = 0.125; % MPa
x0 = 220e-6; % m
eps0 = 8.854e-12;
epsr = 2.8;
L0 = 8e-3; % m
R0 = 3e-3; % m
n = 7;

A = 2 * pi * R0 * L0;

V0 = 2 * pi * R0 * L0 * n * x0;

L = linspace(8e-3, 9e-3, 100);

x = V0 ./ (2 * pi * R0 * L * n);


U = sqrt((k * (x0 - x) .* x .^ 2) / (pi * R0 * L0 * n * eps0 * epsr));

figure(1)
plot(U, L);
xlabel("Voltage (V)");
ylabel("Actuator Length (m)");

Vp = sqrt((8 * k * x0 ^ 3) / (27 * eps0 * epsr * A));