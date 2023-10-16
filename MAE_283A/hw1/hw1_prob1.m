load('noisy_sine_data.mat');

N = length(t);
deltaT = t(2) - t(1);
deltaOmega = (2 * pi) / (N * deltaT);

y = fft(u);
m = abs(y);
y(m<1e-6) = 0;
p = unwrap(angle(y));

f = (0:length(y)-1)*100/length(y);        % Frequency vector

subplot(2,1,1)
plot(f,m)
title('Magnitude')

subplot(2,1,2)
plot(f,p*180/pi)
title('Phase')