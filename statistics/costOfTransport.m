% Cleanup
clc
close all

% Cost of Transport = Power / (Velocity*mass*gravity)
% Robot constants
m = 60; % kg
g = 9.81; % m/s^2

% Power
supplyCurrent = a.Electrics.measuredCurrent(:,1); % (A)

 % If there is a direct measurement of the supply voltage
if isfield(a.Electrics, 'lHipMotorVoltage')
    % Use that
    supplyVoltage = a.Electrics.lHipMotorVoltage; % (V)
% Otherwise, aproximate using motor voltages
else
    supplyVoltage = mean(a.Electrics.motorVoltage(:,[1 2 4]),2); % (V)
end

power = supplyCurrent.*supplyVoltage;               % (W)

% Cost of Transport
xVelocity = a.Kinematics.velocity(:,1);
% Remove any NaNs
xVelocity(isnan(xVelocity)) = [];
CoT = power./(xVelocity*m*g);

% Statistics
cotAvg = mean(CoT);

% What does it look like?
plot(CoT,'.')
hold on
plot(ones(1,length(CoT))*cotAvg,'r')

title('Cost of Transport Over Time')
xlabel('Sample Number (Unitless)')
ylabel('Cost of Transport (Unitless)')
legend('Instantaneous CoT','Average CoT')
