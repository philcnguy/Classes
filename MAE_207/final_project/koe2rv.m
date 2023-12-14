function [ r, v ] = koe2rv( koe, mu, TOF, angletype )
%{
FILENAME:  koe2rv

DESCRIPTION: This function computes the cartesian position and velocity
vectors given the classical orbit elements, gravitational
parameter of the attracting body, time of flight, and angletype
used for the inputs.

NOTES:  This function can handle eccentric and hyperbolic orbits

INPUTS:
    koe         = vector which contains the classical orbit elements
                    [ a; ec; in; Om; w; M ]
                        a  - semimajor axis [ km ]
                        ec - eccentricity [ ]
                        in - inclination [ rad ]
                        w  - argument of periapsis [ rad ]
                        Om - longitude of the ascending node [ rad ]
                        M0 - mean or hyperbolic anomaly at epoch [ rad ]
    mu          = gravitational parameter of attracting body [ km^3/s^2 ]
    TOF         = time which has elapsed since the epoch time t0 [ s ]
    angletype   = string indicating desired angletype for inputs
                    'deg' = degrees, 'rad' = radians

OUTPUTS:
    r           = Cartesian position vector [ km ]
    v           = Cartesian velocity vector [ km/s ]

FUNCTIONS/SCRIPTS CALLED:
    none

CALLED BY:
    ...

MODIFICATIONS:
    1-Nov-2023    |    Aaron J. Rosengren - Original

REFERENCES:
    MAE 207 - Fall 2023
%}

%  Conversions
d2r = pi/180;

%  Classical orbit elements
a  = koe(1);    
ec = koe(2);   
in = koe(3);   
Om = koe(4);   
w  = koe(5);  
M0 = koe(6);  
f = koe(6);

if(strcmp(angletype, 'deg'))
    in = in*d2r;
    Om = Om*d2r;
    w  = w*d2r;
    M0 = M0*d2r;
    f = f*d2r;
end    

%  Mod out by pi or 2pi
in = mod(in, pi);
Om = mod(Om, 2*pi);
w  = mod(w, 2*pi);
M0 = mod(M0, 2*pi);   

%  Orbital mean motion [ rad/s ]
nm = sqrt(mu/abs(a)^3);

%  Mean anomaly [ rad ]
M = M0 + nm*TOF;

if a > 0    % ----- eccentric orbit ----- %
    
    %  Compute eccentric anomaly
    %  A priori estimate
    j = 1;
    if -pi < M < 0 || M > pi
        E(j) = M - ec;
    else
        E(j) = M + ec;
    end

    %  Newton iteration to find eccentric anomaly
    %  Algorithm [goal: find E so f = 0]
    f_E(j) = E(j) - ec*sin(E(j)) - M;
    while abs(f_E(j)) > 1e-11
        E(j + 1) = E(j) - f_E(j)/(1 - ec*cos(E(j)));
        j = j + 1;
        f_E(j) = E(j) - ec*sin(E(j)) - M;
    end

    %  Converged eccentric anomaly [ rad ]
    E = E(j);

    %  True anomaly [ rad ]
    f = mod(2*atan(sqrt((1 + ec)/(1 - ec))*tan(E/2)), 2*pi);

else        % ----- hyperbolic orbit ----- %

    %  Compute hyperbolic anomaly
    %  A priori estimate
    j = 1;
    H(j) = M;

    %  Newton iteration to find hyperbolic anomaly
    %  Algorithm [goal: find H so f = 0]
    f_H(j) = ec*sinh(H(j)) - H(j) - M;
    while abs(f_H(j)) > 1e-11
        H(j + 1) = H(j) - f_H(j)/(ec*cosh(H(j)) - 1);
        j = j + 1;
        f_H(j) = ec*sinh(H(j)) - H(j) - M;
    end

    %  Converged hyperbolic anomaly [ rad ]
    H = H(j);

    %  True anomaly [ rad ]
    f = mod(2*atan(sqrt((ec + 1)/(ec - 1))*tanh(H/2)), 2*pi);
end

%  Argument of latitude [ rad ]
th = w + f;

%  Magnitude of position vector [ km ]
r = a*(1 - ec^2)/(1 + ec*cos(f));                   % trajectory equation

%  Magnitude of velocity vector [ km/s ]
v = sqrt(mu*(2/r - 1/a));                           % vis-viva equation

%  Ascending node vector
nhat = [ cos(Om) ; sin(Om) ; 0 ];  
rT   = [ -cos(in)*sin(Om) ; cos(in)*cos(Om) ; sin(in) ];

gamma = atan2(ec*sin(f), 1 + ec*cos(f));            % [ rad ]

%  Normalized position and velocity vectors
rhat = cos(th)*nhat + sin(th)*rT;                   % [ km ]
vhat = sin(gamma - th)*nhat + cos(gamma - th)*rT;   % [ km/s ]

%  Position and velocity vectors
r = r*rhat;                                         % [ km ]
v = v*vhat;                                         % [ km/s ]  

end % ----- End Function