clear all; clc; clf;

s = tf('s');
m=1;
w=1;
K=1;

GH1 = 12 * K/ (m*w^2*s^2);

figure(1)
rlocus(GH1)
figure(2)
rlocus(GH1 / (1 + GH1));
figure(3)
bode(GH1)

z = 1;
p = 10;

GH2 = 12 * K * (s + z) / (m*w^2*s^2*(s + p));

figure(4)
rlocus(GH2);
figure(5)
rlocus(GH2 / (1 + GH2));
figure(6)
bode(GH2);