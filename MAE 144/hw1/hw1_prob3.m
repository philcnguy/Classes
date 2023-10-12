clear all; clc;

ys=[1 1]; xs=[1 10 0]; h=.01; Ds=RR_tf(ys,xs);
Dz = PCN_C2D_matched(Ds,.01,1);

Ds_MATLAB = zpk([-1], [0 -10], 1);
Dz_MATLAB = c2d(Ds_MATLAB, .01, 'matched');