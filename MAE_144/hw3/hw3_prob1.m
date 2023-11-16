clear all; clc; clf;

s = tf('s');
a0 = 0.1;
b0 = 0.1;
d = 6;

num = b0;
den = s + a0;
G = num / den;

num_delay = num * (1 - d*s/2 + (d*2)^2/12);
den_delay = den * (1 + d*s/2 + (d*s)^2/12);
G_delay = num_delay / den_delay;

figure(1)
bode(G);
title("Bode Plot with No Delay");

figure(2);
bode(G_delay);
title("Bode Plot with Delay");