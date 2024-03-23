function [] = wrapper(Tsc_i, Tsc_goal, Kp, Ki, filename)
% WRAPPER   Wrapper code to be used for different cases
% INPUTS:   Tsc_i - The initial configuration of the cube
%           Tsc_goal - The goal configuration of the cube
%           Kp - The P gain matrix
%           Ki - The I gain patrix
%           filename - The .csv file name that would be uploaded to the simulation
% OUTPUTS:

delete 'trajectory.csv';

addpath("C:\Users\phill\OneDrive\Documents\GitHub\Classes\UCSD\MAE_204\mr")

Tse_i_ref = [0 0 1 0;
    0 1 0 0;
    -1 0 0 .5;
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

timestep = 0.01;
max_velocity = 0;

Tb0 = [1 0 0 0.1662;
    0 1 0 0;
    0 0 1 0.0026;
    0 0 0 1];

M0e = [1 0 0 0.033;
    0 1 0 0;
    0 0 1 0.6546;
    0 0 0 1];

act_configs = zeros(length(ref_configs), 13);
act_configs(1,1:13) = [0,0.1,0.1,0,0,0,-30*pi/180,0,0,0,0,0,0];

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
    [V, speeds, Xerr] = FeedbackControl(Tse, ref_configs{i}, ref_configs{i + 1}, Kp, Ki, timestep, act_configs(i,1:13), [0,0,0,0,0,0,0,0]);
    err(i,1:6) = Xerr.';
    next_config = NextState(act_configs(i,1:12), speeds.', timestep, max_velocity);

    act_configs(i + 1,1:13) = [next_config, ref_configs{i, 2}];
end

writematrix(act_configs, filename);

plot(linspace(1,15,length(err)), err);
legend('omega_x', 'omega_y', 'omega_z', 'v_x', 'v_y', 'v_z');
ylabel("error");
xlabel("time, s");
disp("All done!");

end