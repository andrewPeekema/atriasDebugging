function groundReactionForces(a)
% Plot Fx and Fy vs time
% Input:
%   a: an ATRIASanalysis class

% Check for input
if ~exist('a')
    error('An ATRIASanalysis input variable is needed')
end

% Cleanup
clc
close all

% Start a figure
figure
hold on
grid on
title('Ground Reaction Forces')
xlabel('Time (s)')
ylabel('Force (N)')
ylim([-200 690])

% The range of values to plot
%xStart = 92.23;
%xEnd   = 93.95;
xStart = a.Timing.Time(1)/1000;
xEnd = a.Timing.Time(end)/1000;
xlim([0 xEnd-xStart])



for leg = [1 2] % left and right legs
    % Determine timing offset
    [td to offset stanceOffset] = timingAndOffset(leg);

    % Find all forces
    Fz = -a.Dynamics.Fy(:,1:2);
    % Find force zero crossings
    fZero = [abs(diff(Fz(:,leg) > 0)); 0];
    % Turn it into a logical
    fZero = fZero > 0;

    % For each stance phase
    for n = 1:(length(td)-offset-stanceOffset)
        % Controller start and end indicies of a stance phase
        n1 = td(n);
        n2 = to(n+offset);

        % If takeoff is before the start index
        if a.Timing.Time(n2) < xStart*1000
            % Skip this iteration
            continue
        % If touchdown is beyond the end index
        elseif a.Timing.Time(n1) > xEnd*1000
            % Skip this iteration
            continue
        end

        % Touchdown
        % Shift by .1 seconds forward, and then search for the
        % last zero crossing
        n1 = find(fZero(1:n1+100),1,'last');

        % Takeoff
        % Shift by .1 seconds backwards, and then search for the
        % first zero crossing
        n2 = n2+100;
        if size(fZero,1) < n2
            n2 = size(fZero,1);
        end
        n2 = n1 + 100 + find(fZero(n1+100:n2),1,'first');

        % The time
        t = a.Timing.Time(n1:n2)/1000;

        % Forces as measured through the springs
        Fx = a.Dynamics.Fx(n1:n2,leg);
        Fz = a.Dynamics.Fy(n1:n2,leg);

        % We don't want the force on the leg, we want the force on the ground
        Fx = -Fx;
        Fz = -Fz;

        % Plot the forces
        plot(t-xStart,Fx,'r')
        plot(t-xStart,Fz,'b')
    end
end % for leg


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
