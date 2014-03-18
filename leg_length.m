
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
