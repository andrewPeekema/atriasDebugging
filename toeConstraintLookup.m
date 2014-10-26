% Test the interp function on derived data

% Cleanup
clc
clear all
close all

% The hip angle data
load('data/toeConstraint.mat')

% The current state
% state = [q2 q3 ql qq]
%state = [0.055 0.55 0.8 2.5];
%state = [q2(2) q3(15) 0.8 2.5];

% Plot
% data structure: qHip(q2,q3,ql,qq)
% Size: 3 29 11 314
for n = 1:29
%for n = 10
    surf(qq,ql,squeeze(qLHip(1,n,:,:)))
    % A point to interpolate to ([q2 q3 ql qq])
    state = [q2(1) q3(n) 0.8 2.5];
    % Get an interpolated value
    qInterp = linInterp4(state,qLHip,q2,q3,ql,qq);
    hold on
    state(3)
    state(4)
    plot3(state(4), state(3), qInterp,'-mo','MarkerSize',15)
    xlabel('qq')
    ylabel('ql')
    zlabel('qHip')
    drawnow
    hold off
    pause(0.1)
end
