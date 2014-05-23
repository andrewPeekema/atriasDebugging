% Play back the kinematic data from an ATRIAS logfile

% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = '/Users/andrew/Desktop/VPP Analysis/atrias_2014-05-08-10-55-45.mat';
[c rs] = logfileToStruct(filePath);
rs = shortenData(rs,[39440:73270]);


%% Generate the kinematics
syms q1 q2 q3 q4 real
% The origin (x pointing "up" along the boom support)
f0 = SE3([0 0 0 0 -pi/2 0]);

% The first link (spin the boom)
l1 = SerialLink(f0, [q1 0 0], 1.005, 0.025);

% The second link (boom pitch)
l2 = SerialLink(l1.h1f0, [0 0 q2], 2.388, 0.05);

% The third link (torso rotation)
l3 = SerialLink(l2.h1f0, [q3 0 0], 0, 0);

% Fourth link (torso)
l4 = SerialLink(l3.h1f0, [0 0 -pi+deg2rad(82.72)], 0.417, 0.17);

% Right leg hip
l5 = SerialLink(l4.h1f0, [0 0 q4], 0.183, 0.1);


%% Plot the links
l1.plot
l2.plot
l4.plot
l5.plot

% Make sure 1 unit is the same distance on each axis
axis equal
% Make the whole workspace visible
dist = 6;
xlim([-dist/2 dist/2])
ylim([-dist/2 dist/2])
zlim([-0.1 2.0])
% Set the viewpoint
view([-37.5,10])

% Get link center functions
g1 = l1.plotFun;
g2 = l2.plotFun;
g4 = l4.plotFun;
g5 = l5.plotFun;

% Skip datapoints by this amount
frameStep = 15;

% Iterate over the states
for it = 1:frameStep:length(rs.time)
    % Angles with coordinate corrections
    q1 = rs.qBoomX(it);        % Boom angle
    q2 = -(rs.qBoom(it)-pi/2); % Boom pitch
    q3  = -(rs.qT(it)-3*pi/2); % Torso angle
    q4 = 2*pi - rs.qRh(it);    % Right hip angle

    % Plot links
    % First boom link
    l1.plotObj(g1(q1));
    % Second boom link
    l2.plotObj(g2(q1,q2));
    % Torso
    l4.plotObj(g4(q1,q2,q3));
    % Hip link
    l5.plotObj(g5(q1,q2,q3,q4));

    % Draw the figure
    drawnow
end % for it
