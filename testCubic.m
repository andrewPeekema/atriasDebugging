clc
clear all
close all

% Gait parameters for dx = 1m/s, k = 12000 N/m
r0 = 0.9;   % m
rRet = 0.20; % m
q1 = 1.261; % rad
q2 = 1.456; % rad
q3 = 1.686; % rad
q4 = pi-q1; % rad

% Fake a stance phase
qSl = linspace(q2,q3,25);
% Needs to be able to handle between 0 and 1 rad/s (if 1 m/s, then 1 rad/s)
dqSl = ones(1,length(qSl))*1;

% The robot "position"
s = (qSl - q2)/(q3 - q2);
ds = dqSl;%/(q3-q2);

% Currently coded
%% For each instance in time
%for n = 1:length(s)
%    % Leg angle
%    [qm(n) dqm(n)] = cubicInterp(0, 0.90, q4, q1,-0.3, 0.3, s(n), ds(n));
%    % Leg length
%    if s(n) < 0.5
%        [rm(n) drm(n)] = cubicInterp(0, 0.5, r0, r0-rRet, -0.5, 0, s(n), ds(n));
%    elseif s(n) >= 0.5
%        [rm(n) drm(n)] = cubicInterp(0.5, 0.9, r0-rRet, r0, 0, 0, s(n), ds(n));
%    end
%end
% For each instance in time
for n = 1:length(s)
    % Leg angle
    [qm(n) dqm(n)] = cubicInterp(0, 0.90, q4, q1, 1.0, 1.0, s(n), ds(n));
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

% Plot
plot(0,0,'*') % Point of rotation
hold on
plot(x,y,'.') % Toe trajectory

display(drm)
display(dqm)
