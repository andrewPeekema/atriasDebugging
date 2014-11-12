% Plot the leg force

% Cleanup
close all
clear all
clc

% The logfile to analyze
filePath = './data/siavashWalking2-11-11-2014-full-lap.mat';
[c rs] = logfileToStruct(filePath);

% Shorten the data
%rs = shortenData(rs,[102000:157400]);

% Convert to controller coordinates
theta1  = rs.qb+rs.qLlA-pi/2;
theta2  = rs.qb+rs.qLlB-pi/2;
thetam1 = rs.qb+rs.qLmA-pi/2;
thetam2 = rs.qb+rs.qLmB-pi/2;

% Desired motor angles
%a = (inv([1 1; -1 1])*[theta1'+theta2'; ones(1,length(theta1))*2*acos(0.9)])';

% Left leg
% Display
%figure
%plot(rs.time,(rs.lADfl+rs.lBDfl)*c.ks,'r.')
%hold on
%plot(rs.time,(rs.rADfl+rs.rBDfl)*c.ks,'b.')


%figure
%plot(rs.time,a(1)-thetam1,'r.')
%hold on
%plot(rs.time,a(2)-thetam2,'b.')

% Spring deflections
figure
plot(rs.time,rs.lADfl*c.ks,'r.')
hold on
plot(rs.time,rs.lBDfl*c.ks,'b.')
title('Left Leg Spring Torques')

figure
plot(rs.time,rs.rADfl*c.ks,'r.')
hold on
plot(rs.time,rs.rBDfl*c.ks,'b.')
title('Right Leg Spring Torques')

% Motor torque to leg force
J11 = -sin(rs.qLlB).*2./sin(rs.qLlA-rs.qLlB);
J12 =  sin(rs.qLlA).*2./sin(rs.qLlA-rs.qLlB);
J21 = -cos(rs.qLlB).*2./sin(rs.qLlA-rs.qLlB);
J22 =  cos(rs.qLlA).*2./sin(rs.qLlA-rs.qLlB);

Fx = J11.*-rs.lADfl*c.ks + J12.*rs.lBDfl*c.ks;
Fy = J21.*-rs.lADfl*c.ks + J22.*rs.lBDfl*c.ks;

figure
plot(rs.time,Fx,'b.')
hold on
plot(rs.time,Fy,'r.')
title('Left Leg Cartesean Forces')
xlabel('Time (s)')
ylabel('Force (N)')

figure
plot(rs.time,rs.cmdLA,'r')
hold on
plot(rs.time,rs.cmdLB,'b')
%plot(rs.time,rs.cmdRA)
%plot(rs.time,rs.cmdRB)
title('Commanded Torque')
xlabel('Time (s)')
ylabel('Torque (N*m)')
