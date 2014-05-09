% Find: how to filter positions and velocites

% Cleanup
clc
close all
clear all

% The logfile to analyze
filePath = '/Users/andrew/Desktop/VPP Analysis/atrias_2014-05-08-10-55-45.mat';
[c rs] = logfileToStruct(filePath);

rs = shortenData(rs,[52100:55860]);

% Robot velocity
subplot(4,4,1)
plot(rs.time,rs.qLlA,'.')
subplot(4,4,2)
plot(rs.time,rs.qLlB,'.')
subplot(4,4,3)
plot(rs.time,rs.qRlA,'.')
subplot(4,4,4)
plot(rs.time,rs.qRlB,'.')
