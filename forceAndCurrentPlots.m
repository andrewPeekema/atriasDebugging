% Plot the desired vs actual leg force

% Cleanup
close all
clear all
clc

% The file to analyze
loadFile

% Left leg
controlF = hypot(cs.controlFxL,cs.controlFzL);
computeF = hypot(cs.computeFxL,cs.computeFzL);
% Display
plot(rs.time,controlF,'r.')
hold on
plot(rs.time,computeF,'b.')
% Only plot current where there is force data
fData = ~isnan(controlF)'; % vector of ones and zeros
fData = double(fData); % Convert from logical to double
fData(fData==0) = NaN;
plot(rs.time,rs.cmdLA.*fData,'g.')
plot(rs.time,rs.cmdLB.*fData,'g.')

% Right leg
controlF = hypot(cs.controlFxR,cs.controlFzR);
computeF = hypot(cs.computeFxR,cs.computeFzR);
% Display
plot(rs.time,controlF,'r.')
hold on
plot(rs.time,computeF,'b.')
% Only plot current where there is force data
fData = ~isnan(controlF)'; % vector of ones and zeros
fData = double(fData); % Convert from logical to double
fData(fData==0) = NaN;
plot(rs.time,rs.cmdRA.*fData,'c.')
plot(rs.time,rs.cmdRB.*fData,'c.')

% Labels
legend('Desired Force (N)',...
       'Actual Force (N)',...
       'Control Error (%)',...
       'Motor Current (A)',...
       'Location','NorthEast')

% Don't show bad data
yLimits = ylim;
ylim([-200 yLimits(2)])
