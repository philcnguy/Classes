addpath("mr")

clear;clc;
l_0 = 4; l_1 = 3; l_2 = 2; l_3 = 1; h = 0.1;

thetalist = [pi/2;3;pi];
M = [[-1,0,0,0]; [0,1,0,l_0+l_2]; [0,0,-1,l_1-l_3];[0,0,0,1]];

Slist = [[0;0;1;l_0;0;0],[0;0;0;0;1;0],[0;0;-1;-l_0-l_2;0;h]];
Blist = [[0;0;-1;l_2;0;0],[0;0;0;0;1;0],[0;0;1;0;0;-h]];
Ts = FKinSpace(M, Slist, thetalist);

Tb = FKinBody(M, Blist, thetalist);

isequal(round(Ts,4),round(Tb,4));