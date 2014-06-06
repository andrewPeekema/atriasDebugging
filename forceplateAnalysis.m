% Plot data from the forceplate alongside data from the robot

% Cleanup
close all
clear all
clc

% The logfile to analyze
directory = '/home/andrew/ForceControlTesting/';
filePath = [directory 'atrias_2014-06-05-14-28-14.mat'];
filePath2 = [directory 'force_test00004.txt'];
[c rs cs] = logfileToStruct(filePath,filePath2);

%rs = shortenData(rs,[32310:35800]);

figure(1)
plot(rs.time, rs.forceplate.fx,'.');
hold on
plot(rs.time, rs.forceplate.fy,'.');
plot(rs.time, rs.forceplate.fz,'.');
plot(rs.time, cs.fzDes,'b')
plot(rs.time, -cs.computeFzL,'r')

title('Feedback Linearization Force Control')
xlabel('Time (s)')
ylabel('Force (N)')


%% The logfile to analyze
filePath = [directory 'atrias_2014-06-05-14-34-34.mat'];
filePath2 = [directory 'force_test00005.txt'];
[c rs cs] = logfileToStruct(filePath,filePath2);

%rs = shortenData(rs,[32310:35800]);

figure(2)
plot(rs.time, rs.forceplate.fx,'.');
hold on
plot(rs.time, rs.forceplate.fy,'.');
plot(rs.time, rs.forceplate.fz,'.');
plot(rs.time, -cs.controlFzL,'b')
plot(rs.time, -cs.computeFzL,'r')

title('PD Force Control')
xlabel('Time (s)')
ylabel('Force (N)')
