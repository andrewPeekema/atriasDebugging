% Find:
%   Vertical Leg Orientation height
%   Vertical Leg Orientation velocity
%   Vertical Leg Orientation energy

% Cleanup
clc
close all
clearvars -except a % Keep only the analyzeATRIAS variable

%% Find the VLO height and velocity
% Apex occurs during single support
%% Right leg
td = a.Timing.rtd;
to = a.Timing.rto;
% If we takeoff before we touchdown
if to(1) < td(1)
    % Remove the first takeoff
    to = to(2:end);
end
% If the last touchdown never takes off
if td(end) > to(end)
    % Remove the last touchdown
    td = td(1:end-1);
end
% For each touchdown to takeoff
for n = 1:length(td)
    % Start and end indicies
    t1 = td(n);
    t2 = to(n);
    % Vertical leg orientation is at pi/2
    tmp = abs(a.Kinematics.legAngles(t1:t2,2)-pi/2);
    [~,tmpN] = min(tmp);
    % Index, height, and leg angle
    nRApex(n) = tmpN + t1;
    yRApex(n) = a.Kinematics.position(nRApex(n),2);
    rRApex(n) = a.Kinematics.legLength(nRApex(n),2);
    qRApex(n) = a.Kinematics.legAngles(nRApex(n),2);
    % Velocity
    dx = a.Kinematics.velocity(nRApex(n),1);
    dy = a.Kinematics.velocity(nRApex(n),2);
    vRApex(n) = hypot(dx,dy);
    % Motor and body angular velocity
    dqLA_RApex(n) = a.Kinematics.motors.MotorVelocity(nRApex(n),1);
    dqLB_RApex(n) = a.Kinematics.motors.MotorVelocity(nRApex(n),2);
    dqRA_RApex(n) = a.Kinematics.motors.MotorVelocity(nRApex(n),3);
    dqRB_RApex(n) = a.Kinematics.motors.MotorVelocity(nRApex(n),4);
    dq_RApex(n)   = a.Kinematics.bodyPitchVelocity(nRApex(n),1);
end

%% Left leg
td = a.Timing.ltd;
to = a.Timing.lto;
% If we takeoff before we touchdown
if to(1) < td(1)
    % Remove the first takeoff
    to = to(2:end);
end
% If the last touchdown never takes off
if td(end) > to(end)
    % Remove the last touchdown
    td = td(1:end-1);
end
% For each touchdown to takeoff
for n = 1:length(td)
    % Start and end indicies
    t1 = td(n);
    t2 = to(n);
    % Vertical leg orientation is at pi/2
    tmp = abs(a.Kinematics.legAngles(t1:t2,1)-pi/2);
    [~,tmpN] = min(tmp);
    % Index, height, and leg angle
    nLApex(n) = tmpN + t1;
    yLApex(n) = a.Kinematics.position(nLApex(n),2);
    rLApex(n) = a.Kinematics.legLength(nLApex(n),1);
    qLApex(n) = a.Kinematics.legAngles(nLApex(n),1);
    % Velocity
    dx = a.Kinematics.velocity(nLApex(n),1);
    dy = a.Kinematics.velocity(nLApex(n),2);
    vLApex(n) = hypot(dx,dy);
    % Motor and body angular velocity
    dqLA_LApex(n) = a.Kinematics.motors.MotorVelocity(nLApex(n),1);
    dqLB_LApex(n) = a.Kinematics.motors.MotorVelocity(nLApex(n),2);
    dqRA_LApex(n) = a.Kinematics.motors.MotorVelocity(nLApex(n),3);
    dqRB_LApex(n) = a.Kinematics.motors.MotorVelocity(nLApex(n),4);
    dq_LApex(n)   = a.Kinematics.bodyPitchVelocity(nLApex(n),1);
end

%figure
%plot(a.Kinematics.position(:,2)) % Vertical position
%hold on
%plot(nRApex,a.Kinematics.position(nRApex,2),'*r')
%plot(nLApex,a.Kinematics.position(nLApex,2),'*g')

