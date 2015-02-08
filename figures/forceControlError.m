function forceControlError(a)
% Plot the desired force and applied force in torso coordinates
% Input:
%   a: an ATRIASanalysis class

% Check for input
if ~exist('a')
    error('An ATRIASanalysis input variable is needed')
end

% Cleanup
clc
close all

% Make a figure
figure
hold on
grid on


for leg = [1 2] % left and right legs
    % Determine timing offset
    [td to offset stanceOffset] = timingAndOffset(leg);


    % For each stance phase
    for n = 1:(length(td)-offset-stanceOffset)
        % Start and end indicies of a stance phase
        n1 = td(n);
        n2 = to(n+offset);

        %% Applied forces
        % Horizontal force and vertical force
        Fx_applied = -a.Dynamics.Fx(n1:n2,leg);
        Fy_applied = -a.Dynamics.Fy(n1:n2,leg);

        %% Desired forces
        Fx = -a.ControllerData.controlFx((n1:n2),leg);
        Fz = -a.ControllerData.controlFz((n1:n2),leg);

        plot(n1:n2,Fx_applied,'r')
        plot(n1:n2,Fy_applied,'b')
        plot(n1:n2,Fx,'r--')
        plot(n1:n2,Fz,'b--')
    end

end % for leg

% Labeling
%legend(p,'Applied Force','Desired Force','CoM','Desired VPP','True VPP','Location','Best')


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
