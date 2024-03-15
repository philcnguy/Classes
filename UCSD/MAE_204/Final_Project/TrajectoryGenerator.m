function [configs, trajectory] = TrajectoryGenerator(Tse_i, Tsc_i, Tsc_f, Tce_grasp, Tce_standoff, k)
%TRAJECTORYGENERATOR Generates trajectories

addpath("C:\Users\Phillip\Documents\GitHub\Classes\UCSD\MAE_204\mr")

% Each entry of configs is {4x4 transformation matrix, gripper state}
% Each line of trajectory corresponds to one configuration Tse of the
% end-effector, expressed as 13 variables separated by commas:
% r11, r12, r13, r21, r22, r23, r31, r32, r33, px, py, pz, gripper_state

configs = {};

t1 = 5;
t2 = 2;
t3 = 1;
t4 = 2;
t5 = 5;
t6 = 2;
t7 = 1;
t8 = 2;

% Trajectory 1 (Tse_i -> Tse_standoff_i = Tsc_i * Tce_standoff)

traj_1 = CartesianTrajectory(Tse_i, Tsc_i * Tce_standoff, t1, t1 * k / 0.01, 5);

for i = 1:length(traj_1)
    configs = [configs; {traj_1{i}, 0}];
end

% Trajectory 2 (Tse_standoff_i = Tsc_i * Tce_standoff -> Tse_grasp_i = Tsc_i * Tce_grasp)

traj_2 = CartesianTrajectory(Tsc_i * Tce_standoff, Tsc_i * Tce_grasp, t2, t2 * k / 0.01, 5);

for i = 1:length(traj_2)
    configs = [configs; {traj_2{i}, 0}];
end

% Trajectory 3 (Tse_grasp_i = Tsc_i * Tce_grasp -> Tse_grasp_i = Tsc_i * Tce_grasp)

traj_3 = CartesianTrajectory(Tsc_i * Tce_grasp, Tsc_i * Tce_grasp, t3, t3 * k / 0.01, 5);

for i = 1:length(traj_3)
    configs = [configs; {traj_3{i}, 1}];
end

% Trajectory 4 (Tse_grasp_i = Tsc_i * Tce_grasp -> Tse_standoff_i = Tsc_i * Tce_standoff)

traj_4 = CartesianTrajectory(Tsc_i * Tce_grasp, Tsc_i * Tce_standoff, t4, t4 * k / 0.01, 5);

for i = 1:length(traj_4)
    configs = [configs; {traj_4{i}, 1}];
end

% Trajectory 5 (Tse_standoff_i = Tsc_i * Tce_standoff -> Tse_standoff_f = Tsc_f * Tce_standoff)

traj_5 = CartesianTrajectory(Tsc_i * Tce_standoff, Tsc_f * Tce_standoff, t5, t5 * k / 0.01, 5);

for i = 1:length(traj_5)
    configs = [configs; {traj_5{i}, 1}];
end

% Trajectory 6 (Tse_standoff_f = Tsc_f * Tce_standoff -> Tse_grasp_f = Tsc_f * Tce_grasp)

traj_6 = CartesianTrajectory(Tsc_f * Tce_standoff, Tsc_f * Tce_grasp, t6, t6 * k / 0.01, 5);

for i = 1:length(traj_6)
    configs = [configs; {traj_6{i}, 1}];
end

% Trajectory 7 (Tse_grasp_f = Tsc_f * Tce_grasp -> Tse_grasp_f = Tsc_f * Tce_grasp)

traj_7 = CartesianTrajectory(Tsc_f * Tce_grasp, Tsc_f * Tce_grasp, t7, t7 * k / 0.01, 5);

for i = 1:length(traj_7)
    configs = [configs; {traj_7{i}, 0}];
end

% Trajectory 8 (Tse_grasp_f = Tsc_f * Tce_grasp -> Tse_standoff_f = Tsc_f * Tce_standoff)

traj_8 = CartesianTrajectory(Tsc_f * Tce_grasp, Tsc_f * Tce_standoff, t8, t8 * k / 0.01, 5);

for i = 1:length(traj_8)
    configs = [configs; {traj_8{i}, 0}];
end

% Write trajectory matrices to file

for i = 1:length(configs)
    writematrix(mat2line(configs{i,1}, configs{i,2}), 'trajectory.csv', 'WriteMode','append')
end

trajectory = 'trajectory.csv';

disp("All done!");

end