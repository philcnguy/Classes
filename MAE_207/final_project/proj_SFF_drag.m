%{
FILENAME: proj_SFF_drag

DESCRIPTION:

FUNCTIONS/SCRIPTS CALLED:
    mean2osc.m
    koe2rv.m
    Newton2Hill.m

MODIFICATIONS:
    6-Dec-2023    |    Aaron J. Rosengren - Original
    13-Dec-2023   |    Phillip C. Nguyen

REFERENCES:
    MAE 207 - Fall 2023
    Schaub & Junkins, Analytical Mechanics of Space Systems, 2nd Ed., 2009
%}

clearvars; close all; clc
format long 

% -------------------------------------------------------------------------
%     CONSTANTS      
% -------------------------------------------------------------------------

const.r2d       = 180/pi;                       % radians-to-degrees
const.mu        = 3.986004354360959e5;          % gravitational parameter [ km^3/s^2 ]
const.R         = 6.3781366e3;                  % mean equatorial radius [ km ]
const.Cd        = 2.00;                         % satellite drag coefficient [ ]
const.m         = 5.8;                          % mass of satellite [ kg ]
const.altitude  = 400;                          % initial altitude [ km ]
const.rho0      = atmosphere(const.altitude);
const.J2        = 1.082635525490e-3;            % oblateness gravity field coefficient
const.r0 		= 7298145.0;     				% m
const.H 		= 200000.0;       				% m
const.thetadot 	= 7.29211585530066e-5;    		% rad/s

% -------------------------------------------------------------------------
%     INITIAL STATES | CHIEF & DEPUTY ( SJ09, Ex. 14.4, p. 715 )
% -------------------------------------------------------------------------

%  Specifiy chief mean orbit element vector
a               = const.R + const.altitude;     % semimajor axis [ km ]
e               = 0.05;                         % eccentricity [ ]
i               = 64.9;                         % inclination [ deg ]
Om              = 0;                            % right ascension [ deg ]
w               = 30;                           % argument of perigee [ deg ]
M               = 0;                            % mean anomaly [ deg ]

kepc_mean       = [ a; e; i; Om; w; M ];

%  Mean orbit element difference vector
da              = -0.351765E-03;                % semimajor axis difference [ km ]   
de              = 0.0001;                       % eccentricity difference [ ]
di              = 0.001035;                     % inclination difference [ deg ] 
dOm             = 0.005;                        % ascending node difference [ deg ]
dw              = 0.01;                         % argument of perigee difference [ deg ]
dM              = -0.01;                        % mean anomaly difference [ deg ]

dkep_mean       = [ da; de; di; dOm; dw; dM ];

%  Specifiy deputy mean orbit element vector
kepd_mean       = kepc_mean + dkep_mean;

%  Osculating chief and deputy orbit element vectors  
kepc_osc        = mean2osc( kepc_mean , const , 'mean' , 'deg' );
kepd_osc        = mean2osc( kepd_mean , const , 'mean' , 'deg' );

% kepc_osc = kepc_mean;
% kepd_osc = kepd_mean;

%  Initial Cartesian position and velocity vectors
[ rc0 , vc0 ]   = koe2rv( kepc_mean , const.mu , 0 , 'deg' );
[ rd0 , vd0 ]   = koe2rv( kepd_mean , const.mu , 0 , 'deg' );

% -------------------------------------------------------------------------
%     ORBIT PROPAGATION 
% -------------------------------------------------------------------------

%  Specify number of points in integration 
T               = 2 * pi * sqrt( kepc_osc(1)^3 / const.mu );   % length of period [s]
time            = linspace( 0 , 90 * T , 5001 );

%  Set integrator options
tol             = 1e-12;    
options         = odeset( 'RelTol' , tol , 'AbsTol' , tol );

%  Chief inertial position and velocity
const.Acs       = 0.0945;                         % cross-sectional area of chief [ m^2 ]
xc0             = [ rc0 ; vc0 ];
[ ~ , xc ]      = ode45( @dynamics_Newton , time , xc0 , options , const );
rc              = xc(:,1:3);
vc              = xc(:,4:6);

%  Deputy inertial position and velocity
const.Acs       = 0.0945;                         % cross-sectional area of deputy [ m^2 ]
xd0             = [ rd0 ; vd0 ];
[ ~ , xd ]      = ode45( @dynamics_Newton , time , xd0 , options , const );
rd              = xd(:,1:3);
vd              = xd(:,4:6);

%  Map inertial to Hill frame
rho             = zeros(3, length(time));
for k = 1:length(time)
    
    [ rho(:,k) , ~ ] = Newton2Hill( rc(k,:)', vc(k,:)', rd(k,:)', vd(k,:)' );

end

rho  = rho';

% -------------------------------------------------------------------------
%     FIGURES
% -------------------------------------------------------------------------

mymap = [ [0.875 0.875 0.875] ; [0 0 0] ]; 
set( 0 , 'DefaultAxesColorOrder' , mymap )

idx = find( time < T );

figure(1); 
    plot3( rho(:,1) , rho(:,2) , rho(:,3) );
    hold all
    plot3( rho(idx,1) , rho(idx,2) , rho(idx,3) )
    plot3( 0 , 0 , 0 , 'k.' , 'MarkerSize' , 21 );
    grid on 
    box on         
    hXLabel = xlabel( 'Radial [km]' );
    hYLabel = ylabel( 'Along-Track [km]' );
    hZLabel = zlabel( 'Out-of-Plane [km]' );  
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel , hZLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [0,6.75,6,4.75] );    
    set( gcf, 'PaperPositionMode' , 'auto' );     

figure(2); 
    plot( rho(:,1) , rho(:,2) );
    hold all
    plot( rho(idx,1) , rho(idx,2) );
    plot( 0 , 0 , 'k.', 'MarkerSize', 21 );    
    grid on         
    hXLabel = xlabel( 'Radial [km]' );
    hYLabel = ylabel( 'Along-Track [km]' );
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [6,6.75,6,4.75] );     
    set( gcf, 'PaperPositionMode' , 'auto' );     
    
figure(3);
    plot( rho(:,1) , rho(:,3) );
    hold all
    plot( rho(idx,1) , rho(idx,3) );
    plot( 0 , 0 , 'k.' , 'MarkerSize' , 21 );    
    grid on
    hXLabel = xlabel( 'Radial [km]' );
    hYLabel = ylabel( 'Out-of-Plane [km]' );
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [0,0.9,6,4.75] ); 
    set( gcf, 'PaperPositionMode' , 'auto' );     

figure(4);
    plot( rho(:,2) , rho(:,3) );
    hold all
    plot( rho(idx,2) , rho(idx,3) );
    plot( 0 , 0 , 'k.' , 'MarkerSize' , 21 );     
    grid on
    hXLabel = xlabel( 'Along-Track [km]' );
    hYLabel = ylabel( 'Out-of-Plane [km]' );
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [6,0.9,6,4.75] ); 
    set( gcf, 'PaperPositionMode' , 'auto' );     
   
figure(5);
    plot(time / 3600, sqrt(sum((rc - rd).^2,2)), Color = 'red');
    xlabel("Time [hr]");
    ylabel("Distance Between Satellites [km]");
%    hold on