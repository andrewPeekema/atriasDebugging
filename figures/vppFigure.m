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

    % Initialize the force point vectors
    X1 = [];
    X2 = [];
    Y1 = [];
    Y2 = [];
    Ftot = [];

    % For each stance phase
    for n = 1:(length(td)-offset-stanceOffset)
        % Start and end indicies of a stance phase
        n1 = td(n);
        n2 = to(n+offset);
        % The leg angle and length w.r.t. the torso
        ql = a.Kinematics.legAngles(n1:n2,leg);
        rl = a.Kinematics.legLength(n1:n2,leg);

        %% Applied forces
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

        % Save the applied forces for determining the VPP later
        X1(end+1:end+length(x1))  = x1;
        Y1(end+1:end+length(y1))  = y1;
        X2(end+1:end+length(x2))  = x2;
        Y2(end+1:end+length(y2))  = y2;
        Ftot(end+1:end+length(F)) = F;


        %% Desired forces
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
    if leg == 1
        title('Left Leg VPP')
    else
        title('Right Leg VPP')
    end
    xlabel('Distance (m)')
    ylabel('Distance (m)')
    ylim([-1 1.4])

    % Determine the virtual pivot point from the applied forces
    % (X1, Y1), (X2, Y2), Ftot
    options = optimset(...
        'TolX',1e-18,...
        'TolFun',1e-18,...
        'MaxFunEvals',600,...
        'UseParallel','always',...
        'Display','iter');
    %    'Display','none');
    % VPP guess is the desired VPP
    guess = [x; y];
    vpp = fminsearch(@momentSquared,guess,options);
    % Plot the true vpp
    p(5) = plot(vpp(1),vpp(2),'.g','MarkerSize',40);
    % Feedback
    % TODO: Convert to polar coordinates
    %{
    if leg == 1 % Left leg
        display(['Left Leg r VPP: ' num2str(vpp(1)))]);
    else
    %}

end % for leg

% Labeling
legend(p,'Applied Force','Desired Force','CoM','Desired VPP','True VPP','Location','Best')



% Find the moment applied about the given coordinates x,y
function result = momentSquared(Guess)
    % Guess vpp coordinates
    x = Guess(1);
    y = Guess(2);

    % The shortest distance between the VPP coordinates and each force vector
    % as defined by (X1, Y1) and (X2, Y2)
    DX = X2 - X1;
    DY = Y2 - Y1;
    d  = abs(DY*x - DX*y - X1.*Y2 + X2.*Y1)./hypot(DX,DY);

    % The moment squared
    result = sum((Ftot.*d).^2);
end % momentSquared

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
