function [Dz] = PCN_C2D_matched(Ds, h, omega_bar, causality)
% function [Dz] = PCN_C2D_matched(Ds, h, omega_bar, causality)
% Perform a matched z-transform to convert Ds(s) to Dz(z).
% INPUTS:   Ds  controller in continuous time
%           h   timestep
%           omega_bar   frequency of interest, default value of 1
%           causality   Dz(z) either semi-causal or strictly-causal,
%           default value of strictly-causal
% OUTPUTS:  Dz controller converted to discrete time
    if nargin < 3
        omega_bar = 1;
    end

    if nargin < 4
        causality = "strictly";
    end

    Dz = 1;
end