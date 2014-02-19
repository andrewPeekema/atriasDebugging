% Find:
%   duty cycle

% Remove old stats
clear stats

% Find VLO
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

%% Find the duty cycle
% stance == TD -> TO
% flight == TO -> TD

% Right leg
% Order the transitions
rightTransitions = sort([a.Timing.rto; a.Timing.rtd]);
% Get the time durations
rightDurations = diff(a.Timing.Time(rightTransitions));

% Stance or flight first?
if a.Timing.rto(1) < a.Timing.rtd(1)
    % Flight first
    rightFlightDurations = rightDurations(1:2:end);
    rightStanceDurations = rightDurations(2:2:end);
else
    % Stance first
    rightFlightDurations = rightDurations(2:2:end);
    rightStanceDurations = rightDurations(1:2:end);
end

% Find the shorter vector
if length(rightFlightDurations) > length(rightStanceDurations)
    n = length(rightStanceDurations);
else
    n = length(rightFlightDurations);
end

% Duty cycle
rightDutyCycle = rightStanceDurations(1:n)./...
                (rightStanceDurations(1:n)+rightFlightDurations(1:n));

% Left leg
% Order the transitions
leftTransitions = sort([a.Timing.lto; a.Timing.ltd]);
% Get the time durations
leftDurations = diff(a.Timing.Time(leftTransitions));

% Stance or flight first?
if a.Timing.lto(1) < a.Timing.ltd(1)
    % Flight first
    leftFlightDurations = leftDurations(1:2:end);
    leftStanceDurations = leftDurations(2:2:end);
else
    % Stance first
    leftFlightDurations = leftDurations(2:2:end);
    leftStanceDurations = leftDurations(1:2:end);
end

% Find the shorter vector
if length(leftFlightDurations) > length(leftStanceDurations)
    n = length(leftStanceDurations);
else
    n = length(leftFlightDurations);
end

% Duty cycle
leftDutyCycle = leftStanceDurations(1:n)./...
                (leftStanceDurations(1:n)+leftFlightDurations(1:n));

% Compile statistics
stats.lDutyCycleMean = mean(leftDutyCycle);
stats.lDutyCycleStd  = std(leftDutyCycle);
stats.rDutyCycleMean = mean(rightDutyCycle);
stats.rDutyCycleStd  = std(rightDutyCycle);
stats.DutyCycleMean  = mean([leftDutyCycle rightDutyCycle]);
stats.DutyCycleStd   = std([leftDutyCycle rightDutyCycle]);
