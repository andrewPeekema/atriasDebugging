% Plot the desired vs actual leg force

% Cleanup
close all
clear all
clc

% The logfile to analyze
addpath('./..')
filePath = '/Users/andrew/Desktop/VPP Analysis/atrias_2014-05-08-10-55-45.mat';
tic
[rs cs] = logfileToStruct(filePath);
toc
display(['Analyzing: ' filePath])

% Left leg
controlF = hypot(cs.controlFxL,cs.controlFzL);
computeF = hypot(cs.computeFxL,cs.computeFzL);
% Display
plot(controlF,'r.')
hold on
plot(computeF,'b.')
plot(rs.cmdLA,'g.')
plot(rs.cmdLB,'g.')

% Right leg
controlF = hypot(cs.controlFxR,cs.controlFzR);
computeF = hypot(cs.computeFxR,cs.computeFzR);
% Display
plot(controlF,'r.')
hold on
plot(computeF,'b.')
plot(rs.cmdRA,'g.')
plot(rs.cmdRB,'g.')

% Labels
legend('Desired Force (N)',...
       'Actual Force (N)',...
       'Control Error (%)',...
       'Motor Current (A)',...
       'Location','NorthEast')

% Don't show bad data
yLimits = ylim;
ylim([-200 yLimits(2)])
