clear all; clc;

%% Tests TrajectoryGenerator

delete 'trajectory.csv';

Tse_i = [1 0 0 0;
        0 1 0 0;
        0 0 1 .3;
        0 0 0 1];

Tsc_i = [1 0 0 1;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];

Tsc_f = [0 1 0 0;
        -1 0 0 -1;
        0 0 1 0;
        0 0 0 1];

Tce_grasp = [-1 0 0 0;
            0 1 0 0;
            0 0 -1 0;
            0 0 0 1];

Tce_standoff =  [-1 0 0 0;
                0 1 0 0;
                0 0 -1 .15;
                0 0 0 1];

k = 1;

[a,b] = TrajectoryGenerator(Tse_i, Tsc_i, Tsc_f, Tce_grasp, Tce_standoff, k);

%% Tests NextState

delete 'states.csv';

N = 100;
state = [0 0 0 0 0 0 0 0 0 0 0 0];
velocities = [1 1 1 1 1 1 1 1 1];
timestep = 0.01;
max_velocity = 0; % needs to be changed

for i = 1:N
    state = NextState(state, velocities, timestep, max_velocity);
    writematrix([state 0], 'states.csv', 'WriteMode','append');
end