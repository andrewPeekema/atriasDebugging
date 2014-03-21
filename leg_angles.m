% Analysis of ATRIAS leg angles over time
% For debugging purposes
% Author: Andrew Peekema

% Cleanup
close all
clc

% Plot commanded currents
lBCmd = v_log__robot__state_lBClampedCmd;
lACmd = v_log__robot__state_lAClampedCmd;
rBCmd = v_log__robot__state_rBClampedCmd;
rACmd = v_log__robot__state_rAClampedCmd;

figure
plot(lACmd,'b')
hold on
plot(lBCmd,'b.')
plot(rACmd,'r')
plot(rBCmd,'r.')

% Calculate angles
qLl_rotor = (v_log__robot__state_lARotorAngle+v_log__robot__state_lBRotorAngle)/2;
qRl_rotor = (v_log__robot__state_rARotorAngle+v_log__robot__state_rBRotorAngle)/2;
qRl_motor = (v_log__robot__state_rAMotorAngle+v_log__robot__state_rBMotorAngle)/2;
qLl_motor = (v_log__robot__state_lAMotorAngle+v_log__robot__state_lBMotorAngle)/2;
qRl_leg   = (v_log__robot__state_rALegAngle+v_log__robot__state_rBLegAngle)/2;
qLl_leg   = (v_log__robot__state_lALegAngle+v_log__robot__state_lBLegAngle)/2;

% Translate to world coordinates
bodyPitch = v_log__robot__state_bodyPitch - 3*pi/2;
qLl_rotor = qLl_rotor + bodyPitch;
qRl_rotor = qRl_rotor + bodyPitch;
qRl_motor = qRl_motor + bodyPitch;
qLl_motor = qLl_motor + bodyPitch;
qRl_leg   = qRl_leg + bodyPitch;
qLl_leg   = qLl_leg + bodyPitch;

% Plot
figure
plot(qLl_rotor)
hold on
plot(qLl_motor)
plot(qLl_leg,'-')

plot(qRl_motor,'r')
plot(qRl_rotor,'r')
plot(qRl_leg,'-r')

% Show trigger angles
len = ones(size(qLl_rotor));
q1 = min(v_ATCSlipWalking__input_q1);
q2 = min(v_ATCSlipWalking__input_q2);
q3 = min(v_ATCSlipWalking__input_q3);
plot(q1*len,'g-')
plot(q2*len,'g-')
plot(q3*len,'g-')

xlabel('Samples (ms)')
ylabel('Angle (rad)')
title('Rotor, Motor, and Leg angles in World Coordinates')

% Find events
event = diff(double(v_ATCSlipWalking__log_walkingState));
for n = 1:(length(event)-1)
    % Right leg SS -> DS
    if event(n) == 1
        plot(n,qLl_leg(n),'c*','MarkerSize', 12)
        plot(n,qRl_leg(n),'c*','MarkerSize', 12)
    % DS -> Left leg SS
    elseif event(n) == 2
        plot(n,qLl_leg(n),'k*','MarkerSize', 12)
        plot(n,qRl_leg(n),'k*','MarkerSize', 12)
    % Left leg SS -> DS
    elseif event(n) == 3
        plot(n,qLl_leg(n),'c*','MarkerSize', 12)
        plot(n,qRl_leg(n),'c*','MarkerSize', 12)
    % DS -> Right leg SS
    elseif event(n) == -6
        plot(n,qLl_leg(n),'k*','MarkerSize', 12)
        plot(n,qRl_leg(n),'k*','MarkerSize', 12)
    end % if event
end % for n
