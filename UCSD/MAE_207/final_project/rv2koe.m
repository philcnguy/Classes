function [ koe ] = rv2koe( r, v, mu, angletype )
%{
FILENAME: rv2koe

DESCRIPTION: This function computes the classical (Keplerian) orbit
elements given the Cartesian position and velocity vectors, the
gravitational parameter of the attracting body, and the desired angletype

NOTES:  This function can handle eccentric and hyperbolic orbits

INPUTS:
    r           = Cartesian position vector [ km ]
    v           = Cartesian velocity vector [ km/s ]
    mu          = gravitational parameter of attracting body [ km^3/s^2 ]
    angletype   = string indicating desired angletype for inputs
                    'deg' = degrees, 'rad' = radians

OUTPUTS:
    koe         = vector which contains the classical orbit elements
                    [ a; e; i; Om; w; M ]

FUNCTIONS/SCRIPTS CALLED:
    none

CALLED BY:
    ...

MODIFICATIONS:
    1-Nov-2023    |    Aaron J. Rosengren - Original

REFERENCES:
    MAE 207 - Fall 2023
%}

%  Create empty vector for keplerian elements
koe = zeros(6, 1);

%  Conversions
r2d = 180/pi;

%  Coordinate frame unit vectors
I = [1 0 0]; J = [0 1 0]; K = [0 0 1];

rhat = r/norm(r);                       % position unit vector [km]
h    = cross(r,v);                      % angular momentum {h = r x v}
hhat = h/norm(h);                       % normalized angular momentum

nhat = cross(K,h)/norm(cross(K,h));     % normalized ascending node vector

%  Eccentricity
e      = (1/mu)*cross(v,h) - rhat;      % eccentricity vector
koe(2) = norm(e);

energy = (1/2)*dot(v,v) - mu/norm(r);   % energy, km^2/s^2
%  If energy < 0, the orbit is closed (periodic)

%  Semi-major axis (a) and parameter (p)
if koe(2) ~= 1
    koe(1) = -mu/(2*energy);            % {energy = -mu/(2*a)}
    p      = koe(1)*(1 - koe(2)^2);
else
    koe(1) = inf;
    p      = hmag^2/mu;
end

%  Inclination (i) of orbit
koe(3) = acos(dot(K,hhat));
%  If i < 90 deg, the elliptical orbit is a direct (prograde) orbit

%  Right ascension of the ascending node (Omega)
koe(4) = mod(atan2(dot(J,nhat),dot(I,nhat)), 2*pi);

%  Argument of periapsis (w)
koe(5) = mod(atan2(dot(hhat,cross(nhat,e)),dot(nhat,e)), 2*pi);

%  True anomaly (f) at epoch [rad]
f = mod(atan2(dot(hhat,cross(e,r)),dot(e,r)), 2*pi);

if koe(1) > 0    % ----- eccentric orbit ----- %
    
    %  Eccentric anomaly (E) at epoch [rad]
    E = 2*atan2(sqrt(1 - koe(2))*tan(f/2),sqrt(1 + koe(2)));

    %  Mean anomaly (M) at epoch [rad]
    koe(6) = mod((E - koe(2)*sin(E)), 2*pi);


else        % ----- hyperbolic orbit ----- %

    %  Hyperbolic anomaly (H) at epoch [rad]
    H = 2*atanh(sqrt(koe(2) - 1)*tan(f/2)/sqrt(koe(2) + 1));

    %  Hyperbolic mean anomaly (N) at epoch [rad]
    koe(6) = mod((koe(2)*sinh(H) - H), 2*pi);    
    
end

% koe(6) = f;

if(strcmp(angletype, 'deg'))
    koe(3:end) = koe(3:end)*r2d;
end

end % ---- end function
