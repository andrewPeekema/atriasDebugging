% Solve for hip angles given the rest of the angles and a constraint cylinder

% Get the toe equations
[lToeXyz,rToeXyz] = toeConstraintEquations;

% Set left and right radii
lR = 2.197; % initial guess [m]
rR = 1.833; % initial guess [m]

% TODO: Wrap the below lines in a loop over the state angles and save qHip in a
% matrix indexed by the state angles

% Angles
q1 = 0; % Boom yaw
q2 = 0.1; % Boom roll
q3 = 0.2; % Boom pitch
%q4 = 0; % Right hip angle
q5 = 3*pi/4; % Right leg A
q6 = 5*pi/4; % Right leg B
%q7 = 0; % Left hip angle
q8 = 3*pi/4; % Left leg A
q9 = 5*pi/4; % Left leg B
syms q4 q7 real; % The hip angles are unknown

% Left toe
% Get equations for the toe position in terms of the hip angle
lXyz = lToeXyz(q1,q2,q3,q7,q8,q9);
rXyz = rToeXyz(q1,q2,q3,q4,q5,q6);

% Constrain the toe to a cylinder (x^2+y^2=r^2)
lEqn = matlabFunction(lXyz(1)^2 + lXyz(2)^2 - lR^2);
rEqn = matlabFunction(rXyz(1)^2 + rXyz(2)^2 - rR^2);

% Numerically solve for the hip angles
qLHip = fsolve(lEqn,0);
qRHip = fsolve(lEqn,0);
