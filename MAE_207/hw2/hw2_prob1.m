function [output] = hw2_prob1(flag, input, mu, time)

if (strcmp(flag, 'koe'))
    a = input(1);
    e = input(2);
    i = input(3);
    Om = input(4);
    w = input(5);
    M0 = input(6);

    if(strcmp(angletype, 'deg'))
        i = i*d2r;
        Om = Om*d2r;
        w  = w*d2r;
        M0 = M0*d2r;
    end

    i = mod(i, pi);
    Om = mod(Om, 2*pi);
    w  = mod(w, 2*pi);
    M0 = mod(M0, 2*pi);   

    nm = sqrt(mu/abs(a)^3);

    M = M0 + nm*TOF;

    if a > 0

        j = 1;
        if -pi < M < 0 || M > pi
            E(j) = M - ec;
        else
            E(j) = M + ec;
        end

        f_E(j) = E(j) - ec*sin(E(j)) - M;
        while abs(f_E(j)) > 1e-11
            E(j + 1) = E(j) - f_E(j)/(1 - ec*cos(E(j)));
            j = j + 1;
            f_E(j) = E(j) - ec*sin(E(j)) - M;
        end

        E = E(j);
        f = mod(2*atan(sqrt((1 + ec)/(1 - ec))*tan(E/2)), 2*pi);

    else
        % continue here
    end

elseif (strcmp(flag, 'rv'))
    disp(0);
end

end