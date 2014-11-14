clear all
close all
clc

% Benchtop computer
load('./data/siavashWalking3-11-11-2014-full-lap.mat')
a = AtriasPostProcess(state,time,[94830:125800])

% Robot computer
load('./data/2014-11-13-10-44-3-siavash_2D_walking.mat')
b = AtriasPostProcess(state,time,[109600:142100])
load('./data/2014-11-13-10-51-17-siavash_2D_walking.mat')
c = AtriasPostProcess(state,time)

% Only plot the right leg
a.plotLeftLeg = 0;
b.plotLeftLeg = 0;
c.plotLeftLeg = 0;

%% Show commanded motor torques
%a.plotLegMotorTorques;
%b.plotLegMotorTorques;
%c.plotLegMotorTorques;
%
%% Show the motor velocities
%a.plotMotorVelocities;
%b.plotMotorVelocities;
%c.plotMotorVelocities;

a.plotAxialLegForce
a.plotForceLengthCurve
