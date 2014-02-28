function toeTrajectory(a)
% Plot the toe trajectory with respect to the body, factoring in body pitch
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

%% The ideal trajectory
% Gait parameters for the SLIP walk paper gait
r0 = 0.9;   % m
rRet = 0.15; % m
q1 = 1.144; % rad
q2 = 1.297; % rad
q3 = 1.845; % rad
q4 = 1.998; % rad

% Fake a stance phase
qSl = linspace(q2,q3,50);
% Needs to be able to handle between 0 and 1 rad/s (if 1 m/s, then 1 rad/s)
dqSl = ones(1,length(qSl))*1;

% The robot "position"
s = (qSl - q2)/(q3 - q2);
ds = dqSl;%/(q3-q2);

% Original SLIP walk
for n = 1:length(s)
    % Leg angle
    [qm(n) dqm(n)] = cubicInterp(0, 0.90, q4, q1, -0.5, 1.0, s(n), ds(n));
    % Leg length
    if s(n) < 0.5
        [rm(n) drm(n)] = cubicInterp(0, 0.5, r0, r0-rRet, -1.0, 0, s(n), ds(n));
    else
        [rm(n) drm(n)] = cubicInterp(0.5, 0.9, r0-rRet, r0, 0, 0, s(n), ds(n));
    end
end

% Translate distances and angles to x and y
x = rm.*cos(qm);
y = -rm.*sin(qm);

% Ideal toe trajectory
subplot(2,1,1)
plot(x,y,'k')
title('Left Toe Trajectory')
subplot(2,1,2)
plot(x,y,'k')
title('Right Toe Trajectory')


%% The experimental trajectory
for leg = [1 2] % left and right legs
    % Left leg on the top plot, right leg on the bottom
    subplot(2,1,leg)
    hold on; grid on; axis equal;
    xlabel('X Position (m)')
    ylabel('Z Position (m)')
    xlim([-0.5 0.5])
    % Leg angle and length w.r.t. the torso
    ql = a.Kinematics.legAngles(:,leg);
    rl = a.Kinematics.legLength(:,leg);
    qb = a.Kinematics.bodyPitch(:,1)-3*pi/2;

    % Correct for torso pitch
    ql = ql + qb;

    % Polar to cartesian coordinates
    x =  rl.*cos(ql);
    y = -rl.*sin(ql);

    % Robot toe trajectory
    plot(x,y,'r')
end % for leg

end % toeTrajectory
