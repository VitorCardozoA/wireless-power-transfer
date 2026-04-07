clc;
clear;

V = 350.5 * sqrt(2);
Lp = 2211e-6;
Rp = 2.211;
Ls = 2211e-6;
Rs = 2.211;
f = 50e3;
w = 2 * pi * f;
Cp = (Lp * w^2)^-1;
Cs = (Ls * w^2)^-1;
k = 0.4;
M = k * sqrt(Lp * Ls);
Rc = 320;
