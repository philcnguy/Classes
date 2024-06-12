clear all; clc; clf;

% w = .6e-3;
% h = .5e-3;
% L = 50e-3;
% eps = linspace(0, 2, 100);
% rho = 29.4e-8;
% 
% 
% R = (rho * eps * L .* (8 - eps)) ./ (w * h * (2 - eps) .^ 2);
% 
% plot(eps/2, R);

strain = linspace(0,100,1000);

R = strain.^2 * 0.000034;

plot(strain, R);

xlabel("Strain (%)");
ylabel("Resistance Change");