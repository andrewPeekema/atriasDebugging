% Test the interp function

% Cleanup
clc
clear all
close all

% Variable ranges
Rx = [0:0.5:10];
Ry = [0:0.5:10];
Rz = [0:0.5:10];

% Filler values
values = NaN(length(Rx),length(Ry),length(Rz));
for xi = 1:length(Rx)
for yi = 1:length(Ry)
for zi = 1:length(Rz)
    values(xi,yi,zi) = 20;
end
end
end

% Target point
I = [1 1.2 0.7];

% Get the interpolated value
value = linInterp4(I,values,Rx,Ry,Rz)

%{
% The hip angle data
load('data/toeConstraint.mat')

% Plot
% data structure: qHip(q2,q3,ql,qq)
% Size: 3 29 11 314
for n = 1:29
    surf(qq,ql,squeeze(qLHip(1,n,:,:)))
    xlabel('qq')
    ylabel('ql')
    zlabel('qHip')
    drawnow
    pause(0.1)
end
%}
