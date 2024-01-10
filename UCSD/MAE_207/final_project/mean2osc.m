function [ coep ] = mean2osc( coe, const, inputtype, angletype )
%{
FILENAME:  mean2osc.m

DESCRIPTION:  First-order mapping (based on the theory developed by Brouwer
and Lyddane) between mean (orbit averaged, with short- and long-period
motion removed) orbit elements and osculating (instantaneous) orbit
elements. See Appendix F in Ref.

INPUTS:
    coe         = vector which contains the classical orbit elements
                    [ a; e; i; Om; w; M ]
    const       = structure containing primary body constants 
                    const.mu [ km^3/s^2 ]
                    const.R  [ km ]
                    const.J2 [ ]
    inputtype   = string indicating if input is mean or osculating orbit
                  elements 
                    'mean' = mean, 'osc' = osculating
    angletype   = string indicating desired angletype for inputs/outputs
                    'deg' = degrees, 'rad' = radians

OUTPUTS:
    coep        = vector which contains the classical orbit elements
                    [ a; e; i; Om; w; M ]

FUNCTIONS/SCRIPTS CALLED:
    KepEqn.m

CALLED BY:
    proj_J2invariance.m

MODIFICATIONS:
    6-Dec-2023    |    Aaron J. Rosengren - Original

REFERENCES:
    Schaub & Junkins, Analytical Mechanics of Space Systems, 2nd Ed., Appendix F, 2009
%}

%  Conversions
d2r = pi/180;

if(strcmp(angletype, 'deg'))
    coe(3:end) = coe(3:end) * d2r;
end

coe(4:end) = mod( coe(4:end), 2*pi );

%  Classical orbit elements
a       = coe(1);                           % semi-major axis [ km ]  
ec      = coe(2);                           % eccentricity [ ]
in      = coe(3);                           % inclination [ rad ]
Om      = coe(4);                           % right ascension of the ascending node [ rad ]
w       = coe(5);                           % argument of periapsis [ rad ]
M       = coe(6);                           % mean anomaly at epoch time t0 [ rad ]

if(strcmp(inputtype, 'mean'))
    gamma2 = const.J2 / 2 * ( const.R / a )^2;
else
    gamma2 = -const.J2 / 2 * ( const.R / a )^2;
end

%  True anomaly [ rad ]
f       = mod( KepEqn( M, ec, 'rad' ) , 2 * pi );   

ec2     = ec^2;
eta     = sqrt( 1 - ec2 );
eta2    = eta^2;
eta3    = eta^3;
eta6    = eta^6;
gamma2p = gamma2 / eta^4;
cM      = cos( M );
sM      = sin( M );
cOm     = cos( Om );
sOm     = sin( Om );
cf      = cos( f );
cf2     = cf^2;
cf3     = cf^3;
sf      = sin( f );
c2w     = cos( 2 * w );
s2w     = sin( 2 * w ); 
c2t     = cos( 2 * (w + f) );
s2t     = sin( 2 * (w + f) );
c2wf    = cos( 2 * w + f );
s2wf    = sin( 2 * w + f );
c2w3f   = cos( 2 * w + 3 * f );
s2w3f   = sin( 2 * w + 3 * f );
ar      = ( 1 + ec * cf ) / eta2;               % ratio a/r (r = current radius)
areta   = ( ar * eta )^2 + ar;   
EOC     = f - M + ec * sf;
ci      = cos( in );
ci2     = ci^2;
ci4     = ci^4;
ci6     = ci^6;
si      = sin( in );
cih     = cos( in / 2 );
sih     = sin( in / 2 );
ci2f    = 3 * ci2 - 1;
crit    = 1 / ( 1 - 5 * ci2 );                  % critical inclination divisor 
crit2   = crit^2;
critf   = 1 - 11 * ci2 - 40 * ci4 * crit;
critf2  = 2 + ec2 - 11 * ( 2 + 3 * ec2 ) * ci2 - ...
          40 * ( 2 + 5 * ec2 ) * ci4 * crit - 400 * ec2 * ci6 * crit2;
critf3  = 11 + 80 * crit * ci2 + 200 * crit2 * ci4;

%  Transformed semimajor axis
da      = a * gamma2 * ( ci2f * ( ar^3 - 1 / eta3 ) + ....
          3 * ( 1 - ci2 ) * ar^3 * c2t );
ap      = a + da;

%  Various intermediate results
de1     = gamma2p / 8 * ec * eta2 * critf * c2w; 

de      = de1 + eta2 / 2 * ( gamma2 * ( ci2f / eta6 * ...
          ( ec * ( eta + 1 / ( 1 + eta ) ) + 3 * cf + 3 * ec * cf2 + ec2 * cf3 ) + ...
          3 * ( 1 - ci2 ) / eta6 * ( ec + 3 * cf + 3 * ec * cf2 + ec2 * cf3 ) * c2t ) - ...
          gamma2p * ( 1 - ci2 ) * ( 3 * c2wf + c2w3f ) );

di      = - ec * de1 / ( eta2 * tan(in) ) + gamma2p / 2 * ci * si * ...
          ( 3 * c2t + 3 * ec * c2wf + ec * c2w3f );

MwOm    = M + w + Om + ...
          gamma2p / 8 * eta3 * critf * s2w - ...
          gamma2p / 16 * critf2 * s2w + ...
          gamma2p / 4 * ( -6 / crit * EOC + ...
          ( 3 - 5 * ci2 ) * ( 3 * s2t + ec * ( 3 * s2wf + s2w3f ) ) ) - ...
          gamma2p / 8 * ec2 * ci * critf3 * s2w - ...
          gamma2p / 2 * ci * ( 6 * EOC - 3 * s2t - ...
          3 * ec * s2wf - ec * s2w3f );  
  
edM     = gamma2p / 8 * ec * eta3 * critf * s2w - ...
          gamma2p / 4 * eta3 * ( 2 * ci2f * ( areta + 1 ) * sf + ...
          3 * ( 1 - ci2 ) * ( ( -areta + 1 ) * s2wf + ...
          ( areta + 1 / 3 ) * s2w3f ) );  
   
dOm     = -gamma2p / 8 * ec2 * ci * critf3 * s2w - ...
          gamma2p / 2 * ci * ( 6 * EOC - 3 * s2t - ec * ( 3 * s2wf + s2w3f ) );

%  Transformed mean anomaly and eccentricity  
d1      = ( ec + de ) * sM + edM * cM;
d2      = ( ec + de ) * cM - edM * sM;
Mp      = mod( atan2( d1 , d2 ), 2 * pi );
ep      = sqrt( d1^2 + d2^2 );

%  Transformed ascending node and inclination 
d3      = ( sih + cih * di / 2 ) * sOm + sih * dOm * cOm;
d4      = ( sih + cih * di / 2) * cOm - sih * dOm * sOm;
Omp     = atan2( d3 , d4 );
ip      = 2 * asin( sqrt( d3^2 + d4^2 ) );

%  Transformed argument of perigee
wp      = MwOm - Mp - Omp;

%  Mod out by 2pi
Omp     = mod( Omp , 2*pi );
wp      = mod( wp , 2*pi );
Mp      = mod( Mp , 2*pi );
    
if(strcmp(angletype, 'deg'))
    ip  = ip / d2r;
    Omp = Omp / d2r;
    wp  = wp / d2r;
    Mp  = Mp / d2r;
end

%  Transformed orbit element vector
coep = [ ap ; ep ; ip ; Omp ; wp ; Mp ];

end % ----- End Function