% Find the jacobian of how toe forces translate to motor movement

% Need to find a function for the leg angle in terms of the toe x and y world coordinates

clc
clear all
close all

syms qA qB qb L1 L2

torso = SE3([0 0 0 0 qb-3*pi/2 0]);
link1Beg = torso*SE3([0 0 0 0 qA 0]);
link1End = link1Beg*SE3([L1 0 0]);
link2Beg = link1End*SE3([0 0 0 0 qB-qA 0]);
link2End = link2Beg*SE3([L2 0 0]);
toe = link2End*SE3([0 0 0 0 -qB-qb+3*pi/2 0]);
