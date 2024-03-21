function [next_state] = NextState(state, velocities, timestep, max_velocity)
%NEXTSTATE Produces configuration of robot one timestep later

addpath("C:\Users\Phillip\Documents\GitHub\Classes\UCSD\MAE_204\mr")

next_state(4) = state(4) + velocities(1) * timestep;
next_state(5) = state(5) + velocities(2) * timestep;
next_state(6) = state(6) + velocities(3) * timestep;
next_state(7) = state(7) + velocities(4) * timestep;
next_state(8) = state(8) + velocities(5) * timestep;

next_state(9) = state(9) + velocities(6) * timestep;
next_state(10) = state(10) + velocities(7) * timestep;
next_state(11) = state(11) + velocities(8) * timestep;
next_state(12) = state(12) + velocities(9) * timestep;

r = 0.0475;
l = 0.47 / 2;
w = 0.3 / 2;

theta_dot = velocities(6:9).' * timestep;
F = r / 4 * [-1 / (l + w) 1 / (l + w) 1 / (l + w) -1 / (l + w);
            1 1 1 1;
            -1 1 -1 1];
twist = F * theta_dot;
omega_bz = twist(1);
v_bx = twist(2);
v_by = twist(3);

if twist(1) == 0
    dqb = [0; v_bx; v_by];
else
    dqb = [omega_bz;
        (v_bx * sin(omega_bz) + v_by * (cos(omega_bz) - 1)) / omega_bz;
        (v_by * sin(omega_bz) + v_bx * (cos(omega_bz) - 1)) / omega_bz];
end

dq = [1 0 0;
    0 cos(state(1)) -sin(state(1));
    0 sin(state(1)) cos(state(1))] * dqb;

next_state(1:3) = state(1:3) + dq.';

end