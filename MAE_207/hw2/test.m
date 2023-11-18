clear all; clc;

orbital_elements = [8000; 0.1; 30; 145; 120; 10];
grav_parameter = 398600.4354; % km^3 / s^2
elapsed_time = 3600; % s
angle_type = 'deg';

[position, velocity] = koe2rv(orbital_elements, grav_parameter, elapsed_time, angle_type);
elements = rv2koe(position, velocity, grav_parameter, angle_type);

[cartesian] = hw2_prob1('koe', [8000; 0.1; 30; 145; 120; 10], grav_parameter, elapsed_time);
[keplarian] = hw2_prob1('rv', [-1264.608; 8013.809; -3371.252; -6.039621; -0.204398; 2.096715], grav_parameter, elapsed_time);