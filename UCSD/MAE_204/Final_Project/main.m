clear all; clc;

%% Best

Tsc_i_best = [1 0 0 1;
    0 1 0 0;
    0 0 1 0.025;
    0 0 0 1];

Tsc_goal_best = [0 1 0 0;
    -1 0 0 -1;
    0 0 1 0.025;
    0 0 0 1];

Kp_best = eye(6) * 0.5;
Ki_best = eye(6) * 0.5;

delete 'states_best.csv';

figure(1)
title('Best Case')
wrapper(Tsc_i_best, Tsc_goal_best, Kp_best, Ki_best, 'states_best.csv');

%% Overshoot

Tsc_i_overshoot = [1 0 0 1;
    0 1 0 0;
    0 0 1 0.025;
    0 0 0 1];

Tsc_goal_overshoot = [0 1 0 0;
    -1 0 0 -1;
    0 0 1 0.025;
    0 0 0 1];

Kp_overshoot = eye(6) * 2;
Ki_overshoot = eye(6) * 2;

delete 'states_overshoot.csv'

figure(2)
title('Overshoot Case')
wrapper(Tsc_i_overshoot, Tsc_goal_overshoot, Kp_overshoot, Ki_overshoot, 'states_overshoot.csv');

%% New Task

Tsc_i_new = [cos(45*pi/180) -sin(45*pi/180) 0 1;
    sin(45*pi/180) cos(45*pi/180) 0 1;
    0 0 1 0.025;
    0 0 0 1];

Tsc_goal_new = [cos(-45*pi/180) -sin(-45*pi/180) 0 2;
    sin(-45*pi/180) cos(-45*pi/180) 0 -2;
    0 0 1 0.025;
    0 0 0 1];

Kp_new = eye(6) * 0.5;
Ki_new = eye(6) * 0.5;

figure(3)
title('New Task Case')
wrapper(Tsc_i_new, Tsc_goal_new, Kp_new, Ki_new, 'states_new.csv');