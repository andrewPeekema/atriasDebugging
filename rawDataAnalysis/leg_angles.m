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

% Get times
rsTime = v_log__robot__state___time;

% Plot
figure
plot(rsTime,qLl_rotor)
hold on
plot(rsTime,qLl_motor)
plot(rsTime,qLl_leg,'-')

plot(rsTime,qRl_motor,'r')
plot(rsTime,qRl_rotor,'r')
plot(rsTime,qRl_leg,'-r')

% Show trigger angles
len = ones(size(qLl_rotor));
q1 = min(v_ATCSlipWalking__input_q1);
q2 = min(v_ATCSlipWalking__input_q2);
q3 = min(v_ATCSlipWalking__input_q3);
plot(rsTime,q1*len,'g-')
plot(rsTime,q2*len,'g-')
plot(rsTime,q3*len,'g-')

xlabel('Samples (ms)')
ylabel('Angle (rad)')
title('Rotor, Motor, and Leg angles in World Coordinates')

% Find events
logTime = v_ATCSlipWalking__log___time;
event = diff(double(v_ATCSlipWalking__log_walkingState));
for n = 1:(length(event)-1)
    % If there is an event
    if event(n) ~= 0
        % Find the robot state index for this log time
        rsN = find(logTime(n) == rsTime,1,'last');
    end

    % Each type of event
    % Right leg SS -> DS
    if event(n) == 1
        plot(logTime(n),qLl_leg(rsN),'c*','MarkerSize', 12)
        plot(logTime(n),qRl_leg(rsN),'c*','MarkerSize', 12)
    % DS -> Left leg SS
    elseif event(n) == 2
        plot(logTime(n),qLl_leg(rsN),'k*','MarkerSize', 12)
        plot(logTime(n),qRl_leg(rsN),'k*','MarkerSize', 12)
    % Left leg SS -> DS
    elseif event(n) == 3
        plot(logTime(n),qLl_leg(rsN),'c*','MarkerSize', 12)
        plot(logTime(n),qRl_leg(rsN),'c*','MarkerSize', 12)
    % DS -> Right leg SS
    elseif event(n) == -6
        plot(logTime(n),qLl_leg(rsN),'k*','MarkerSize', 12)
        plot(logTime(n),qRl_leg(rsN),'k*','MarkerSize', 12)
    end % if event
end % for n
