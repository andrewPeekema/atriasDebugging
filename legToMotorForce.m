% ATRIAS leg force to motor force derivation

% Cleanup
clc
clear all
close all

syms qA qB lA lB real
f0  = SE3;
l7  = SerialLink(f0, [0 0 -qA], lA, 0.015); % A
l8  = SerialLink(l7.h1f0, [0 0 qA-qB], lB, 0.015);

J(1,1) = diff(l8.h1f0.x,qA);
J(1,2) = diff(l8.h1f0.x,qB);
J(2,1) = diff(l8.h1f0.y,qA);
J(2,2) = diff(l8.h1f0.y,qB);

% Motor forces in terms of end effector forces:
% tau = J'*F

% The equivalent matrix using properties of SE3:
syms q1 q2 l1 l2 Fx Fy real
% Wrench applied to the end effector
W1 = [Fx; Fy; 0; 0; 0; 0];
% A frame aligned with the world at the end effector w.r.t. the end of link 1
F1 = SE3([0 0 0 0 0 q2])*SE3([l2 0 0])*SE3([0 0 0 0 0 -q2-q1]);
% Translate the wrench from the end effector to the knee
W2 = F1.transAdj*W1;
% TODO: Sanity check W2
%% Remove torque from the available degree of freedom
%W2 = W2.*[1; 1; 1; 1; 1; 0];
%% A frame aligned with the knee w.r.t. the world
%F2 = SE3([0 0 0 0 0 q1])*SE3([l1 0 0]);
%% Translate the wrench along link A
%W3 = F2.transAdj*W2;
