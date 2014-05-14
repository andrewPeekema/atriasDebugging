% Plot the toe trajectory with respect to the body, factoring in body pitch

% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = '/Users/andrew/Desktop/atrias_2014-05-14-14-12-14.mat';
[c rs cs] = logfileToStruct(filePath);

rs = shortenData(rs,[32310:35800]);

% Start a figure
figure

%% The ideal trajectory
% Gait parameters for the SLIP walk paper gait
r0 = 0.9;   % m
rRet = 0.15; % m
q1 = cs.q1(1); % rad
q2 = cs.q2(1); % rad
q3 = cs.q3(1); % rad
q4 = cs.q4(1); % rad

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
    % Motor angle and length w.r.t. the torso
    if leg == 1
        qm = rs.qLm;
        rm = rs.rLm;
    else
        qm = rs.qRm;
        rm = rs.rRm;
    end

    % Torso angle
    qb = rs.qb-3*pi/2;

    % Correct motor angle for torso pitch
    qm = qm + qb;

    % Polar to cartesian coordinates
    x =  rm.*cos(qm);
    y = -rm.*sin(qm);

    % Robot toe trajectory
    plot(x,y,'r')
end % for leg
