clear all; clc;

orbital_elements = [8000; 0.1; 30; 145; 120; 10];
grav_parameter = 398600.4354; % km^3 / s^2
elapsed_time = 3600; % s
angle_type = 'deg';

[position, velocity] = koe2rv(orbital_elements, grav_parameter, elapsed_time, angle_type);

elements = rv2koe(position, velocity, grav_parameter, angle_type);