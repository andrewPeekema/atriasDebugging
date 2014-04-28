% Cleanup
close all
clearvars -except a % Keep only the analyzeATRIAS variable
clc

% Use the atriasAnalysis variable if it exists
if exist('a')
    voltage = a.Electrics.lHipMotorVoltage;     % V
    current = a.Electrics.measuredCurrent(:,1); % A
else
    voltage = v_log__robot__state_lHipMotorVoltage; % V
    current = v_log__robot__state_currentPositive;  % A
end

% Power
electricalPower = voltage.*current;

% Display data
plot(electricalPower,'b.')

title('Electrical Power')
xlabel('Time (ms)')
ylabel('Power (w)')
