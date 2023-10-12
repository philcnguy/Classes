clear all; clc;

ys=[1 1]; xs=[1 10 0]; h=.01; Ds=RR_tf(ys,xs);
Dz = PCN_C2D_matched(Ds,.01,1);