% Cleanup
clc
clear all
close all

% Load the data
load('~/Desktop/2014-11-12-12-16-5-mikhail_walk_2d.mat')

% Analyze the data
a = AtriasPostProcess(state,time,[235600:282200]);

% Visualize the data
visualizeAtrias(a.boomYawAngle, a.boomRollAngle, a.boomPitchAngle, a.right.hipAngle, a.right.legAngleA, a.right.legAngleB, a.left.hipAngle, a.left.legAngleA, a.left.legAngleB, 50);
