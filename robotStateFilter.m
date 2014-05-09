% Find: how to filter positions and velocites

% Cleanup
clc
close all
clear all

% The logfile to analyze
filePath = '/Users/andrew/Desktop/VPP Analysis/atrias_2014-05-08-10-55-45.mat';
rs = logfileToStruct(filePath);
display(['Analyzing: ' filePath])

% Robot velocity
plot(rs.time,rs.dx,'.')
