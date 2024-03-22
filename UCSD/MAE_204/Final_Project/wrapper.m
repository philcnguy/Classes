clear all; clc;

delete 'trajectory.csv';

addpath("C:\Users\phill\OneDrive\Documents\GitHub\Classes\UCSD\MAE_204\mr")

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

Tce_grasp = [-1 0 0 0;
    0 1 0 0;
    0 0 -1 .005;
    0 0 0 1];

Tce_standoff =  [-1 0 0 0;
    0 1 0 0;
    0 0 -1 .15;
    0 0 0 1];

k = 1;

[ref_configs, trajectory] = TrajectoryGenerator(Tse_i_ref, Tsc_i, Tsc_goal, Tce_grasp, Tce_standoff, k);

%%

delete 'states.csv';

%Kp = zeros(6,6); Ki = zeros(6,6);
Kp = eye(6); Ki = eye(6);
timestep = 0.01;
max_velocity = 0;

% Tsb_i = [cos(0) -sin(0) 0 0;
%     sin(0) cos(0) 0 0;
%     0 0 1 0.0963;
%     0 0 0 1];

Tsb_i = [cos(30*pi/180) -sin(30*pi/180) 0 0;
    sin(30*pi/180) cos(30*pi/180) 0 0;
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

Tse_i_act = Tsb_i * Tb0 * M0e; % redundant but im keeping it anyways for my sanity
act_configs = zeros(length(ref_configs), 13);
%act_configs(1,1:13) = [0,0,0,0,0,0,0,0,0,0,0,0,0];
act_configs(1,1:13) = [0,0.1,0.1,0,0,0,30*pi/180,0,0,0,0,0,0];

Blist = [[0;0;1;0;0.033;0], ...
    [0;-1;0;-0.5076;0;0], ...
    [0;-1;0;-0.3526;0;0], ...
    [0;-1;0;-0.2176;0;0], ...
    [0;0;1;0;0;0]];

err = zeros(length(ref_configs) - 1,6);

for i = 1:length(ref_configs) - 1
    % Calculate new Tse = Tsb(q) * Tb0 * T0e

    T0e = FKinBody(M0e, Blist, act_configs(i,4:8).');

    Tsb = [cos(act_configs(i,1)) -sin(act_configs(i,1)) 0 act_configs(i,2);
        sin(act_configs(i,1)) cos(act_configs(i,1)) 0 act_configs(i,3);
        0 0 1 0.0963;
        0 0 0 1];

    Tse = Tsb * Tb0 * T0e;
    [V, speeds, Xerr] = FeedbackControl(Tse, ref_configs{i}, ref_configs{i + 1}, Kp, Ki, timestep, act_configs(i,1:13));
    err(i,1:6) = Xerr.';
    act_configs(i + 1,1:13) = [NextState(act_configs(i,1:12), speeds.', timestep, max_velocity), ref_configs{i, 2}];
end

writematrix(act_configs, 'states.csv');

plot(linspace(1,15,length(err)), err);
legend('omega_x', 'omega_y', 'omega_z', 'v_x', 'v_y', 'v_z');
ylabel("error");
xlabel("time, s");
disp("All done!");