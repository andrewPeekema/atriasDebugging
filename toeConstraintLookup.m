% Test the interp function

% Cleanup
clc
clear all
close all

% Variable ranges
R1 = [0:0.5:10];
R2 = [0:0.5:10];
R3 = [0:0.5:10];

% Filler values
values = NaN(length(R1),length(R2),length(R3));
for ia = 1:length(R1)
for ib = 1:length(R2)
for ic = 1:length(R3)
    values(ia,ib,ic) = 25;
end
end
end

% Target point
I = [1 1.2 0.7];

% Get the interpolated value
value = linInterp4(I,values,R1,R2,R3)

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
