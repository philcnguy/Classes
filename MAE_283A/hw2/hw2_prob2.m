% Define the parameters
a1 = 0.9;
N = 1000; % Number of data points
lambda = 1; % Variance of the white noise e(t)

% Generate white noise signal e(t)
e = randn(N, 1);

% Define the system transfer function G0(q)
b1 = 1; % Adjust as needed
G0 = tf(b1, [1, -a1], 1);

% Generate w(t) using the system transfer function
w = lsim(G0, e);

% Compute the periodogram estimate of the PSD
[Pxx, w] = periodogram(w, [], [], N);

% Create the log-log plot
loglog(w, Pxx);
title('Log Power Spectral Density Estimate');
xlabel('log \omega');
ylabel('log \hat{\Phi}_N(\omega)');

% Optionally, you can customize the plot further, add grid, etc.

% Display the plot
grid on;