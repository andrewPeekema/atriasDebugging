% Cleanup
close all
clc

% With the sine wave controller, right leg B moves
% Electrical Power
voltage = 12*3; % V
current = v_log__robot__state_currentPositive; % A
electricalPower = voltage*current;

% Mechanical Power
torqueConstant = 0.121;
gearRatio      = 50;
motorVelocity  = gearRatio*v_log__robot__state_rBMotorVelocity;
motorTorque = torqueConstant*v_log__robot__state_rBClampedCmd;
mechPower   = motorVelocity.*motorTorque;

% Electrical power loss
km = 0.529; % N*m/sqrt.w
powerLoss = (motorTorque/km).^2; % w

% Display data
plot(electricalPower,'b.')
hold on
plot(mechPower,'r.')
%plot(powerLoss,'g.')

title('Positive System Power')
xlabel('Time (ms)')
ylabel('Power (w)')
legend('Electrical Power','Mechanical Power')
