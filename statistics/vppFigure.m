% Find:
function vppFigure(a)
% Plot the experimental VPP
% Input:
%   a: an ATRIASanalysis class

% Cleanup
clc
close all

% Make a figure for force vectors
figure

for leg = [1 2] % left and right legs
    % Left leg on the left plot, right leg on the right
    subplot(1,2,leg)
    hold on
    grid on
    axis equal

    % Determine timing offset
    [td to offset] = timingAndOffset(leg);

    % For each stance phase
    for n = 1:(length(td)-offset)
        % Start and end indicies of a stance phase
        n1 = td(n);
        n2 = to(n+offset);
        % The leg angle and length w.r.t. the torso
        ql = a.Kinematics.legAngles(n1:n2,leg);  % TODO: check left-right convention
        rl = a.Kinematics.legLength(n1:n2,leg);
        % Axial and tangential force
        aF = a.Dynamics.axLegForce(n1:n2,leg);
        tF = a.Dynamics.tanLegForce(n1:n2,leg);
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

end % for leg


% Time touchdown and takeoff correctly
function [td to offset] = timingAndOffset(leg)
    if leg == 1 % left leg
        td = a.Timing.ltd;
        to = a.Timing.lto;
    elseif leg == 2 % right leg
        td = a.Timing.rtd;
        to = a.Timing.rto;
    end

    % If the first touchdown comes before the first takeoff
    if td(1) < to(1)
        % Don't do anything
        offset = 0;
    else
        % Touchdown first
        offset = 1;
    end
end % timingAndOffset

end % vppFigure
