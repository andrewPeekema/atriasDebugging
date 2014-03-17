% Cleanup
close all
clc

% Plot the desired vs actual leg force
leg=2;
% Desired force
controlF = hypot(a.ControllerData.controlFx(:,leg),a.ControllerData.controlFz(:,leg));
% Computed force
computeF = hypot(a.ControllerData.computeFx(:,leg),a.ControllerData.computeFz(:,leg));
plot(controlF,'r.')
hold on
plot(computeF,'.b')
% Percent control error
plot((controlF-computeF)./controlF*100,'m.')
% Motor current
plot(a.Electrics.motorCurrent(:,leg*(1:2)),'.g')

% Labels
legend('Desired Force (N)',...
       'Actual Force (N)',...
       'Control Error (%)',...
       'Motor Current (A)',...
       'Location','NorthEast')

% Don't show bad data
yLimits = ylim;
ylim([-200 yLimits(2)])
