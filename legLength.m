
% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = './data/siavashWalking3-11-11-2014-full-lap.mat';
[c rs] = logfileToStruct(filePath);

% Leg length
plot(rs.time,rs.rLl)
hold on
plot(rs.time,rs.rLm)
title('Left Leg Length')
legend('Leg','Motor')
