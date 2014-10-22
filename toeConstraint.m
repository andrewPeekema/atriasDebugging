function toeConstraint
% Solve for hip angles given the rest of the angles and a constraint cylinder

% Get the toe equations
[lToeXyz,rToeXyz] = toeConstraintEquations;

% Set left and right radii
lR = 2.197; % initial guess [m]
rR = 1.833; % initial guess [m]

% Angle and length discritization
angleD = deg2rad(1); % [rad]
linD   = 0.01; % [m]

% Angle ranges
q1 = 0; % Boom yaw
q2 = linspace(0, 0.2, floor((0.2-0)/angleD)); % Boom roll
q3 = linspace(-pi/4, pi/4, floor((pi/4+pi/4)/angleD)); % Boom pitch
% Virtual leg length and angle
ql = linspace(0.4, 0.99, floor((0.99-0.4)/angleD));
qq = linspace(pi/2, 3*pi/2, floor((3*pi/2-pi/2)/linD));
% q4, q7: Unknown right and left hip angles (respectively)

% Preallocate qHip
qLHip = NaN(length(q2),length(q3),length(ql),length(qq));
qRHip = NaN(length(q2),length(q3),length(ql),length(qq));

% fmincon options
options = optimoptions('fmincon','Display','notify-detailed');



% Iterate over the states
tic
for q2i = 1:length(q2) % Boom roll
display(['q2i: ' num2str(q2i)]);
toc

parfor q3i = 1:length(q3) % Boom pitch

% Preallocate
qLHipTemp = NaN(length(ql),length(qq));
qRHipTemp = NaN(length(ql),length(qq));

for qli = 1:length(ql) % Virtual leg length
for qqi = 1:length(qq) % Virtual leg angle

    % Solve for link angles using the virtual leg angle and length
    q5 = qq(qqi) - acos(ql(qli)); % Right leg A
    q6 = qq(qqi) + acos(ql(qli)); % Right leg B
    q8 = q5; % Left leg A
    q9 = q6; % Left leg B

    % Numerically solve for the hip angles given bounds
    qLHipTemp(qli,qqi) = fmincon(@(q7)lHipEquation(q1,q2(q2i),q3(q3i),q7,q8,q9,lToeXyz,lR),0,[1;-1],[pi/2 pi/2],[],[],[],[],[],options);
    qRHipTemp(qli,qqi) = fmincon(@(q4)rHipEquation(q1,q2(q2i),q3(q3i),q4,q5,q6,rToeXyz,rR),0,[1;-1],[pi/2 pi/2],[],[],[],[],[],options);

end % Virtual leg angle
end % Virtual leg length

% Save the hip angles
qLHip(q2i,q3i,:,:) = qLHipTemp;
qRHip(q2i,q3i,:,:) = qRHipTemp;

end % Boom pitch
end % Boom roll


% Save the hip angles, the states that were iterated over, and the constraint radii
save('data/toeConstraint.mat',qLHip,qRHip,q1,q2,q3,ql,qq,lR,rR)


function lDelta = lHipEquation(x1,x2,x3,x7,x8,x9,lToeXyz,lR)
    % Solve for the xyz foot placement
    lXyz = lToeXyz(x1,x2,x3,x7,x8,x9);
    % Solve for how far away the foot is from the cylinder constraint (x^2+y^2=r^2)
    lDelta = (lXyz(1)^2 + lXyz(2)^2 - lR^2)^2;
end

function rDelta = rHipEquation(x1,x2,x3,x4,x5,x6,rToeXyz,rR)
    % Solve for the xyz foot placement
    rXyz = rToeXyz(x1,x2,x3,x4,x5,x6);
    % Solve for how far away the foot is from the cylinder constraint (x^2+y^2=r^2)
    rDelta = (rXyz(1)^2 + rXyz(2)^2 - rR^2)^2;
end

end % toeConstraint
