function [line] = mat2line(T_matrix, gripper_state)
% MAT2LINE Formats 4x4 transformation matrix and gripper state as a single 1x13 matrix
% INPUTS:   T_matrix - The transformation matrix
%           gripper_state - The gripper state
% OUTPUTS:  line - A single 1x13 matrix representing the transformation matrix and gripper state in the order r11, r12, r13, r21, r22, r23, r31, r32, r33, px, py, pz, gripper state

line = [];

for i = 1:3
    for j = 1:3
        line(end+1) = T_matrix(i,j);
    end
end

for k = 1:3
    line(end+1) = T_matrix(k,4);
end

line(end+1) = gripper_state;

end

