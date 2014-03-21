% Cleanup
close all
clc

% Calculate lengths
rRl_motor = cos((v_log__robot__state_rAMotorAngle-v_log__robot__state_rBMotorAngle)/2);
rLl_motor = cos((v_log__robot__state_lAMotorAngle-v_log__robot__state_lBMotorAngle)/2);
rRl_leg   = cos((v_log__robot__state_rALegAngle-v_log__robot__state_rBLegAngle)/2);
rLl_leg   = cos((v_log__robot__state_lALegAngle-v_log__robot__state_lBLegAngle)/2);
rRl_dfl   = rRl_motor-rRl_leg;
rLl_dfl   = rLl_motor-rLl_leg;

% Get times
time = v_log__robot__state___time;

% Plot
figure
plot(time,rLl_dfl,'.r')
hold on
plot(time,rRl_dfl,'.b')

% Labels
title('Spring Deflections')
xlabel('Time (s)')
ylabel('Deflection (m)')
legend('Left Leg','Right Leg')


% Find events
event = diff(double(v_ATCSlipWalking__log_walkingState));
for n = 1:(length(event)-1)
    % Right leg SS -> DS
    if event(n) == 1
        plot(time(n),rRl_dfl(n),'c*','MarkerSize', 12)
        plot(time(n),rLl_dfl(n),'c*','MarkerSize', 12)
    % DS -> Left leg SS
    elseif event(n) == 2
        plot(time(n),rRl_dfl(n),'k*','MarkerSize', 12)
        plot(time(n),rLl_dfl(n),'k*','MarkerSize', 12)
    % Left leg SS -> DS
    elseif event(n) == 3
        plot(time(n),rRl_dfl(n),'c*','MarkerSize', 12)
        plot(time(n),rLl_dfl(n),'c*','MarkerSize', 12)
    % DS -> Right leg SS
    elseif event(n) == -6
        plot(time(n),rRl_dfl(n),'k*','MarkerSize', 12)
        plot(time(n),rLl_dfl(n),'k*','MarkerSize', 12)
    end % if event
end % for n
