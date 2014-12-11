function visualizeAtrias(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,frameSkip)
% Plot ATRIAS kinematic data
% Input:
%    Q1: Boom yaw [rad] (nominal: 0)
%    Q2: Boom roll [rad] (nominal: ~0.1)
%    Q3: Boom pitch [rad] (nominal: 0)
%    Q4: Right hip angle [rad] (nominal: 0)
%    Q5: Right leg A [rad] (nominal: 3*pi/4)
%    Q6: Right leg B [rad] (nominal: 5*pi/4)
%    Q7: Left hip angle [rad] (nominal: 0)
%    Q8: Left leg A [rad] (nominal: 3*pi/4)
%    Q9: Left leg B [rad] (nominal: 5*pi/4)
%    frameSkip: How many states to skip between frames
%
% Output: 3-D plot of ATRIAS

% Find the forward kinematics
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

% Iterate over the states
for it = 1:(1+frameSkip):length(Q1)
    % Angles
    q1 = Q1(it); % Boom yaw
    q2 = Q2(it); % Boom roll
    q3 = Q3(it); % Boom pitch
    q4 = Q4(it); % Right hip angle
    q5 = Q5(it); % Right leg A
    q6 = Q6(it); % Right leg B
    q7 = Q7(it); % Left hip angle
    q8 = Q8(it); % Left leg A
    q9 = Q9(it); % Left leg B

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
    % The toe
    l8.traceEnd(g8(q1,q2,q3,q4,q5,q6),'.r');

    % Left hip link
    l11.plotObj(g11(q1,q2,q3,q7));
    % Left leg links
    l13.plotObj(g13(q1,q2,q3,q7,q8));
    l14.plotObj(g14(q1,q2,q3,q7,q8,q9));
    l15.plotObj(g15(q1,q2,q3,q7,q9));
    l16.plotObj(g16(q1,q2,q3,q7,q8,q9));
    % The toe
    l14.traceEnd(g14(q1,q2,q3,q7,q8,q9),'.b');

    % Draw the figure
    drawnow
end % for it

end % visualizeAtrias
