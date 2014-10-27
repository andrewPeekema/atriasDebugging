% ATRIAS leg force to motor force derivation

% Cleanup
clc
clear all
close all

syms qA qB real
f0  = SE3;
l7  = SerialLink(f0, [0 0 -qA], 0.5, 0.015); % A
l8  = SerialLink(l7.h1f0, [0 0 qA-qB], 0.5, 0.015);

l7.h1f0.g
l8.h1f0.g

J(1,1) = diff(l8.h1f0.x,qA);
J(1,2) = diff(l8.h1f0.x,qB);
J(2,1) = diff(l8.h1f0.y,qA);
J(2,2) = diff(l8.h1f0.y,qB);

% Motor forces in terms of end effector forces:
% tau = J'*F

% TODO: Use purely SE3 calculations
