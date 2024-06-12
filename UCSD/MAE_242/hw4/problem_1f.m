% Define the system matrices
A = [1 0.4 0 0;
    -0.6 1 0.4 0;
     0 0.4 1 -0.6;
     0 0 0.4 1];

B = [1; 0; 0; 0];

C = [0 0 0 1];

Q = C' * C;
R = 1;

% Define the range of rho
rho_values = 1:-0.1:0.1;
num_rho = length(rho_values);

% Initialize array to store Ts for each rho
Ts_rho = zeros(num_rho, 1);

% Define maximum horizon to check
maxT = 15;

for rho_idx = 1:num_rho
    rho = rho_values(rho_idx);
    Q_rho = rho * Q;
    
    spectralRadii = zeros(maxT, 1);
    
    for T = 1:maxT
        % Initialize P_T and K_T
        P = cell(T + 1, 1); % Note: P has T + 1 elements because it goes from 0 to T
        K = cell(T, 1); % K has T elements because it goes from 1 to T

        % Set the final value of P to Q_rho
        P{T+1} = Q_rho;

        % Perform the recursion to compute P_i and K_i
        for i = T:-1:1
            P_next = P{i+1};
            K{i} = -(R + B' * P_next * B) \ (B' * P_next * A);
            P{i} = Q_rho + A' * P_next * (A + B * K{i});
        end

        % Get the gain for the current horizon T
        K_T = K{1};

        % Compute the spectral radius of (A + BK_T)
        A_cl = A + B * K_T;
        eigenvalues = eig(A_cl);
        spectralRadii(T) = max(abs(eigenvalues));

        % Check if the spectral radius is less than 1
        if spectralRadii(T) < 1
            Ts_rho(rho_idx) = T;
            break;
        end
    end
end

% Plot Ts(rho) versus rho
figure;
plot(rho_values, Ts_rho, '-o');
xlabel('\rho');
ylabel('T_s(\rho)');
title('Smallest Stable Horizon T_s(\rho) versus \rho');
grid on;