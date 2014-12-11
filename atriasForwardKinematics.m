function [l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16] = atriasForwardKinematics
% Generate the forward kinematics for ATRIAS on the boom

% If the kinematics already exist
if exist('data/atriasForwardKinematics.mat') == 2
    load 'data/atriasForwardKinematics.mat' l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 l13 l14 l15 l16
    return
end

display('Generating the forward kinematics...')
syms q1 q2 q3 q4 q5 q6 q7 q8 q9 real
% The origin (x pointing "up" along the boom support)
f0 = SE3([0 0 0 0 -pi/2 0]);

% The first link (spin the boom)
l1 = SerialLink(f0, [-q1 0 0], 1.005, 0.025);

% The second link (boom pitch)
l2 = SerialLink(l1.h1f0, [0 0 pi/2-q2], 2.045, 0.05);

% Rotate to align with the torso
l3 = SerialLink(l2.h1f0, [pi+q3 0 0], 0, 0);

% Fourth link (torso)
l4 = SerialLink(l3.h1f0, [0 0 -pi+deg2rad(82.72)], 0.35, 0.17);

% Right leg hip
l5 = SerialLink(l4.h1f0, [0 0 -pi/2+q4], 0.183, 0.1);
% Rotate to align the x-y plane with the right leg plane
l6 = SerialLink(l5.h1f0, [0 -pi/2 0], 0, 0);
% Right leg links
l7  = SerialLink(l6.h1f0, [0 0 -pi/2+q5], 0.5, 0.015); % A
l8  = SerialLink(l7.h1f0, [0 0 q6-q5], 0.5, 0.015);
l9  = SerialLink(l6.h1f0, [0 0 -pi/2+q6], 0.4, 0.015); % B
l10 = SerialLink(l9.h1f0, [0 0 q5-q6], 0.5, 0.015);

% Left leg hip
l11 = SerialLink(l4.h1f0, [0 0 pi/2+q7], 0.183, 0.1);
% Rotate to align the x-y plane with the right leg plane
l12 = SerialLink(l11.h1f0, [0 pi/2 0], 0, 0);
% Left leg links
l13 = SerialLink(l12.h1f0, [0 0 pi/2+q8], 0.5, 0.015); % A
l14 = SerialLink(l13.h1f0, [0 0 q9-q8], 0.5, 0.015);
l15 = SerialLink(l12.h1f0, [0 0 pi/2+q9], 0.4, 0.015); % B
l16 = SerialLink(l15.h1f0, [0 0 q8-q9], 0.5, 0.015);

display('...Done generating the forward kinematics')

save 'data/atriasForwardKinematics.mat' l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 l13 l14 l15 l16

end % atriasForwardKinematics
