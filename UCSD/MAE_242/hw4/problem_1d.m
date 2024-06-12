A = [1 0.4 0 0;
    -0.6 1 0.4 0;
     0 0.4 1 -0.6;
     0 0 0.4 1];

B = [1; 0; 0; 0];

C = [0 0 0 1];

Q = C' * C;
R = 1;

maxT = 15;
spectralRadii = zeros(maxT, 1);

for T = 1:maxT
    P = cell(T + 1, 1);
    K = cell(T, 1);
   
    P{T+1} = Q;
    
    for i = T:-1:1
        P_next = P{i+1};
        K{i} = -(R + B' * P_next * B) \ (B' * P_next * A);
        P{i} = Q + A' * P_next * (A + B * K{i});
    end
    
    K_T = K{1};
    
    A_cl = A + B * K_T;
    eigenvalues = eig(A_cl);
    spectralRadii(T) = max(abs(eigenvalues));
end

figure;
plot(1:maxT, spectralRadii, '-o');
xlabel('Horizon T');
ylabel('Spectral Radius of A + BK_T');
title('Spectral Radius of Closed-Loop System versus Horizon T');
grid on;