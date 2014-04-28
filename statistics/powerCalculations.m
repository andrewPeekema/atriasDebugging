% Cleanup
close all
clearvars -except a % Keep only the analyzeATRIAS variable
clc

% Electrical Power
voltage = a.Electrics.lHipMotorVoltage; % V
current = a.Electrics.measuredCurrent(:,1); % A
electricalPower = voltage.*current;

% Display data
plot(electricalPower,'b.')

title('Electrical Power')
xlabel('Time (ms)')
ylabel('Power (w)')
