function [line] = mat2line(T_matrix, gripper_state)
%MAT2LINE Formats 4x4 transformation matrix and gripper state to 

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

