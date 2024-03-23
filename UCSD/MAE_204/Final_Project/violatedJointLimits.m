function [bool, violations] = violatedJointLimits(config)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    %joints 2,3,4 should never be over 120 degrees or under -120 degrees
    violations = zeros(1,8);
    bool = false;

    if config(2) > .7 || config(2) < -.7
        violations(2) = 1;
        bool = true;
    end

    if config(3) > .7 || config(3) < -.7
        violations(3) = 1;
        bool = true;
    end

    if config(5) > 0*pi/180 || config(5) < -60*pi/180
        violations(5) = 1;
        bool = true;
    end

    if config(6) > 120*pi/180 || config(6) < -120*pi/180
        violations(6) = 1;
        bool = true;
    end

    if config(7) > 120*pi/180 || config(7) < -120*pi/180
        violations(7) = 1;
        bool = true;
    end
end