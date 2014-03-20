% Cleanup
clc
close all

display('Warning: This calculation is only valid with the')
display('atrias_2014-03-20-12-22-47-analyzeATRIAS.mat dataset')

% Cost of Transport = Power / (Velocity*mass*gravity)
% Robot constants
m = 60; % kg
g = 9.81; % m/s^2

% Average Power (from oscilloscope)
% From 6th to 15th z-axis peak
% Power average for 2 seconds after 6th z-axis peak
PStart = 608.4; % W
PMax = 609.3; % W
% Power right before stopping
PFall = 451.3; % W

% Low pass filter the forward velocity
% Remove NaNs
xVelIndex = isfinite(a.Kinematics.velocity(:,1));
xVel = a.Kinematics.velocity(xVelIndex,1);
% Apply a second order butterworth filter
[B A] = butter(2,30/1000); % 30 Hz / 1000 Hz
filtXVel = filtfilt(B,A,xVel);

% Average the forward velocity over 2 seconds
if length(filtXVel) > 2000
    N = 1:(length(filtXVel)-2000);
else
    error('Data is too short')
end

avgXVel = NaN(length(N),1);
for n = N
    avgXVel(n) = mean(filtXVel(n:n+2000));
end

% Debug
%plot(avgXVel,'.r')
%hold on
%plot(filtXVel,'.b')

% Conservative: Take the minimum velocity and maximum power
V = min(avgXVel);
conservativeCoT = PMax/(V*m*g);
display(conservativeCoT)
% Best Guess: Start velocity and start power
V = avgXVel(1);
bestGuessCoT = PStart/(V*m*g);
display(bestGuessCoT)
