% Make a boolean value from the toe data

% Cleanup
clear all
close all
clc

% The logfile to analyze
filePath = './data/siavashWalking-11-7-2014.mat';
[c rs] = logfileToStruct(filePath);

% Shorten the data
rs = shortenData(rs,[167634:200759]);

% Make the filters
lToeFilter = toeFilter(20,170);
rToeFilter = toeFilter(20,170);

% Run through the data
lToeFilterData = zeros(1,length(rs.time));
rToeFilterData = zeros(1,length(rs.time));
for a = 1:length(rs.time)
    lToeFilterData(a) = lToeFilter.switched(rs.lToe(a));
    rToeFilterData(a) = rToeFilter.switched(rs.rToe(a));
end

% Plot both datasets
figure
plot(rs.time,rs.lToe,'b.')
hold on
plot(rs.time,lToeFilterData,'r-')
title('Left Toe Data')

figure
plot(rs.time,rs.rToe,'b.')
hold on
plot(rs.time,rToeFilterData,'r-')
title('Right Toe Data')
