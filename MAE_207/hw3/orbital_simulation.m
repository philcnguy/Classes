function orbital_simulation_3()

    % Parameters
    mu = 1;
    r0 = [1; 0; 0];
    v0 = [0; 1; 0];
    
    % Values of 'a' to iterate through
    a_values = [0.001, 0.01, 0.1, 1];

    % Time span for integration
    tspan = [0, 10]; % Adjust as needed

    for a = a_values
        ad = [a; 0; 0];
        
        % Initial conditions
        y0 = [r0; v0];

        % Numerical integration using ode45
        [t, y] = ode45(@(t, y) odefunc(t, y, mu, ad), tspan, y0);

        % Plot the trajectory
        figure;
        plot3(y(:, 1), y(:, 2), y(:, 3));
        title(['Trajectory for a = ' num2str(a)]);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        grid on;

        % Compute and plot classical orbital elements
        elements = compute_orbital_elements(y, mu);
        plot_orbital_elements(t, elements, a);
    end
end

function dydt = odefunc(t, y, mu, ad)
    r = y(1:3);
    v = y(4:6);

    r_norm = norm(r);
    dydt = zeros(6, 1);

    % Equations of motion
    dydt(1:3) = v;
    dydt(4:6) = -mu / r_norm^3 * r + ad;
end

function elements = compute_orbital_elements(y, mu)
    r = y(:, 1:3);
    v = y(:, 4:6);

    h = cross(r, v);
    n = cross([zeros(size(h, 1), 2), ones(size(h, 1), 1)], h); % Corrected dimensions

    r_norm = vecnorm(r, 2, 2);
    v_norm = vecnorm(v, 2, 2);

    elements.a = 1 ./ (2 ./ r_norm - v_norm.^2 / mu);
    elements.e = sqrt(1 - (vecnorm(h, 2, 2).^2 / (mu * elements.a)));
    elements.i = acosd(h(:, 3) ./ vecnorm(h, 2, 2)); % Use vecnorm for correct dimensions
    elements.Omega = atan2d(n(:, 2), n(:, 1));
    elements.omega = atan2d(r(:, 3) ./ sind(elements.i), -r(:, 2) ./ sind(elements.i));
    elements.M = acosd((elements.a .* (1 - elements.e.^2) - r_norm) ./ (elements.e .* r_norm));
end

function plot_orbital_elements(t, elements, a)
    figure;
    subplot(3, 2, 1);
    plot(t, elements.a);
    title('Semimajor Axis');
    xlabel('Time');
    ylabel('a');

    subplot(3, 2, 2);
    plot(t, elements.e);
    title('Eccentricity');
    xlabel('Time');
    ylabel('e');

    subplot(3, 2, 3);
    plot(t, elements.i);
    title('Inclination');
    xlabel('Time');
    ylabel('i');

    subplot(3, 2, 4);
    plot(t, elements.Omega);
    title('Longitude of Ascending Node');
    xlabel('Time');
    ylabel('\Omega');

    subplot(3, 2, 5);
    plot(t, elements.omega);
    title('Argument of Periapsis');
    xlabel('Time');
    ylabel('\omega');

    subplot(3, 2, 6);
    plot(t, elements.M);
    title('Mean Anomaly');
    xlabel('Time');
    ylabel('M');

    sgtitle(['Orbital Elements for a = ' num2str(a)]);
end
