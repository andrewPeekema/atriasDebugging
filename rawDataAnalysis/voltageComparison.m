clear all
close all
clc

% Old wiring
load('/Users/andrew/Desktop/atrias_2014-04-29-12-53-04.mat')
oldV = v_log__robot__state_lHipMotorVoltage; % V
oldA = v_log__robot__state_currentPositive;

% New wiring
load('/Users/andrew/Desktop/atrias_2014-05-06-16-03-12.mat')
newV = v_log__robot__state_lHipMotorVoltage; % V
newA = v_log__robot__state_currentPositive;


% Voltage
plot(oldV,'b.')
hold on
plot(newV,'r.')
title('Voltage Comparison')
xlabel('Time (ms)')
ylabel('Voltage (V)')

% Current
figure
plot(oldA,'b.')
hold on
plot(newA,'r.')
title('Current Comparison')
xlabel('Time (ms)')
ylabel('Current (A)')
