function vppFigure(a)
% Plot the experimental VPP
% Input:
%   a: an ATRIASanalysis class

% Check for input
if ~exist('a')
    error('An ATRIASanalysis input variable is needed')
end

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
    [td to offset stanceOffset] = timingAndOffset(leg);

    % For each stance phase
    for n = 1:(length(td)-offset-stanceOffset)
        % Start and end indicies of a stance phase
        n1 = td(n);
        n2 = to(n+offset);
        % The leg angle and length w.r.t. the torso
        ql = a.Kinematics.legAngles(n1:n2,leg);
        rl = a.Kinematics.legLength(n1:n2,leg);

        % Applied forces
        % Axial and tangential force
        aF = a.Dynamics.axLegForce(n1:n2,leg);
        tF = a.Dynamics.tanLegForce(n1:n2,leg);
        % Force angle and magnitude
        qF = atan(tF./aF);
        F  = hypot(aF,tF);
        % Foot points in torso coordinates
        x1 =  rl.*cos(ql);
        y1 = -rl.*sin(ql);
        % Force vectors from foot points in torso coordinates
        scaleF = 3/1000;
        x2 = x1 - F.*cos(ql-qF)*scaleF;
        y2 = y1 + F.*sin(ql-qF)*scaleF;

        % Plot each force vector
        for fn = 1:30:size(x1)
            p(1) = plot([x1(fn) x2(fn)],[y1(fn) y2(fn)]);
        end

        % Desired forces
        Fx = -a.ControllerData.controlFx((n1:n2),leg);
        Fz = -a.ControllerData.controlFz((n1:n2),leg);
        % Body pitch from vertical
        qB = a.Kinematics.bodyPitch(n1:n2,1) - 3*pi/2;
        % Force angle and magnitude (global)
        qF = atan(Fz./Fx);
        % Correct quadrant issue
        for n = 1:length(qF)
            if qF(n) < 0
                qF(n) = pi + qF(n);
            end
        end
        F = hypot(Fx,Fz);
        % Force vectors from foot points in torso coordinates
        x2 = x1 + F.*cos(qF+qB)*scaleF;
        y2 = y1 + F.*sin(qF+qB)*scaleF;

        % Plot each force vector
        for fn = 1:30:size(x1)
            p(2) = plot([x1(fn) x2(fn)],[y1(fn) y2(fn)],'g');
        end

        % Plot the first footpoint
        plot(x1(1),y1(1),'r.')
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
    p(3) = plot(0,rcom,'.k','MarkerSize',40);
    % Virtual Pivot Point
    x = -a.ControllerData.rvpp(end)*sin(a.ControllerData.qvpp(end));
    y = rcom + a.ControllerData.rvpp(end)*cos(a.ControllerData.qvpp(end));
    p(4) = plot(x,y,'.r','MarkerSize',40);

    % Plot options
    title('Virtual Pivot Point')
    xlabel('Distance (m)')
    ylabel('Distance (m)')
    ylim([-1 1.4])

end % for leg

% Labeling
legend(p,'Applied Force','Desired Force','CoM','VPP','Location','Best')


% Time touchdown and takeoff correctly
function [td to offset stanceOffset] = timingAndOffset(leg)
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

    % If there are more touchdowns than takeoffs
    if length(td) > length(to)
        stanceOffset = 1;
    else
        stanceOffset = 0;
    end
end % timingAndOffset

end % vppFigure
