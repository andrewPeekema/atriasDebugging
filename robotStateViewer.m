% Plot the leg force

% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = './data/siavashWalking3-11-11-2014-full-lap.mat';
[c rs] = logfileToStruct(filePath);

% Shorten the data
rs = shortenData(rs,[97230:104600]);

% Plot leg and motor angles
figure
plot(rs.time,rs.qLlA)
hold on
plot(rs.time,rs.qLmA)
plot(rs.time,rs.qLlB)
plot(rs.time,rs.qLmB)
title('Left Leg Angles')
xlabel('Time [s]')
ylabel('Angle [rad]')
legend('Left Leg A','Left Motor A','Left Leg B','Left Motor B')

figure
plot(rs.time,rs.qRlA)
hold on
plot(rs.time,rs.qRmA)
plot(rs.time,rs.qRlB)
plot(rs.time,rs.qRmB)
title('Right Leg Angles')
xlabel('Time [s]')
ylabel('Angle [rad/s]')
legend('Left Leg A','Left Motor A','Left Leg B','Left Motor B')

% Plot leg and motor angular velocities
figure
plot(rs.time,rs.dqLlA)
hold on
plot(rs.time,rs.dqLmA)
plot(rs.time,rs.dqLlB)
plot(rs.time,rs.dqLmB)
title('Left Leg Angular Velocity')
xlabel('Time [s]')
ylabel('Angular Velocity [rad/s]')
legend('Left Leg A','Left Motor A','Left Leg B','Left Motor B')

figure
plot(rs.time,rs.dqRlA)
hold on
plot(rs.time,rs.dqRmA)
plot(rs.time,rs.dqRlB)
plot(rs.time,rs.dqRmB)
title('Right Leg Angular Velocity')
xlabel('Time [s]')
ylabel('Angular Velocity [rad/s]')
legend('Left Leg A','Left Motor A','Left Leg B','Left Motor B')

% See the commanded torques
figure
plot(rs.time,rs.cmdLA)
hold on
plot(rs.time,rs.cmdLB)
plot(rs.time,rs.cmdRA)
plot(rs.time,rs.cmdRB)
title('Commanded Torques')
xlabel('Time [s]')
ylabel('Torque [N*m]')
legend('Left Leg A','Left Motor A','Left Leg B','Left Motor B')

% Toe sensor data
figure
plot(rs.time,rs.lToe,'.')
hold on
plot(rs.time,rs.rToe,'.')
title('Toe Sensors')
xlabel('Time [s]')
ylabel('ADC Sensor Value [unitless]')
legend('Left Toe','Right Toe')
