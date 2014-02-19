% Find:
function vppFigure(a)
%   Plot the experimental VPP

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
figure
hold on
grid on
axis equal

% For each stance phase
for n = 1:(length(a.Timing.rtd)-offset)
    % Start and end indicies of a stance phase
    n1 = a.Timing.rtd(n);
    n2 = a.Timing.rto(n+offset);
    % The leg angle and length w.r.t. the torso
    ql = a.Kinematics.legAngles(n1:n2,2); % 1,2 --> l,r
    rl = a.Kinematics.legLength(n1:n2,2); % 1,2 --> l,r
    % Axial and tangential force
    aF = a.Dynamics.axLegForce(n1:n2,2);
    tF = a.Dynamics.tanLegForce(n1:n2,2);
    % Force angle and magnitude
    qF = tan(tF./aF);
    F  = hypot(aF,tF);
    % Foot points in torso coordinates
    x1 =  rl.*cos(ql);
    y1 = -rl.*sin(ql);
    % Force vectors from foot points in torso coordinates
    scaleF = 3/1000;
    x2 = x1 - F.*cos(ql-qF)*scaleF;
    y2 = y1 + F.*sin(ql-qF)*scaleF;

    % Plot each force vector
    for fn = 1:50:size(x1)
        plot([x1(fn) x2(fn)],[y1(fn) y2(fn)])
    end
end

% Torso
base = 0.762; % m
height = 0.762; % m
top = 0.508; % m
x = [top/2 base/2 -base/2 -top/2 top/2];
y = [height 0 0 height height];
plot(x,y,'--k')
% Center of Mass
rcom = 0.15;
plot(0,rcom,'.g','MarkerSize',30)
% Virtual Pivot Point
x = -a.ControllerData.rvpp(end)*sin(a.ControllerData.qvpp(end));
y = rcom + a.ControllerData.rvpp(end)*cos(a.ControllerData.qvpp(end));
plot(x,y,'.r','MarkerSize',30)


end % vppFigure