% Height and velocity mean and standard deviation
stats.yLApexMean = mean(yLApex);
stats.yLApexStd  = std(yLApex);
stats.yRApexMean = mean(yRApex);
stats.yRApexStd  = std(yRApex);
stats.yApexMean  = mean([yLApex yRApex]);
stats.yApexStd   = std([yLApex yRApex]);

stats.vLApexMean = mean(vLApex);
stats.vLApexStd  = std(vLApex);
stats.vRApexMean = mean(vRApex);
stats.vRApexStd  = std(vRApex);
stats.vApexMean  = mean([vLApex vRApex]);
stats.vApexStd   = std([vLApex vRApex]);



%% VLO Energy
addpath('./..') % for legForce()
% E = KE + PEg + PEs
% E = 1/2*m*v^2 + m*g*h + 1/2*k*Dx^2

% Constants
g = 9.81; % Gravity (m/s^2)
m = 60;   % Mass (kg)
Ir = 50^2*0.0019; % Reflected rotor moment of inertia (kg*m^2)
It = 4.1; % Torso moment of inertia (kg*m^2)

% Spring potential energy (PEs)
nApices = length([nLApex nRApex]);
if nLApex(1) < nRApex(1)
    display('First apex is on the left leg')
    r(1:2:nApices) = rLApex;
    r(2:2:nApices) = rRApex;
    h(1:2:nApices) = yLApex;
    h(2:2:nApices) = yRApex;
    v(1:2:nApices) = vLApex;
    v(2:2:nApices) = vRApex;
    dq(1:2:nApices) = dq_LApex;
    dq(2:2:nApices) = dq_RApex;
    dqLA(1:2:nApices) = dqLA_LApex;
    dqLA(2:2:nApices) = dqLA_RApex;
    dqLB(1:2:nApices) = dqLB_LApex;
    dqLB(2:2:nApices) = dqLB_RApex;
    dqRA(1:2:nApices) = dqRA_LApex;
    dqRA(2:2:nApices) = dqRA_RApex;
    dqRB(1:2:nApices) = dqRB_LApex;
    dqRB(2:2:nApices) = dqRB_RApex;
else
    display('First apex is on the right leg')
    r(1:2:nApices) = rRApex;
    r(2:2:nApices) = rLApex;
    h(1:2:nApices) = yRApex;
    h(2:2:nApices) = yLApex;
    v(1:2:nApices) = vRApex;
    v(2:2:nApices) = vLApex;
    dq(1:2:nApices) = dq_RApex;
    dq(2:2:nApices) = dq_LApex;
    dqLA(1:2:nApices) = dqLA_RApex;
    dqLA(2:2:nApices) = dqLA_LApex;
    dqLB(1:2:nApices) = dqLB_RApex;
    dqLB(2:2:nApices) = dqLB_LApex;
    dqRA(1:2:nApices) = dqRA_RApex;
    dqRA(2:2:nApices) = dqRA_LApex;
    dqRB(1:2:nApices) = dqRB_RApex;
    dqRB(2:2:nApices) = dqRB_LApex;
end
% The rest leg length
r0 = 0.9; % TODO: a.ControllerData.r0(end);
display('WARNING: Using a fixed r0.  This is a hack')
% If the leg length is longer than the rest leg length, set the PE to zero
r(r>r0) = r0;
% The deflection
Dx = r0-r;
% The spring constant
k = legForce(r, r0)./Dx;
% The spring potential energy
PEs = 1/2*k.*Dx.^2;

% Kenetic Energy (KE)
KE = 1/2*m*v.^2 + 1/2*It*dq.^2 + 1/2*Ir*(dqLA.^2 + dqLB.^2 + dqRA.^2 + dqRB.^2);

% Gravitational Potential Energy (PEg)
PEg = m*g*h;

% Total energy
E = KE + PEg + PEs

%display(stats)
