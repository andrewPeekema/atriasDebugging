% Cleanup
close all
clc

% Motor Temperature
rB0 = v_log__robot__state_rBMotorTherm0;
rB1 = v_log__robot__state_rBMotorTherm1;
rB2 = v_log__robot__state_rBMotorTherm2;
rB3 = v_log__robot__state_rBMotorTherm3;
rB4 = v_log__robot__state_rBMotorTherm4;
rB5 = v_log__robot__state_rBMotorTherm5;
rB = mean([rB0 rB1 rB2 rB3 rB4 rB5],2);

lA0 = v_log__robot__state_lAMotorTherm0;
lA1 = v_log__robot__state_lAMotorTherm1;
lA2 = v_log__robot__state_lAMotorTherm2;
lA3 = v_log__robot__state_lAMotorTherm3;
lA4 = v_log__robot__state_lAMotorTherm4;
lA5 = v_log__robot__state_lAMotorTherm5;
lA = mean([lA0 lA1 lA2 lA3 lA4 lA5],2);

plot(lA,'b.')
hold on
plot(rB,'r.')
