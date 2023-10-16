clear all; clc;

a = RR_poly([-1 1 -3 3 -6 6],1);
b = RR_poly([-2 2 -5 5],1);

f1 = RR_poly([-1 -1 -3 -3 -6 -6 -20],1);
[x1,y1] = RR_diophantine(a,b,f1)

f2 = RR_poly([-1 -1 -3 -3 -6 -6 -20 -20],1);
[x2,y2] = RR_diophantine(a,b,f2)

f3 = RR_poly([-1 -1 -3 -3 -6 -6 -20 -20 -20],1);
[x3,y3] = RR_diophantine(a,b,f3)

f4 = RR_poly([-1 -1 -3 -3 -6 -6 -20 -20 -20 -20],1);
[x4,y4] = RR_diophantine(a,b,f4)

f5 = RR_poly([-1 -1 -3 -3 -6 -6 -20 -20 -20 -20 -20],1);
[x5,y5] = RR_diophantine(a,b,f5)

test5=trim(a*x5+b*y5)
residual5=norm(f5-test5)

f6 = RR_poly([-1 -1 -3 -3 -6 -6 -20 -20 -20 -20 -20 -20],1);
[x6,y6] = RR_diophantine(a,b,f6)

test6=trim(a*x6+b*y6)
residual6=norm(f6-test6)