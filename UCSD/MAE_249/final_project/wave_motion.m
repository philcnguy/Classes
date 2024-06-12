clear all; clc; clf;

% Define the parameters
beta = 0.1;
C = 0.1;
alpha = 1;
k = 1.25;

% Define the ranges for x, y
x = linspace(0, 5, 20);
y = linspace(-15, 15, 60);

% Create a meshgrid for x and y
[X, Y] = meshgrid(x, y);

% Define time values
t_values = linspace(0, 1, 10);  % 10 time steps from 0 to 1

figure (1);

for t = t_values
    % Calculate the z values for current t
    Z = exp(-beta * Y) .* C .* sin(-2 * pi * alpha * t + k * Y) .* X;

    % Create a 3D plot
    surf(X, Y, Z);

    % Set labels
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title(['Plot of z(x, y, t) at t = ', num2str(t)]);

    % Add color bar for reference
    colorbar;

    % Set view angle for better visualization
    view(45, 30);

    xlim([0 5])
    ylim([-15 15])
    zlim([-10 10])
    
    % Pause to create an animation effect
    pause(0.5);
end