% Find:
%   peak force
%   duty cycle
%   apex height
%   apex velocity

% Remove old stats
clear stats

% Open the data
%a = analyseATRIAS;
%load('atrias_2014-02-03-19-57-30-analyzeATRIAS-long')

%% Find the apex height and velocity
% Apex occurs during single support
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
    % Index, height, and leg angle
    nRApex(n) = tmpN + t1;
    yRApex(n) = a.Kinematics.legLength(nRApex(n),2);
    qRApex(n) = a.Kinematics.legAngles(nRApex(n),2);
    % Velocity
    dx = a.Kinematics.velocity(nRApex(n),1);
    dy = a.Kinematics.velocity(nRApex(n),2);
    vRApex(n) = hypot(dx,dy);
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
    tmp = abs(a.Kinematics.legAngles(t1:t2,2)-pi/2);
    [~,tmpN] = min(tmp);
    % Index, height, and leg angle
    nLApex(n) = tmpN + t1;
    yLApex(n) = a.Kinematics.legLength(nLApex(n),2);
    qLApex(n) = a.Kinematics.legAngles(nLApex(n),2);
    % Velocity
    dx = a.Kinematics.velocity(nLApex(n),1);
    dy = a.Kinematics.velocity(nLApex(n),2);
    vLApex(n) = hypot(dx,dy);
end

%figure
%plot(a.Kinematics.position(:,2))
%hold on
%plot(nRApex,a.Kinematics.position(nRApex,2),'*r')
%plot(nLApex,a.Kinematics.position(nLApex,2),'*g')

% Mean and standard deviation
stats.yApexMean = mean([yLApex yRApex]);
stats.yApexStd  = std([yLApex yRApex]);
stats.vApexMean = mean([vLApex vRApex]);
stats.vApexStd  = std([vLApex vRApex]);


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
stats.fyRMaxMean = mean(fyRMax);
stats.fyLMaxStd = std(fyLMax);
stats.fyRMaxStd = std(fyRMax);

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
