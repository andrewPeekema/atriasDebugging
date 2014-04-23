% Find:
%   Vertical Leg Orientation height
%   Vertical Leg Orientation velocity

% Cleanup
clc
close all
clearvars -except a % Keep only the analyzeATRIAS variable

%% Find the VLO height and velocity
% Apex occurs during single support
%% Right leg
td = a.Timing.rtd;
to = a.Timing.rto;
% If we takeoff before we touchdown
if to(1) < td(1)
    % Remove the first takeoff
    to = to(2:end);
end
% If the last touchdown never takes off
if td(end) > to(end)
    % Remove the last touchdown
    td = td(1:end-1);
end
% For each touchdown to takeoff
for n = 1:length(td)
    % Start and end indicies
    t1 = td(n);
    t2 = to(n);
    % Vertical leg orientation is at pi/2
    tmp = abs(a.Kinematics.legAngles(t1:t2,2)-pi/2);
    [~,tmpN] = min(tmp);
    % Index, height, and leg angle
    nRApex(n) = tmpN + t1;
    yRApex(n) = a.Kinematics.position(nRApex(n),2);
    rRApex(n) = a.Kinematics.legLength(nRApex(n),2);
    qRApex(n) = a.Kinematics.legAngles(nRApex(n),2);
    % Velocity
    dx = a.Kinematics.velocity(nRApex(n),1);
    dy = a.Kinematics.velocity(nRApex(n),2);
    vRApex(n) = hypot(dx,dy);
end

%% Left leg
td = a.Timing.ltd;
to = a.Timing.lto;
% If we takeoff before we touchdown
if to(1) < td(1)
    % Remove the first takeoff
    to = to(2:end);
end
% If the last touchdown never takes off
if td(end) > to(end)
    % Remove the last touchdown
    td = td(1:end-1);
end
% For each touchdown to takeoff
for n = 1:length(td)
    % Start and end indicies
    t1 = td(n);
    t2 = to(n);
    % Vertical leg orientation is at pi/2
    tmp = abs(a.Kinematics.legAngles(t1:t2,1)-pi/2);
    [~,tmpN] = min(tmp);
    % Index, height, and leg angle
    nLApex(n) = tmpN + t1;
    yLApex(n) = a.Kinematics.position(nLApex(n),2);
    rLApex(n) = a.Kinematics.legLength(nLApex(n),1);
    qLApex(n) = a.Kinematics.legAngles(nLApex(n),1);
    % Velocity
    dx = a.Kinematics.velocity(nLApex(n),1);
    dy = a.Kinematics.velocity(nLApex(n),2);
    vLApex(n) = hypot(dx,dy);
end

%figure
%plot(a.Kinematics.position(:,2)) % Vertical position
%hold on
%plot(nRApex,a.Kinematics.position(nRApex,2),'*r')
%plot(nLApex,a.Kinematics.position(nLApex,2),'*g')

% Height and velocity mean and standard deviation
stats.yLApexMean = mean(yLApex);
stats.yLApexStd  = std(yLApex);
stats.yRApexMean = mean(yRApex);
stats.yRApexStd  = std(yRApex);
stats.yApexMean  = mean([yLApex yRApex]);
stats.yApexStd   = std([yLApex yRApex]);

stats.vLApexMean = mean(vLApex);
stats.vLApexStd  = std(vLApex);
stats.vRApexMean = mean(vRApex);
stats.vRApexStd  = std(vRApex);
stats.vApexMean  = mean([vLApex vRApex]);
stats.vApexStd   = std([vLApex vRApex]);

%{
% TODO: Finish energy calculations
% VLO Energy
addpath('./..') % for legForce()
% E = 1/2*m*v^2 + m*g*h + 1/2*k*Dx^2
% Spring potential energy
r  = rRApex;
%r = a.Kinematics.legLength(1:end,2);
r0 = 0.9; % TODO: a.ControllerData.r0(end);
display('WARNING: Using a fixed r0.  This is a hack')
Dx = r0-r
%plot(Dx)
k  = legForce(r, r0)./Dx;
PEs = 1/2*k.*Dx.^2;
%}

display(stats)
