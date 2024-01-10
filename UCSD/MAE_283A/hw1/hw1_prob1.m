clear all; clc; clf

load('noisy_sine_data.mat');

figure(1)

N = length(t);
deltaT = t(2) - t(1);
T = N * deltaT;

y = fft(u);
m = abs(y);
y(m<1e-6) = 0;
p = unwrap(angle(y));

%f = (0:length(y)-1)*100/length(y);        % Frequency vector
f = 0:1/T:.5*(N-1)/T;

subplot(2,1,1)
plot(f,m(1:N/2))
title('Magnitude')

% subplot(2,1,2)
% plot(f,p*180/pi)
% title('Phase')