omega = linspace(0, pi, 1000);

H = abs(1/5 * (1 + exp(-1j*omega) + exp(-2*1j*omega) + exp(-3*1j*omega) + exp(-4*1j*omega)));

plot(omega, H);
xlabel('Frequency (\omega)');
ylabel('|H(e^{j\omega})|');
title('Amplitude Frequency Response');
grid on;

zero_indices = find(H == 0);
zero_frequencies = omega(zero_indices);
disp('Frequencies where |H(e^(jω))| = 0:');
disp(zero_frequencies);