% Cleanup
close all
clc

% Calculate lengths
rLl_rotor = cos((v_log__robot__state_lARotorAngle-v_log__robot__state_lBRotorAngle)/2);
rRl_rotor = cos((v_log__robot__state_rARotorAngle-v_log__robot__state_rBRotorAngle)/2);
rRl_motor = cos((v_log__robot__state_rAMotorAngle-v_log__robot__state_rBMotorAngle)/2);
rLl_motor = cos((v_log__robot__state_lAMotorAngle-v_log__robot__state_lBMotorAngle)/2);
rRl_leg   = cos((v_log__robot__state_rALegAngle-v_log__robot__state_rBLegAngle)/2);
rLl_leg   = cos((v_log__robot__state_lALegAngle-v_log__robot__state_lBLegAngle)/2);
rRl_springDfl   = rRl_motor-rRl_leg;
rLl_springDfl   = rLl_motor-rLl_leg;
rRl_gearDfl     = rRl_rotor-rRl_motor;
rLl_gearDfl     = rLl_rotor-rLl_motor;

% Get times
rsTime = v_log__robot__state___time;

% Plot
figure
plot(rsTime,rLl_springDfl,'.r')
hold on
plot(rsTime,rRl_springDfl,'.b')

% Labels
title('Spring Deflections')
xlabel('Time (s)')
ylabel('Deflection (m)')
legend('Left Leg Spring','Right Leg Spring')


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
        plot(logTime(n),rRl_springDfl(rsN),'c*','MarkerSize', 12)
        plot(logTime(n),rLl_springDfl(rsN),'c*','MarkerSize', 12)
    % DS -> Left leg SS
    elseif event(n) == 2
        plot(logTime(n),rRl_springDfl(rsN),'k*','MarkerSize', 12)
        plot(logTime(n),rLl_springDfl(rsN),'k*','MarkerSize', 12)
    % Left leg SS -> DS
    elseif event(n) == 3
        plot(logTime(n),rRl_springDfl(rsN),'c*','MarkerSize', 12)
        plot(logTime(n),rLl_springDfl(rsN),'c*','MarkerSize', 12)
    % DS -> Right leg SS
    elseif event(n) == -6
        plot(logTime(n),rRl_springDfl(rsN),'k*','MarkerSize', 12)
        plot(logTime(n),rLl_springDfl(rsN),'k*','MarkerSize', 12)
    end % if event
end % for n
