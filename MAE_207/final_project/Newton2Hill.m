function [ rho , drho ] = Newton2Hill( rc , vc , rd , vd )
%{
FILENAME: Newton2Hill

DESCRIPTION: This function computes the relative position and velocity
vectors between the deputy and chief satellites as seen by the rotating
Hill coordinate frame (O), given the inertial position and velocity of the
chief and deputy coordinatized in the inertial reference frame N. 

NOTES: (1) Column vectors (3x1) are assumed for all inputs, outputs, and
local variables; (2) Hill frame coordinates are rectilinear (x,y,z).

INPUTS:
    rc      = chief inertial positon vector in N frame components
    vc      = chief inertial velocity vector in N frame components
    rd      = deputy inertial position vector in N frame components
    vd      = deputy inertial velocity vector in N frame components

OUTPUTS:
    rho     = relative position vector in O frame components
                [ x; y; z]
    drho    = relative velocity vector in O frame components 
                [ dx; dy; dz ]

FUNCTIONS/SCRIPTS CALLED:
    none

CALLED BY:
    proj_SFF_J2.m

MODIFICATIONS:
    6-Dec-2023    |    Aaron J. Rosengren - Original

REFERENCES:
    Schaub & Junkins, Analytical Mechanics of Space Systems, 2nd Ed., 2009
%}

%  Chief angular velocity 
hc      = cross( rc , vc );

%  Hill frame (O) basis vectors in inertial frame (N) components
Or      = rc / norm(rc);
Oh      = hc / norm(hc);
Ot      = cross( Oh , Or );

%  ON rotation matrix
ON      = [ Or' ; Ot' ; Oh' ];

%  Relative potion vector in Hill frame components
rho     = ON * ( rd - rc );

%  Chief true anomaly rate [rad/s] 
df      = norm(hc) / norm(rc)^2;

%  Angular velocity of O frame w.r.t. N frame in Hill frame components
w       = df * [0; 0; 1];

%  Relative velocity vector in Hill frame components
drho    = ON * ( vd - vc ) - cross( w , rho );

end % ---- End Function