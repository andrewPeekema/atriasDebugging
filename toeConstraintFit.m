% Load, plot, and fit the toe constraint data

% Cleanup
clc
clear all
close all


load('data/toeConstraint.mat')

% Expand the data
display('Expanding data...')
expandedLHip = [];
expandedRHip = [];
expandedQ    = [];
for q2i = 1:length(q2) % Boom roll
for q3i = 1:length(q3) % Boom pitch
for qli = 1:length(ql) % Virtual leg length
for qqi = 1:length(qq) % Virtual leg angle
    expandedLHip(end+1) = qLHip(q2i,q3i,qli,qqi);
    expandedRHip(end+1) = qRHip(q2i,q3i,qli,qqi);
    expandedQ(end+1,:) = [q2(q2i) q3(q3i) ql(qli) qq(qqi)];
end % Virtual leg angle
end % Virtual leg length
end % Boom pitch
end % Boom roll
display('Done expanding data')

% Fit the data
display('Fitting data...')
pLHip = polyfitn(expandedQ,expandedLHip,5);
pRHip = polyfitn(expandedQ,expandedRHip,5);
display('Done fitting data')

% TODO: Convert to symbolic expression

%{
% Plot
% data structure: qHip(q2,q3,ql,qq)
% Size: 3 29 11 314
for n = 1:29
    surf(qq,ql,squeeze(qRHip(1,n,:,:)))
    xlabel('qq')
    ylabel('ql')
    zlabel('qHip')
    drawnow
    pause(0.1)
end
%}
