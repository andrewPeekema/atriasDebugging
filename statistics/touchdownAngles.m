% Find:
%   Touchdown angles for each leg for each stride

% Remove old stats
clear stats

% Right leg
for n = 1:length(a.Timing.rtd)
    % Touchdown index
    t1 = a.Timing.rtd(n);
    % Touchdown angle
    qTD(n,2) = a.Kinematics.legAngles(t1,2);
end

% Left leg
if a.Timing.ltd(1) > a.Timing.lto(1)
    offset = 0;
else
    offset = 1;
end
for n = 1:length(a.Timing.ltd)
    % Touchdown index
    t1 = a.Timing.ltd(n);
    % Touchdown angle
    qTD(n,1) = a.Kinematics.legAngles(t1,1);
end

% Compile Statistics
stats.q1LMean = mean(qTD(:,1));
stats.q1LStd  = std(qTD(:,1));
stats.q1RMean = mean(qTD(:,2));
stats.q1RStd  = std(qTD(:,2));
stats.q1      = a.ControllerData.q1(1,1);
stats.q2      = a.ControllerData.q2(1,1);
stats.q3      = a.ControllerData.q3(1,1);
stats.q4      = a.ControllerData.q4(1,1);
