%clear all; clc; clf;

% Define the parameters
body_length = 0.3; % m
fin_length = 0.06; % m

undamped_amplitude = 0.03 / fin_length; % m
alpha = 3;
k = 50;

density = 997; % kg / m^3

forward_speed = 0.1; % m / s
momentum_factor = 2.4;
angular_frequency = 10; % 1 / s
angular_amplitude = atan(undamped_amplitude * fin_length / fin_length); % rad
angular_velocity = angular_amplitude * angular_frequency; % rad / s
momentum_per_length = pi * density * angular_velocity * fin_length ^ 3 / 8; % kg / s

wavelength = 2 * pi / k; % m
local_twist = 2 * pi * angular_amplitude / wavelength; % rad / m
propagation_velocity = angular_velocity / local_twist; % m / s

inclination_angle = atan(undamped_amplitude * fin_length * k * cos(-2 * pi * alpha));

force = 0.5 * forward_speed * momentum_factor * momentum_per_length * (1 - forward_speed / propagation_velocity) * sin(inclination_angle);

% Define the ranges for x, y
x = linspace(0, fin_length, 10);
y = linspace(body_length / -2, body_length / 2, 60);

% Create a meshgrid for x and y
[X, Y] = meshgrid(x, y);

% Define time values
t_values = linspace(0, 0, 10);

%figure (1);
tiledlayout(1,2)
nexttile

for t = t_values
    % Calculate the z values for current t
    Z = undamped_amplitude .* sin(-2 * pi * alpha * t + k * Y) .* X;

    % Create a 3D plot
    surf(X, Y, Z);
    shading interp
    grid off

    % Set labels
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    %title(['Undamped Gymnotiform Motion at t = ', num2str(t)]);
    title('Undamped Gymnotiform Motion');

    % Add color bar for reference
    %colorbar;

    % Set view angle for better visualization
    view(45, 30);

    xlim([-0.05 0.1])
    ylim([body_length / -2 body_length / 2])
    zlim([body_length / -2 body_length / 2])
    
    % Pause to create an animation effect
    pause(0.1);
end