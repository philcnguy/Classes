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
velocities = [10 10 10 10 1 1 1 1 1];
timestep = 0.01;
max_velocity = 0; % needs to be changed

for i = 1:N
    state = NextState(state, velocities, timestep, max_velocity);
    writematrix([state 0], 'states.csv', 'WriteMode','append');
end

%% Tests FeedbackControl

Xd = [0 0 1 0.5;
     0 1 0 0;
     -1 0 0 0.5;
     0 0 0 1];

Xd_next = [0 0 1 0.6;
          0 1 0 0;
          -1 0 0 0.3;
          0 0 0 1];

X = [0.17 0 0.985 0.387;
    0 1 0 0;
    -0.985 0 0.17 0.57;
    0 0 0 1];

Kp = zeros(6,6); Ki = zeros(6,6);
%Kp = eye(6); Ki = eye(6);

timestep = 0.01;

config = [0; 0; 0; 0; 0; 0.2; -1.6; 0];

[V, speeds] = FeedbackControl(X, Xd, Xd_next, Kp, Ki, timestep, config);

%% Testing

Tsb = [cos(0) -sin(0) 0 0;
    sin(0) cos(0) 0 0;
    0 0 1 0.0963;
    0 0 0 1];

Tb0 = [1 0 0 0.1662;
    0 1 0 0;
    0 0 1 0.0026;
    0 0 0 1];

M0e = [1 0 0 0.033;
    0 1 0 0;
    0 0 1 0.6546;
    0 0 0 1];

Tse = Tsb * Tb0 * M0e;

%% Testing

M0e = [1 0 0 0.033;
    0 1 0 0;
    0 0 1 0.6546;
    0 0 0 1];

Blist = [[0;0;1;0;0.033;0], ...
    [0;-1;0;-0.5076;0;0], ...
    [0;-1;0;-0.3526;0;0], ...
    [0;-1;0;-0.2176;0;0], ...
    [0;0;1;0;0;0]];

config = [0; 0; 0; 0; 0; 0.2; -1.6; 0];

T = FKinBody(M0e, Blist, config(4:8));