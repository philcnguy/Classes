clear all; clc;

delete 'file.csv';

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
