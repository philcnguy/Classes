function [ dx ] = dynamics_Newton( ~ , x , const )

%  Inertial position and velocity vectors
r           = x(1:3);
v           = x(4:6);

rmag        = norm(r);
rhat        = r/rmag;

%  Gravitational acceleration due to a point-mass 
a_point     = -const.mu / rmag^3 * r;

% %  Gravitational acceleration due to oblateness     
% a_J2        = - 3/2 * const.mu * const.J2 * const.R^2 / rmag^4 * ...
%               ( ( 1 - 5 * dot( rhat , [0 0 1]' )^2 ) * rhat + ...
%               2 * dot( rhat , [0 0 1]' ) * [0 0 1]' );
     
%  Drag dynamics
rhoA = const.rho0*exp(-(norm(r)*10^3 - const.r0)/const.H);
VA = [ x(4) + const.thetadot*x(2);
       x(5) - const.thetadot*x(1);
       x(6) ];
a_drag = -(1/2)*const.Cd*const.Acs*rhoA*norm(VA)*VA/const.m;     

%  State diffeerential
dx          = [ v ; a_point + a_drag ];

end