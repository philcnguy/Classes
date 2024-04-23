clear all; clc;

%% Problem 1c

P = [0.8 0.2 0; 0.4 0.4 0.2; 0.2 0.6 0.2];

bel1 = zeros(3,10);
bel2 = zeros(3,10);
bel3 = zeros(3,10);

bel10 = [1 0 0].';
bel20 = [0 1 0].';
bel30 = [0 0 1].';

bel1(1:3,1) = (bel10.' * P).';
bel2(1:3,1) = (bel20.' * P).';
bel3(1:3,1) = (bel30.' * P).';

for i = 2:10
    bel1(1:3,i) = (bel1(1:3,i-1).' * P).';
    bel2(1:3,i) = (bel2(1:3,i-1).' * P).';
    bel3(1:3,i) = (bel3(1:3,i-1).' * P).';
end

disp(bel1);
disp(bel2);
disp(bel3);

%% Problem 1e

P = [1 0 0; 0.4 0.4 0.2; 0 0.6 0.4];

bel1 = zeros(3,10);
bel2 = zeros(3,10);
bel3 = zeros(3,10);

bel10 = [1 0 0].';
bel20 = [0 1 0].';
bel30 = [0 0 1].';

bel1(1:3,1) = (bel10.' * P).';
bel2(1:3,1) = (bel20.' * P).';
bel3(1:3,1) = (bel30.' * P).';

for i = 2:100
    bel1(1:3,i) = (bel1(1:3,i-1).' * P).';
    bel2(1:3,i) = (bel2(1:3,i-1).' * P).';
    bel3(1:3,i) = (bel3(1:3,i-1).' * P).';
end

disp(bel1);
disp(bel2);
disp(bel3);