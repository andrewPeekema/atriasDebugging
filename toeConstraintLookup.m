% Test the interp function

% Cleanup
clc
clear all
close all

% Variable ranges
R1 = [0:0.5:1];
R2 = [0:0.5:10];
R3 = [0:0.5:12];
R4 = [0:0.5:15];

% Filler values
values = NaN(length(R1),length(R2),length(R3),length(R4));
for ia = 1:length(R1)
for ib = 1:length(R2)
for ic = 1:length(R3)
for id = 1:length(R4)
    values(ia,ib,ic,id) = ia+ib+ic+id;
end
end
end
end

% Target point
I = [1 1 6.2 3.2];

% Get the interpolated value
%value = linInterp4(I,values,R1,R2,R3,R4)
%value = interpn(R1,R2,R3,R4,values,I(1),I(2),I(3),I(4))
value = interpn(R3,R4,squeeze(values(1,1,:,:)),I(3),I(4))

% Plot the reduced-order mesh and the interpolated value
surf(R4,R3,squeeze(values(1,1,:,:)))
hold on
plot3(I(4),I(3),value,'-mo','MarkerSize',15)
hold off

%{
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
%}
