% Cleanup
close all
clc

% Left (1) or right (2) leg?
leg = 2;

if leg == 1 % Left leg
    ARotor = v_log__robot__state_lARotorAngle;
    BRotor = v_log__robot__state_lBRotorAngle;
    AMotor = v_log__robot__state_lAMotorAngle;
    BMotor = v_log__robot__state_lBMotorAngle;
    ALeg   = v_log__robot__state_lALegAngle;
    BLeg   = v_log__robot__state_lBLegAngle;
else % Right leg
    ARotor = v_log__robot__state_rARotorAngle;
    BRotor = v_log__robot__state_rBRotorAngle;
    AMotor = v_log__robot__state_rAMotorAngle;
    BMotor = v_log__robot__state_rBMotorAngle;
    ALeg   = v_log__robot__state_rALegAngle;
    BLeg   = v_log__robot__state_rBLegAngle;
end

plot(ARotor,'.r')
hold on
plot(BRotor,'.r')
plot(AMotor,'.b')
plot(BMotor,'.b')
plot(ALeg,'.g')
plot(BLeg,'.g')
