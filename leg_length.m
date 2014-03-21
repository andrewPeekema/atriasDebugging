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

% Get times
time = v_log__robot__state___time;

% Plot
figure
plot(time,rLl_rotor,'.r')
hold on
plot(time,rLl_motor,'.g')
plot(time,rLl_leg,'.b')

plot(time,rRl_rotor,'-r')
plot(time,rRl_motor,'-g')
plot(time,rRl_leg,'-b')

% Labels
title('Leg lengths')
xlabel('Time (s)')
ylabel('Length (m)')
legend('Left Rotor','Left Motor','Left Leg','Right Rotor','Right Motor','Right Leg')


% Find events
event = diff(double(v_ATCSlipWalking__log_walkingState));
for n = 1:(length(event)-1)
    % Right leg SS -> DS
    if event(n) == 1
        plot(time(n),rRl_leg(n),'c*','MarkerSize', 12)
        plot(time(n),rLl_leg(n),'c*','MarkerSize', 12)
    % DS -> Left leg SS
    elseif event(n) == 2
        plot(time(n),rRl_leg(n),'k*','MarkerSize', 12)
        plot(time(n),rLl_leg(n),'k*','MarkerSize', 12)
    % Left leg SS -> DS
    elseif event(n) == 3
        plot(time(n),rRl_leg(n),'c*','MarkerSize', 12)
        plot(time(n),rLl_leg(n),'c*','MarkerSize', 12)
    % DS -> Right leg SS
    elseif event(n) == -6
        plot(time(n),rRl_leg(n),'k*','MarkerSize', 12)
        plot(time(n),rLl_leg(n),'k*','MarkerSize', 12)
    end % if event
end % for n
