function [next_state] = NextState(state, velocities, timestep, max_velocity)
% NEXTSTATE Produces configuration of robot one timestep later
% INPUTS:   state - The current state of the robot (12 variables: 3 for chassis, 5 for arm, 4 for wheel angles)
%           velocities - The joint and wheel velocities (9 variables: 5 for arm θ˙, 4 for wheels u)
%           timestep - The timestep size ∆t (1 parameter)
%           max_velocity - The maximum joint and wheel velocity magnitude (1 parameter)
% OUTPUTS:  next_state - The next state (configuration) of the robot (12 variables)

addpath("C:\Users\phill\OneDrive\Documents\GitHub\Classes\UCSD\MAE_204\mr")



next_state(4) = state(4) + velocities(5) * timestep;
next_state(5) = state(5) + velocities(6) * timestep;
next_state(6) = state(6) + velocities(7) * timestep;
next_state(7) = state(7) + velocities(8) * timestep;
next_state(8) = state(8) + velocities(9) * timestep;

next_state(9) = state(9) + velocities(1) * timestep;
next_state(10) = state(10) + velocities(2) * timestep;
next_state(11) = state(11) + velocities(3) * timestep;
next_state(12) = state(12) + velocities(4) * timestep;

r = 0.0475;
l = 0.47 / 2;
w = 0.3 / 2;

theta_dot = velocities(1:4).' * timestep;
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