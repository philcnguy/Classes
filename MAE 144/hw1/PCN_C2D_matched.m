function [Dz] = PCN_C2D_matched(Ds, h, omega_bar, causality)
% function [Dz] = PCN_C2D_matched(Ds, h, omega_bar, causality)
% Perform a matched z-transform to convert Ds(s) to Dz(z).
% INPUTS:   Ds  controller in continuous time
%           h   timestep
%           omega_bar   frequency of interest, default value of 1
%           causality   Dz(z) either semi-causal or strictly-causal,
%           default value of strictly-causal
% OUTPUTS:  Dz controller converted to discrete time

    if nargin < 2
        h = 0.01;
    end

    if nargin < 3
        omega_bar = 1;
    end

    if nargin < 4
        causality = "strictly";
    end

    % Map zeros & poles
    s_zeros = Ds.z;
    s_poles = Ds.p;

    z_zeros = exp(s_zeros * h);
    z_poles = exp(s_poles * h);

    z_num = RR_poly(z_zeros, 1);
    z_den = RR_poly(z_poles, 1);

    Dz = RR_tf(z_num, z_den);

    if Dz.num.n < Dz.den.n
        for i = Dz.num.n:Dz.den.n - 1
            z_zeros(end + 1) = -1;
        end
        z_num = RR_poly(z_zeros, 1);
    end

    Dz = RR_tf(z_num, z_den);

    if causality == "strictly"
        if z_zeros(end) == -1
            z_zeros(end) = [];
            z_num = RR_poly(z_zeros, 1);
        end
    end

    Dz = RR_tf(z_num, z_den);

end