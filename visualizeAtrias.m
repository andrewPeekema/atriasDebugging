% Play back the kinematic data from an ATRIAS logfile

% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = '/Users/andrew/Desktop/VPP Analysis/atrias_2014-05-08-10-55-45.mat';
[c rs] = logfileToStruct(filePath);
rs = shortenData(rs,[39440:73270]); % Walking
%rs = shortenData(rs,[68690:73270]); % Falling


%% Generate the kinematics
display('Generating the forward kinematics...')
syms q1 q2 q3 q4 q5 q6 q7 q8 q9 real
% The origin (x pointing "up" along the boom support)
f0 = SE3([0 0 0 0 -pi/2 0]);

% The first link (spin the boom)
l1 = SerialLink(f0, [q1 0 0], 1.005, 0.025);

% The second link (boom pitch)
l2 = SerialLink(l1.h1f0, [0 0 q2], 2.045, 0.05);

% Rotate to align with the torso
l3 = SerialLink(l2.h1f0, [q3 0 0], 0, 0);

% Fourth link (torso)
l4 = SerialLink(l3.h1f0, [0 0 -pi+deg2rad(82.72)], 0.35, 0.17);

% Right leg hip
l5 = SerialLink(l4.h1f0, [0 0 q4], 0.183, 0.1);
% Rotate to align the x-y plane with the right leg plane
l6 = SerialLink(l5.h1f0, [0 pi/2 0], 0, 0);
% Right leg links
l7  = SerialLink(l6.h1f0,    [0 0 q5], 0.4, 0.015); % A
l8  = SerialLink(l7.h1f0, [0 0 q6-q5], 0.5, 0.015);
l9  = SerialLink(l6.h1f0,    [0 0 q6], 0.5, 0.015); % B
l10 = SerialLink(l9.h1f0, [0 0 q5-q6], 0.5, 0.015);

% Left leg hip
l11 = SerialLink(l4.h1f0, [0 0 q7], 0.183, 0.1);
% Rotate to align the x-y plane with the right leg plane
l12 = SerialLink(l11.h1f0, [0 pi/2 0], 0, 0);
% Left leg links
l13 = SerialLink(l12.h1f0,    [0 0 q8], 0.4, 0.015); % A
l14 = SerialLink(l13.h1f0, [0 0 q9-q8], 0.5, 0.015);
l15 = SerialLink(l12.h1f0,    [0 0 q9], 0.5, 0.015); % B
l16 = SerialLink(l15.h1f0, [0 0 q8-q9], 0.5, 0.015);

display('...Done generating the forward kinematics')


%% Plot the links
l1.plot
l2.plot
l4.plot
l5.plot
l7.plot
l8.plot
l9.plot
l10.plot
l11.plot
l13.plot
l14.plot
l15.plot
l16.plot

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
g5  = l5.plotFun;
g6  = l6.plotFun;
g7  = l7.plotFun;
g8  = l8.plotFun;
g9  = l9.plotFun;
g10 = l10.plotFun;
g11 = l11.plotFun;
g13 = l13.plotFun;
g14 = l14.plotFun;
g15 = l15.plotFun;
g16 = l16.plotFun;

% Step this many ms per frame
frameStep = 15;

% Iterate over the states
for it = 1:frameStep:length(rs.time)
    % Angles with coordinate corrections
    q1 = rs.qBoomX(it);        % Boom angle
    q2 = -(rs.qBoom(it)-pi/2); % Boom pitch
    q3 = -(rs.qT(it)-3*pi/2);  % Torso angle
    q4 = 2*pi - rs.qRh(it);    % Right hip angle
    q5 = -rs.qRlA(it);         % Right leg A
    q6 = -rs.qRlB(it);         % Right leg B
    q7 = pi - rs.qLh(it);      % Left hip angle
    q8 = rs.qLlA(it);          % Left leg A
    q9 = rs.qLlB(it);          % Left leg B

    % Plot links
    % First boom link
    l1.plotObj(g1(q1));
    % Second boom link
    l2.plotObj(g2(q1,q2));
    % Torso
    l4.plotObj(g4(q1,q2,q3));
    %l4.showCoord(g4(q1,q2,q3));

    % Right hip link
    l5.plotObj(g5(q1,q2,q3,q4));
    % Right leg links
    l7.plotObj(g7(q1,q2,q3,q4,q5));
    l8.plotObj(g8(q1,q2,q3,q4,q5,q6));
    l9.plotObj(g9(q1,q2,q3,q4,q6));
    l10.plotObj(g10(q1,q2,q3,q4,q5,q6));

    % Left hip link
    l11.plotObj(g11(q1,q2,q3,q7));
    % Left leg links
    l13.plotObj(g13(q1,q2,q3,q7,q8));
    l14.plotObj(g14(q1,q2,q3,q7,q8,q9));
    l15.plotObj(g15(q1,q2,q3,q7,q9));
    l16.plotObj(g16(q1,q2,q3,q7,q8,q9));

    % Draw the figure
    drawnow
end % for it
