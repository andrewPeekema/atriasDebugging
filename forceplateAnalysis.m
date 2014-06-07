% Plot data from the forceplate alongside data from the robot

% Cleanup
close all
clear all
clc

% The logfile to analyze
directory = '/Users/andrew/Desktop/Force Control Testing/';
filePath = [directory 'atrias_2014-06-06-12-59-10.mat'];
filePath2 = [directory 'force_test00007.txt'];
[c rs cs] = logfileToStruct(filePath,filePath2);

% Crop to the force test
rs = shortenData(rs,[25490:50730]);
cs = shortenData(cs,[25490:50730]);

% Fit the force data
bestFit = fitForceData(rs);

% Find the world forces
force = rsToWorldForce(rs, bestFit.ks);
LFz = bestFit.y0 - force.LF.Fz;



figure
plot(rs.time, rs.forceplateF,'.');
hold on
%plot(rs.time, cs.fzDes,'b')
plot(rs.time, -cs.computeFzL,'r')
plot(rs.time, LFz,'g')

title('Feedback Linearization Force Control')
xlabel('Time (s)')
ylabel('Force (N)')


%{
%% The logfile to analyze
filePath = [directory 'atrias_2014-06-06-12-48-14.mat'];
filePath2 = [directory 'force_test00006.txt'];
[c rs cs] = logfileToStruct(filePath,filePath2);

%rs = shortenData(rs,[32310:35800]);

figure
plot(rs.time, rs.forceplateF,'.');
hold on
plot(rs.time, -cs.controlFzL,'b')
plot(rs.time, -cs.computeFzL,'r')

title('PD Force Control')
xlabel('Time (s)')
ylabel('Force (N)')
%}
