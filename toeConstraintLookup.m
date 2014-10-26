% Test the interp function on derived data

% Cleanup
clc
clear all
close all

% The hip angle data
load('data/toeConstraint.mat')

% Plot
for n = 1:length(q3)
    % A point to interpolate to ([q2 q3 ql qq])
    state = [0.05 q3(n) 0.8 pi];
    % Get interpolated hip values
    q4Interp(n) = linInterp4(state,qRHip,q2,q3,ql,qq);
    q7Interp(n) = linInterp4(state,qLHip,q2,q3,ql,qq);
    % Save the states
    q5(n) = state(4) - acos(state(3));
    q6(n) = state(4) + acos(state(3));
    q8(n) = q5(n);
    q9(n) = q6(n);
end

% Plot the virtual constraints
% Left foot
r = lR;
x = -r:0.001:r;
y = (r^2-x.^2).^0.5;
x = [x  flip(x)];
y = [y -y];
plot3(x,y,0*x,'c');
hold on
% Right foot
r = rR;
x = -r:0.001:r;
y = (r^2-x.^2).^0.5;
x = [x  flip(x)];
y = [y -y];
plot3(x,y,0*x,'m');

% Make ATRIAS move through the states
visualizeAtrias(zeros(size(q3)),state(1)*ones(size(q3)),q3,q4Interp,q5,q6,q7Interp,q8,q9,1:length(q3))
