clear all; clc;

delete 'trajectory.csv';

Tse_i_ref = [0 0 1 0;
    0 1 0 0;
    -1 0 0 .5;
    0 0 0 1];

Tsc_i = [1 0 0 1;
    0 1 0 0;
    0 0 1 0.025;
    0 0 0 1];

Tsc_goal = [0 1 0 0;
           -1 0 0 -1;
           0 0 1 0.025;
           0 0 0 1];

Tce_grasp = [ -sqrt(2)/2, 0, sqrt(2)/2, 0;
    0, 1, 0, 0;
    -sqrt(2)/2, 0, -sqrt(2)/2, 0;
    0, 0, 0, 1];

Tce_standoff = [ -sqrt(2)/2, 0, sqrt(2)/2, 0;
    0, 1, 0, 0;
    -sqrt(2)/2, 0, sqrt(2)/2, 0.15;
    0, 0, 0, 1];

Tb0 = [1 0 0 0.1662;
    0 1 0 0;
    0 0 1 0.0026;
    0 0 0 1];

Blist = [[0;0;1;0;0.033;0], ...
    [0;-1;0;-0.5076;0;0], ...
    [0;-1;0;-0.3526;0;0], ...
    [0;-1;0;-0.2176;0;0], ...
    [0;0;1;0;0;0]];

M0e = [1 0 0 0.033;
    0 1 0 0;
    0 0 1 0.6546;
    0 0 0 1];

k = 1;

[traj, trajectory] = TrajectoryGenerator(Tse_i_ref, Tsc_i, Tsc_goal, Tce_grasp, Tce_standoff, k);

%%

delete 'states.csv';

Kp = zeros(6,6); Ki = zeros(6,6);
%Kp = eye(6); Ki = eye(6);
timestep = 0.01;
max_velocity = 10;

act_configs = zeros(length(traj), 13);
act_configs(1,1:13) = [0,0,0,0,0,0,0,0,0,0,0,0,0];

for i = 1:length(traj) - 1
    Tsb = [cos(act_configs(i,1)) -sin(act_configs(i,1)) 0 act_configs(i,2);
        sin(act_configs(i,1)) cos(act_configs(i,1)) 0 act_configs(i,3);
        0 0 1 0.0963;
        0 0 0 1];

    T0e = FKinBody(M0e, Blist, act_configs(i,4:8));

    Tse = Tsb * Tb0 * T0e;

    [V, speeds] = FeedbackControl(Tse, traj{i}, traj{i + 1}, Kp, Ki, timestep, act_configs(i,1:13));
    u = speeds(1:4);
    theta_dot = speeds(5:9);
    act_configs(i + 1,1:13) = [NextState(act_configs(i,1:12), speeds, timestep, max_velocity), traj{i, 2}];
end

writematrix(act_configs, 'states.csv');

disp("All done!");