% Find: how to filter positions and velocites

% Cleanup
clc
close all
clear all

% The logfile to analyze
filePath = '/Users/andrew/Desktop/VPP Analysis/atrias_2014-05-08-10-55-45.mat';
[c rs] = logfileToStruct(filePath);

rs = shortenData(rs,[50000:54000]);
%rs = shortenData(rs,[52100:53940]);
%rs = shortenData(rs,[52480:53090]);


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
