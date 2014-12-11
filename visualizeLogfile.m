% Cleanup
clc
clear all
close all

%load('~/Desktop/2014-11-12-12-16-5-mikhail_walk_2d.mat')
%a = AtriasPostProcess(state,time,[240000:270000]);

load('~/Desktop/2014-12-10-10-54-1-siavash_2D_walking.mat')
a = AtriasPostProcess(state,time,[65810:101600]);

% Visualize the data
visualizeAtrias(a.boomYawAngle, a.boomRollAngle, a.boomPitchAngle, a.right.hipAngle, a.right.legAngleA, a.right.legAngleB, a.left.hipAngle, a.left.legAngleA, a.left.legAngleB, 50);
