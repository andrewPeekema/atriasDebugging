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
ylim([-200 700])

% Find all forces
Fx = -a.Dynamics.Fx(:,1:2);
Fz = -a.Dynamics.Fy(:,1:2);

% Get the time (s)
t = a.Timing.Time/1000;


% For each event, search forward and backward
% for first zero crossing.  Use that index as the takeoff or touchdown.


for leg = [1 2] % left and right legs
    % Determine timing offset
    [td to offset stanceOffset] = timingAndOffset(leg);

    % For each stance phase
    for n = 1:(length(td)-offset-stanceOffset)
        % Find stance and flight triggers
        % TODO: Search forwards

        % Start and end indicies of a stance phase
        n1 = td(n);
        n2 = to(n+offset);

        % The time
        t = a.Timing.Time(n1:n2)/1000;

        % Forces as measured through the springs
        Fx = a.Dynamics.Fx(n1:n2,leg);
        Fz = a.Dynamics.Fy(n1:n2,leg);

        % We don't want the force on the leg, we want the force on the ground
        Fx = -Fx;
        Fz = -Fz;

        % Plot the forces
        plot(t,Fx,'r')
        plot(t,Fz,'b')
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
