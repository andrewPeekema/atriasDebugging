% Show filtered positions and velocities

% Cleanup
clc
close all
clear all

% The file to analyze
loadFile

% Display the data
figure
% Leg angles
subplot(4,4,1)
plot(rs.time,rs.qLlA,'.')
subplot(4,4,2)
plot(rs.time,rs.qLlB,'.')
subplot(4,4,3)
plot(rs.time,rs.qRlA,'.')
subplot(4,4,4)
plot(rs.time,rs.qRlB,'.')
% Leg velocity
subplot(4,4,5)
plot(rs.time,rs.dqLlA,'.')
subplot(4,4,6)
plot(rs.time,rs.dqLlB,'.')
subplot(4,4,7)
plot(rs.time,rs.dqRlA,'.')
subplot(4,4,8)
plot(rs.time,rs.dqRlB,'.')

% Now show the filtered data
rs = filterData(rs,4);
% Leg angles
subplot(4,4,1)
hold on
plot(rs.time,rs.qLlA,'r.')
subplot(4,4,2)
hold on
plot(rs.time,rs.qLlB,'r.')
subplot(4,4,3)
hold on
plot(rs.time,rs.qRlA,'r.')
subplot(4,4,4)
hold on
plot(rs.time,rs.qRlB,'r.')
% Leg velocity
subplot(4,4,5)
hold on
plot(rs.time,rs.dqLlA,'r.')
subplot(4,4,6)
hold on
plot(rs.time,rs.dqLlB,'r.')
subplot(4,4,7)
hold on
plot(rs.time,rs.dqRlA,'r.')
subplot(4,4,8)
hold on
plot(rs.time,rs.dqRlB,'r.')
