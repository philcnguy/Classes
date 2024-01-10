function [output] = hw2_prob1(flag, input, mu, time)

if (strcmp(flag, 'koe'))
    a = input(1);
    e = input(2);
    i = input(3);
    Om = input(4);
    w = input(5);
    M0 = input(6);

    i = i*pi/180;
    Om = Om*pi/180;
    w  = w*pi/180;
    M0 = M0*pi/180;

    i = mod(i, pi);
    Om = mod(Om, 2*pi);
    w  = mod(w, 2*pi);
    M0 = mod(M0, 2*pi);   

    nm = sqrt(mu/abs(a)^3);

    M = M0 + nm*time;

    if a > 0

        j = 1;
        if -pi < M < 0 || M > pi
            E(j) = M - e;
        else
            E(j) = M + e;
        end

        f_E(j) = E(j) - e*sin(E(j)) - M;
        while abs(f_E(j)) > 1e-11
            E(j + 1) = E(j) - f_E(j)/(1 - e*cos(E(j)));
            j = j + 1;
            f_E(j) = E(j) - e*sin(E(j)) - M;
        end

        E = E(j);
        f = mod(2*atan(sqrt((1 + e)/(1 - e))*tan(E/2)), 2*pi);

    else
        j =1;
        H(j) = M;

        f_H(j) = e*sinh(H(j)) - H(j) - M;
        while abs(f_H(j)) > 1e-11
            H(j + 1) = H(j) - f_H(j)/(e*cosh(H(j)) - 1);
            j = j + 1;
            f_H(j) = e*sinh(H(j)) - H(j) - M;
        end

        H = H(j);

        f = mod(2*atan(sqrt((e + 1)/(e - 1))*tanh(H/2)), 2*pi);
    end

    th = w + f;
    r = a*(1 - e^2)/(1 + e*cos(f)); 
    v = sqrt(mu*(2/r - 1/a));

    nhat = [ cos(Om) ; sin(Om) ; 0 ];  
    rT   = [ -cos(i)*sin(Om) ; cos(i)*cos(Om) ; sin(i) ];

    gamma = atan2(e*sin(f), 1 + e*cos(f));

    rhat = cos(th)*nhat + sin(th)*rT;
    vhat = sin(gamma - th)*nhat + cos(gamma - th)*rT;

    %r = r*rhat;
    %v = v*vhat;
    output = [r*rhat; v*vhat];

elseif (strcmp(flag, 'rv'))
    output = zeros(6, 1);
    r2d = 180/pi;
    I = [1 0 0]; J = [0 1 0]; K = [0 0 1];
    r = input(1:3);
    v = input(4:6);

    rhat = r/norm(r);
    h    = cross(r,v);
    hhat = h/norm(h);
    
    nhat = cross(K,h)/norm(cross(K,h));

    e      = (1/mu)*cross(v,h) - rhat;
    output(2) = norm(e);
    
    energy = (1/2)*dot(v,v) - mu/norm(r);
    
    if output(2) ~= 1
        output(1) = -mu/(2*energy);
    else
        output(1) = inf;
    end
    
    output(3) = acos(dot(K,hhat));
    
    output(4) = mod(atan2(dot(J,nhat),dot(I,nhat)), 2*pi);
    
    output(5) = mod(atan2(dot(hhat,cross(nhat,e)),dot(nhat,e)), 2*pi);

    f = mod(atan2(dot(hhat,cross(e,r)),dot(e,r)), 2*pi);
    
    if output(1) > 0

        E = 2*atan2(sqrt(1 - output(2))*tan(f/2),sqrt(1 + output(2)));
    
        output(6) = mod((E - output(2)*sin(E)), 2*pi);
    
    
    else 
        H = 2*atanh(sqrt(output(2) - 1)*tan(f/2)/sqrt(output(2) + 1));

        output(6) = mod((output(2)*sinh(H) - H), 2*pi);    
        
    end

    output(3:end) = output(3:end)*r2d;

end

end