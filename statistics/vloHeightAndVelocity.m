% Find:
%   Vertical Leg Orientation height
%   Vertical Leg Orientation velocity

% Remove old stats
clear stats

%% Find the VLO height and velocity
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
    tmp = abs(a.Kinematics.legAngles(t1:t2,1)-pi/2);
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
stats.yLApexMean = mean(yLApex);
stats.yLApexStd  = std(yLApex);
stats.yRApexMean = mean(yRApex);
stats.yRApexStd  = std(yRApex);
stats.yApexMean = mean([yLApex yRApex]);
stats.yApexStd  = std([yLApex yRApex]);

stats.vLApexMean = mean(vLApex);
stats.vLApexStd  = std(vLApex);
stats.vRApexMean = mean(vRApex);
stats.vRApexStd  = std(vRApex);
stats.vApexMean = mean([vLApex vRApex]);
stats.vApexStd  = std([vLApex vRApex]);

display(stats)
