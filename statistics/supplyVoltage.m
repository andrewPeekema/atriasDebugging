% Cleanup
close all
clc

% Use the atriasAnalysis variable if it exists
if exist('a')
    voltage = a.Electrics.lHipMotorVoltage; % V
else
    voltage = v_log__robot__state_lHipMotorVoltage; % V
end

% Display data
plot(voltage,'b.')

title('Supply Voltage')
xlabel('Time (ms)')
ylabel('Voltage (V)')
