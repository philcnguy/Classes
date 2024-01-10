function [Dz] = PCN_C2D_matched(Ds, h, omega_bar, causality)
% function [Dz] = PCN_C2D_matched(Ds, h, omega_bar, causality)
% Perform a matched z-transform to convert Ds(s) to Dz(z).
% INPUTS:   Ds  controller in continuous time
%           h   timestep
%           omega_bar   frequency of interest, default value of 0
%           causality   Dz(z) either semi-causal or strictly-causal,
%           default value of strictly-causal
% OUTPUTS:  Dz controller converted to discrete time
    % Default values
    if nargin < 2
        h = 0.01;
    end

    if nargin < 3
        omega_bar = 0;
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

    % Add zeros at infinity
    if Dz.num.n < Dz.den.n
        for i = Dz.num.n:Dz.den.n - 1
            z_zeros(end + 1) = -1;
        end
        z_num = RR_poly(z_zeros, 1);
    end

    Dz = RR_tf(z_num, z_den);

    % Remove zeros if strictly-causal
    if causality == "strictly"
        if z_zeros(end) == -1
            z_zeros(end) = [];
            z_num = RR_poly(z_zeros, 1);
            Dz = RR_tf(z_num, z_den);
        end
    end
    
    if omega_bar == 0
        for i = length(Dz.p):-1:1
            if Dz.p(i) < 1e-4
                error("ERROR" + newline + "Use nonzero value for omega_bar.");
            end
        end
    end

    % a/b = k*c/d, where k is DCgain
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    for i = Ds.num.n:-1:0
        a = a + Ds.num.poly(i + 1) * omega_bar ^ (Ds.num.n - i);
    end
    
    for i = Ds.den.n:-1:0
        b = b + Ds.den.poly(i + 1) * omega_bar ^ (Ds.den.n - i);
    end

    for i = Dz.num.n:-1:0
        c = c + Dz.num.poly(i + 1) * exp(omega_bar) ^ (i - Dz.num.n);
    end
    
    for i = Dz.den.n:-1:0
        d = d + Dz.den.poly(i + 1) * exp(omega_bar) ^ (i - Dz.den.n);
    end

    DCgain = (a * d) / (b * c);

    Dz = Dz * DCgain;
end