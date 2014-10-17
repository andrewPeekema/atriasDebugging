% Generate equations to constrain the toe to a cylinder

% Clenaup
close all
clear all
clc

%% Generate the forward kinematics
display('Generating the forward kinematics...')
syms q1 q2 q3 q4 q5 q6 q7 q8 q9 real
% The origin (x pointing "up" along the boom support)
f0 = SE3([0 0 0 0 -pi/2 0]);

% The first link (Boom yaw)
l1 = SerialLink(f0, [q1 0 0], 1.005, 0.025);

% The second link (Boom roll)
l2 = SerialLink(l1.h1f0, [0 0 pi/2-q2], 2.045, 0.05);

% Rotate to align with the torso (Torso pitch)
l3 = SerialLink(l2.h1f0, [pi+q3 0 0], 0, 0);

% Fourth link (Torso)
l4 = SerialLink(l3.h1f0, [0 0 -pi+deg2rad(82.72)], 0.35, 0.17);

% Right leg hip
l5 = SerialLink(l4.h1f0, [0 0 q4], 0.183, 0.1);

% Torso-Hip Connection point
%p1 = SerialLink(l4.h1f0, [0 0 0], 0, 0);

%% Visualize the links
l1.plot
l2.plot
l4.plot

% Plot settings
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
g1  = l1.plotFun;
g2  = l2.plotFun;
g4  = l4.plotFun;
%gp1 = p1.plotFun;

% Show how things are oriented
% Set angles
q1 = 0; % Boom yaw
q2 = 0.1; % Boom roll
q3 = 0.2; % Torso pitch

% First boom link
l1.plotObj(g1(q1));
% Second boom link
l2.plotObj(g2(q1,q2));
% Torso
l4.plotObj(g4(q1,q2,q3));

% Show coordinates
l1.showCoord(g1(q1));
l2.showCoord(g2(q1,q2));
l4.showCoord(g4(q1,q2,q3));

%% Plot points
%gp1 = SE3(gp1(q1,q2,q3));
%gp1 = gp1.xyz;
%plot3(gp1(1),gp1(2),gp1(3),'-mo','MarkerSize',15)
%
%% Point equations
%p1xyz = p1.g1f0.xyz;

% Draw the figure
drawnow
