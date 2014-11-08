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

% Plot leg and motor angles
plot(rs.time,rs.qLlA)
hold on
plot(rs.time,rs.qLlB)
plot(rs.time,rs.qLmA)
plot(rs.time,rs.qLmB)

figure
plot(rs.time,rs.qRlA)
hold on
plot(rs.time,rs.qRlB)
plot(rs.time,rs.qRmA)
plot(rs.time,rs.qRmB)

figure
plot(rs.time,rs.lToe,'.')
hold on
plot(rs.time,rs.rToe,'.')
