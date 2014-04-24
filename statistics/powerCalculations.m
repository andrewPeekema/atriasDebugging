% Cleanup
close all
clearvars -except a % Keep only the analyzeATRIAS variable
clc

% With the sine wave controller, right leg B moves
% Electrical Power
voltage = a.Electrics.lHipMotorVoltage; % V
current = a.Electrics.measuredCurrent(:,1); % A
electricalPower = voltage.*current;

% Spring Power
springConstant = 1600; % N*m/rad
springDeflection = a.Kinematics.segmentAngles-a.Kinematics.motors.MotorAngles;
springVelocity   = a.Kinematics.segmentVelocity-a.Kinematics.motors.MotorVelocity;
springTorque     = springConstant*springDeflection;
springPower      = springVelocity.*springTorque;

% Motor Power
%torqueConstant = 0.121;
%gearRatio      = 50;
%%motorInertia   = 0.0019;
%motorVelocity  = gearRatio*a.Kinematics.motors.MotorVelocity;
%%time           = repmat(diff(a.Timing.Time/1000)',1,4);
%%motorAccel     = [0 0 0 0; diff(motorVelocity)./time];
%motorCurrent   = a.Electrics.motorCurrent;
%motorTorque    = torqueConstant*motorCurrent;
%%inertiaTorque  = motorInertia*motorAccel;
%%motorPower     = motorVelocity.*(motorTorque-inertiaTorque);
%motorPower     = motorVelocity.*motorTorque;
motorVelocity  = a.Kinematics.motors.MotorVelocity;
motorPower = springTorque.*motorVelocity;



% Display data
%plot(electricalPower,'b.')
%hold on

% Spring-motor comparisons
for n = 1:4
    subplot(2,2,n)
    plot(motorPower(:,n),'c.')
    hold on
    plot(springPower(:,n),'r.')
    xlabel('Time (ms)')
    ylabel('Power (w)')
    ylim([-500 500])
    xlim([2851 3960])
    if n == 1
        title('Left A Power')
    elseif n == 2
        title('Left B Power')
    elseif n == 3
        title('Right A Power')
    else
        title('Right B Power')
    end
end
legend('Motor Power','Spring Power','Location','Best')

% Total power
%springPower = sum(springPower,2);
%motorPower  = sum(motorPower,2);
%plot(motorPower,'g.')
%hold on
%plot(springPower,'r.')


%legend('Electrical Power','Motor Power','Spring Power')
%legend('Motor Power')
