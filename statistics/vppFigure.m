% Find:
%   The experimental VPP

% Cleanup
clc
close all

% TODO: Left and right legs

% If the first touchdown comes before the first takeoff
if a.Timing.rtd(1) > a.Timing.rto(1)
    % Don't do anything
    offset = 0;
else
    % Touchdown first
    offset = 1;
end

% Make a figure for force vectors
% TODO: Torso, CoM, control VPP
figure
hold on
grid on

% For each stance phase
for n = 1:(length(a.Timing.rtd)-offset)
    % Start and end indicies of a stance phase
    n1 = a.Timing.rtd(n);
    n2 = a.Timing.rto(n+offset);
    % The leg angle and length w.r.t. the torso
    ql = a.Kinematics.legAngles(n1:n2,2); % 1,2 --> l,r
    rl = a.Kinematics.legLength(n1:n2,2); % 1,2 --> l,r
    % Axial and tangential force
    aF = a.Dynamics.axLegForce(n1:n2,2);   % TODO: Check positive and negative convention
    tF = a.Dynamics.tanLegForce(n1:n2,2);  % TODO: Check positive and negative convention
    % Force angle and magnitude
    qF = tan(tF./aF);
    F  = hypot(aF,tF);
    % Foot points in torso coordinates
    x1 =  rl.*cos(ql);
    y1 = -rl.*sin(ql);
    % Force vectors from foot points in torso coordinates
    scaleF = 4/1000;
    x2 = x1 - F.*cos(ql-qF)*scaleF;
    y2 = y1 + F.*sin(ql-qF)*scaleF;

    % Plot each force vector
    for fn = 1:50:size(x1)
        plot([x1(fn) x2(fn)],[y1(fn) y2(fn)])
    end
end
