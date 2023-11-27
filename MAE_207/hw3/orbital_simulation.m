function orbital_simulation()
    % Parameters
    mu = 1;
    tspan = [0, 10]; % Time span for integration
    options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8); % ODE solver options
    
    % Initial conditions
    r0 = [1; 0; 0];
    v0 = [0; 1; 0];
    
    % Loop through different values of a
    a_values = [0.001, 0.01, 0.1, 1];
    
    for a = a_values
        ad = [a; 0; 0]; % Constant acceleration vector
        
        % Numerical integration using ode45
        [t, y] = ode45(@(t, y) ode_func(t, y, mu, ad), tspan, [r0; v0], options);
        
        % Extract position and velocity vectors
        r = y(:, 1:3);
        v = y(:, 4:6);
        
        % Compute orbital elements
        orbital_elements = compute_orbital_elements(r, v, mu);
        
        % Plot trajectories
        figure;
        plot3(r(:, 1), r(:, 2), r(:, 3));
        title(['Trajectory for a = ', num2str(a)]);
        xlabel('X-axis');
        ylabel('Y-axis');
        zlabel('Z-axis');
        
        % Plot orbital elements
        figure;
        plot(t, orbital_elements(:, 1:5));
        legend('Semi-Major Axis (a)', 'Eccentricity (e)', 'Inclination (i)', 'Longitude of Ascending Node (\Omega)', 'Argument of Periapsis (\omega)');
        title(['Orbital Elements for a = ', num2str(a)]);
        xlabel('Time');
        ylabel('Value');
    end
end

function dydt = ode_func(t, y, mu, ad)
    r = y(1:3);
    v = y(4:6);
    
    % Equations of motion
    dydt = [v; (-mu/norm(r)^3)*r + ad];
end

function orbital_elements = compute_orbital_elements(r, v, mu)
    h = cross(r, v); % Specific angular momentum vector
    n = cross([0; 0; 1], h); % Node vector
    
    % Orbital elements
    a = 1 / (2/norm(r) - norm(v)^2/mu);
    e = norm(cross(v, h)/mu - r/norm(r));
    i = acos(h(3)/norm(h));
    Omega = atan2(n(2), n(1));
    omega = atan2((dot(n, cross(v, h))/norm(n)), (dot(v, n)/norm(n)));
    
    % Mean anomaly
    E = atan2(norm(cross(h, r))/(norm(h)*norm(r)), dot(r, v)/(norm(r)*norm(v)));
    M = mod(E - e*sin(E), 2*pi);
    
    % Collect orbital elements into a matrix
    orbital_elements = [a*ones(size(r, 1), 1), e*ones(size(r, 1), 1),...
                        rad2deg(i)*ones(size(r, 1), 1), rad2deg(Omega)*ones(size(r, 1), 1),...
                        rad2deg(omega)*ones(size(r, 1), 1), rad2deg(M)*ones(size(r, 1), 1)];
end