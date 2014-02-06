% Find:
%   peak force
%   duty cycle
%   apex height
%   apex velocity


% Open the data
%a = analyseATRIAS;
load('atrias_2014-02-03-19-57-30-analyzeATRIAS-long')

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
stats.fyLMax = -fyLMax;
stats.fyRMax = -fyRMax;
stats.fyLMaxMean = mean(fyLMax);
stats.fyRMaxMean = mean(fyRMax);
stats.fyLMaxStd = std(fyLMax);
stats.fyRMaxStd = std(fyRMax);


% Find the duty cycle

