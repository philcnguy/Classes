function [V, speeds, Xerr] = FeedbackControl(X, Xd, Xd_next, Kp, Ki, timestep, config)
% FeedbackControl Calculates the task-space feedforward plus feedback control law
% INPUTS:   X - The current actual end-effector configuration (aka Tse)
%           Xd - The current reference end-effector configuration (aka Tse,d)
%           Xd_next - The reference end-effector configuration at the next timestep (aka Tse,d,next)
%           Kp - The P gain matrix
%           Ki - The I gain patrix
%           timestep - The timestep ∆t between reference trajectory configurations
% OUTPUTS:  V - The commanded end-effector twist expressed in the end-effector frame {e}
%           speeds - The commanded wheel speeds, u and the commanded arm joint speeds, θ˙

addpath("C:\Users\Phillip\Documents\GitHub\Classes\UCSD\MAE_204\mr")

% Calculate J_arm

Blist = [[0;0;1;0;0.033;0], ...
    [0;-1;0;-0.5076;0;0], ...
    [0;-1;0;-0.3526;0;0], ...
    [0;-1;0;-0.2176;0;0], ...
    [0;0;1;0;0;0]];

%config = [0; 0; 0; 0; 0; 0; 0; 0];%%% is this wrong??? yeah i think it is, need to get config from Tse

J_arm = JacobianBody(Blist, config(4:8));

% Calculate J_base

Tb0 = [1 0 0 0.1662;
    0 1 0 0;
    0 0 1 0.0026;
    0 0 0 1];

Tsb = [cos(config(1)) -sin(config(1)) 0 config(2);
    sin(config(1)) cos(config(1)) 0 config(3);
    0 0 1 0.0963;
    0 0 0 1];

T0e = inv(Tb0) * inv(Tsb) * X;

r = 0.0475;
l = 0.47 / 2;
w = 0.3 / 2;

F = r / 4 * [-1 / (l + w) 1 / (l + w) 1 / (l + w) -1 / (l + w);
            1 1 1 1;
            -1 1 -1 1];

F6 = [zeros(2,4); F; zeros(1,4)];

J_base = Adjoint(inv(T0e) * inv(Tb0)) * F6;

% Combine J_base and J_arm to get J_e

J_e = [J_base, J_arm];

% Compute e-e twist and speeds

Xerr = se3ToVec(MatrixLog6(X \ Xd));

Vd = se3ToVec((1 / timestep) * MatrixLog6(Xd \ Xd_next));

V = Adjoint(X \ Xd) * Vd + Kp * Xerr + Ki * Xerr * timestep; %NEED TO INCLUDE INTEGRAL FOR WHEN Ki IS NOT ZERO

speeds = pinv(J_e, 1e-3) * V;

end