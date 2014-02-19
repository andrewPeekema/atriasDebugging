% Find:
%   Peak force for each leg during each stride

% Remove old stats
clear stats

% VLO occurs during single support
% Right leg
if a.Timing.rtd(1) > a.Timing.rto(1)
    offset = 0;
else
    offset = 1;
end
for n = 1:(length(a.Timing.rtd)-offset)
    % Takeoff and touchdown indicies
    t1 = a.Timing.rto(n);
    t2 = a.Timing.rtd(n+offset);
    % Vertical leg orientation is at pi/2
    tmp = abs(a.Kinematics.legAngles(t1:t2,2)-pi/2);
    [~,tmpN] = min(tmp);
    % Index
    nRApex(n) = tmpN + t1;
end

% Left leg
if a.Timing.ltd(1) > a.Timing.lto(1)
    offset = 0;
else
    offset = 1;
end
for n = 1:(length(a.Timing.ltd)-offset)
    % Height
    t1 = a.Timing.lto(n);
    t2 = a.Timing.ltd(n+offset);
    % Vertical leg orientation is at pi/2
    tmp = abs(a.Kinematics.legAngles(t1:t2,1)-pi/2);
    [~,tmpN] = min(tmp);
    % Index
    nLApex(n) = tmpN + t1;
end

%% Peak force mean and standard deviation
% Left leg
for n = 1:(length(nLApex)-1)
    % Find the maximum vertical force
    fyLMax(n) = min(a.Dynamics.Fy(nLApex(n):nLApex(n+1),1));
end
% Right leg
for n = 1:(length(nRApex)-1)
    % Find the maximum vertical force
    fyRMax(n) = min(a.Dynamics.Fy(nRApex(n):nRApex(n+1),2));
end
% This should not be negative
fyLMax = -fyLMax;
fyRMax = -fyRMax;
% Compile Statistics
stats.fyLMaxMean = mean(fyLMax);
stats.fyLMaxStd  = std(fyLMax);
stats.fyRMaxMean = mean(fyRMax);
stats.fyRMaxStd  = std(fyRMax);
stats.fyMaxMean  = mean([fyLMax fyRMax]);
stats.fyMaxStd   = std([fyLMax fyRMax]);
