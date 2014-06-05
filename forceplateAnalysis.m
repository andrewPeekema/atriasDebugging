% Plot data from the forceplate alongside data from the robot

% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = '/Users/andrew/Desktop/Force Control Testing/atrias_2014-06-05-14-28-14.mat';
filePath2 = '/Users/andrew/Desktop/Force Control Testing/force_test00004.txt';
[c rs cs] = logfileToStruct(filePath,filePath2);

%rs = shortenData(rs,[32310:35800]);

plot(rs.time, rs.forceplate.fx,'.');
hold on
plot(rs.time, rs.forceplate.fy,'.');
plot(rs.time, rs.forceplate.fz,'.');
