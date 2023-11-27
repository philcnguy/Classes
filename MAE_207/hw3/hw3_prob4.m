clear all; clc;

mu = 1;
r = [1 0 0];
v = [0 1 0];
ad = [0.1 0 0];
step = 0.1;

figure(2)
hold on

for i = 0:step:100
    r_mag = sqrt(r(1)^2 + r(2)^2 + r(3)^2);

    v_new = (-mu / r_mag^3 * r + ad) * step + v;
    r_new = v * step + r;

    v = v_new;
    r = r_new;

%    disp(r);
%    disp(v);

    scatter(r(1), r(2));
end