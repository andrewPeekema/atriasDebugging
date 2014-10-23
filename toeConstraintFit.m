% Load, plot, and fit the toe constraint data

% Cleanup
clc
clear all
close all


load('data/toeConstraint.mat')

% Expand the data
display('Expanding data...')
expandedLHip = NaN(length(q2)*length(q3)*length(ql)*length(qq),1);
expandedRHip = NaN(length(q2)*length(q3)*length(ql)*length(qq),1);
expandedQ    = NaN(length(q2)*length(q3)*length(ql)*length(qq),4);
count = 1; % Index
for q2i = 1:length(q2) % Boom roll
for q3i = 1:length(q3) % Boom pitch
for qli = 1:length(ql) % Virtual leg length
for qqi = 1:length(qq) % Virtual leg angle
    expandedLHip(count) = qLHip(q2i,q3i,qli,qqi);
    expandedRHip(count) = qRHip(q2i,q3i,qli,qqi);
    expandedQ(count,:) = [q2(q2i) q3(q3i) ql(qli) qq(qqi)];
    count = count + 1; % Increment index
end % Virtual leg angle
end % Virtual leg length
end % Boom pitch
end % Boom roll
display('Done expanding data')

% Fit the data
display('Fitting data...')
pLHip = polyfitn(expandedQ,expandedLHip,13);
%pRHip = polyfitn(expandedQ,expandedRHip,5);
display('Done fitting data')

% Make a regular grid to plot the data on
display('Generating grid to plot...')
dq = 0.05;
[m2,m3,ml,mq] = ndgrid(min(q2):dq:max(q2), min(q3):dq:max(q3), min(ql):0.01:max(ql), min(qq):dq:max(qq));
mLHip = polyvaln(pLHip,[m2(:) m3(:) ml(:) mq(:)]);
mLHip = reshape(mLHip, size(m2));

% Plot
% data structure: qHip(q2,q3,ql,qq)
% Size: 3 29 11 314
for n = 1:29
    surf(qq,ql,squeeze(qLHip(1,n,:,:)))
    hold on
    surf(squeeze(mq(1,1,1,:)),squeeze(ml(1,1,:,1)),squeeze(mLHip(1,n,:,:)),squeeze(ones(size(mLHip(1,1,:,:)))))
    xlabel('qq')
    ylabel('ql')
    zlabel('qHip')
    drawnow
    hold off
    pause(0.1)
end
