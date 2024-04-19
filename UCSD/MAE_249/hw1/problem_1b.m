clear all; clc; clf

t = linspace(0, 20, 81);

P_in = 20;
R = 1.4e6;
C = 2.5 / (1.25 * 1000 * 1000);

P = length(zeros(1,81));

P(1) = 0;
for i = 2:81
    if (mod(i,4) == 2)
        P(i:i+2) = (P(i-1) - P_in) * exp(-t(2:4) / (R * C)) + P_in;
    elseif (mod(i,4) == 1)
        P(i) = P(i-1) * exp(-t(2) / (R * C));
    end
end

plot(t, P);
xlabel("Time (s)");
ylabel("Pressure (kPa)");