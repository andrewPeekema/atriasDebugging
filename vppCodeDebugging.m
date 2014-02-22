% Reproduce the c++ code from ATRIAS using a bagfile

% Cleanup
close all
clc

% Translate from the analyseATRIAS struct to simpler notation
legN = 2; % 1,2 == left,right
qb   = a.Kinematics.bodyPitch(:,legN);
qSl  = a.Kinematics.legAngles(:,legN);
rSl  = a.Kinematics.legLength(:,legN);
rcom = 0.12; % m
rvpp = a.ControllerData.rvpp(1,1);
qvpp = a.ControllerData.qvpp(1,1);

% VPP control
% Find qSl and qT in terms of ATRIAS parameters
qT = qb - 3*pi/2; % Body pitch with respect to vertical
qSl = qSl + qT;   % Leg angle with respect to the world

% Solve for q
alpha1 = pi/2 + qSl - qT;
C1 = (rcom.^2 + rSl.^2 - 2*rcom.*rSl.*cos(alpha1)).^0.5;
theta1 = asin(rcom./C1.*sin(alpha1));
alpha2 = theta1 + alpha1 + qvpp;
C2 = (rvpp.^2 + C1.^2 - 2*rvpp.*C1.*cos(alpha2)).^0.5;
theta2 = asin(rvpp./C2.*sin(alpha2));
q = theta1 + theta2;

plot(q)
