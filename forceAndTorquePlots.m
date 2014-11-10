% Plot the leg force

% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = './data/siavashWalking-11-7-2014.mat';
[c rs] = logfileToStruct(filePath);

% Shorten the data
rs = shortenData(rs,[167634:200759]);

% Convert to controller coordinates
theta1  = rs.qb+rs.qLlA-pi/2;
theta2  = rs.qb+rs.qLlB-pi/2;
thetam1 = rs.qb+rs.qLmA-pi/2;
thetam2 = rs.qb+rs.qLmB-pi/2;

% Desired motor angles
a = (inv([1 1; -1 1])*[theta1'+theta2'; ones(1,length(theta1))*2*acos(0.9)])';

% Left leg
% Display
figure
%plot(rs.time,(rs.lADfl+rs.lBDfl)*c.ks,'r.')
%hold on
%plot(rs.time,(rs.rADfl+rs.rBDfl)*c.ks,'b.')


%figure
%plot(rs.time,a(1)-thetam1,'r.')
%hold on
%plot(rs.time,a(2)-thetam2,'b.')

% Spring deflections
plot(rs.time,rs.lADfl*c.ks,'r.')
hold on
plot(rs.time,rs.lBDfl*c.ks,'b.')
title('Left Leg Spring Torques')

figure
plot(rs.time,rs.rADfl*c.ks,'r.')
hold on
plot(rs.time,rs.rBDfl*c.ks,'b.')
title('Right Leg Spring Torques')
