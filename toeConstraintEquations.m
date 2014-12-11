function [lToeXyz,rToeXyz] = toeConstraintEquations
% Generate equations to constrain the toe to a cylinder

% If the solution has already been found
if exist('data/toeConstraintEquations.mat') == 2
    load 'data/toeConstraintEquations.mat' lToeXyz rToeXyz
    return
end

%% Generate the kinematics
[l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16] = atriasForwardKinematics;

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

%% Angles
%q1 = 0; % Boom yaw
%q2 = 0.1; % Boom roll
%q3 = 0.2; % Boom pitch
%q4 = 0; % Right hip angle
%q5 = 3*pi/4; % Right leg A
%q6 = 5*pi/4; % Right leg B
%q7 = 0; % Left hip angle
%q8 = 3*pi/4; % Left leg A
%q9 = 5*pi/4; % Left leg B

% Angles
q1 = 0; % Boom yaw
q2 = 0; % Boom roll
q3 = -0.7854; % Boom pitch
q4 = 0; % Right hip angle
q5 = 0.4155; % Right leg A
q6 = 2.7301; % Right leg B
q7 = 0; % Left hip angle
q8 = q5; % Left leg A
q9 = q6; % Left leg B

% Plot links
% First boom link
l1.plotObj(g1(q1));
% Second boom link
l2.plotObj(g2(q1,q2));
% Torso
l4.plotObj(g4(q1,q2,q3));

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

% The right toe
rToe = l8.h1f0;
rToeXyz = matlabFunction(rToe.xyz);
rToeXyzP = rToeXyz(q1,q2,q3,q4,q5,q6);
plot3(rToeXyzP(1),rToeXyzP(2),rToeXyzP(3),'-mo','MarkerSize',15)

% The left toe
lToe = l14.h1f0;
lToeXyz = matlabFunction(lToe.xyz);
lToeXyzP = lToeXyz(q1,q2,q3,q7,q8,q9);
plot3(lToeXyzP(1),lToeXyzP(2),lToeXyzP(3),'-co','MarkerSize',15)

% The circle constraint
% Left foot
r = 2.197; % initial guess [m]
x = -r:0.001:r;
y = (r^2-x.^2).^0.5;
x = [x  flip(x)];
y = [y -y];
plot3(x,y,0*x,'c');

% Right foot
r = 1.833; % initial guess [m]
x = -r:0.001:r;
y = (r^2-x.^2).^0.5;
x = [x  flip(x)];
y = [y -y];
plot3(x,y,0*x,'m');

% Draw the figure
drawnow

% Save the equations
save 'data/toeConstraintEquations.mat' lToeXyz rToeXyz

end
