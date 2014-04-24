% Cleanup
close all
clc

% Spring Power
% Angles
qmLA = v_log__robot__state_lAMotorAngle;
qmLB = v_log__robot__state_lBMotorAngle;
qmRA = v_log__robot__state_rAMotorAngle;
qmRB = v_log__robot__state_rBMotorAngle;
qm   = [qmLA qmLB qmRA qmRB];
qlLA = v_log__robot__state_lALegAngle;
qlLB = v_log__robot__state_lBLegAngle;
qlRA = v_log__robot__state_rALegAngle;
qlRB = v_log__robot__state_rBLegAngle;
ql   = [qlLA qlLB qlRA qlRB];
Dq   = qm-ql;
% Angular Velocities
dqmLA = v_log__robot__state_lAMotorVelocity;
dqmLB = v_log__robot__state_lBMotorVelocity;
dqmRA = v_log__robot__state_rAMotorVelocity;
dqmRB = v_log__robot__state_rBMotorVelocity;
dqm   = [dqmLA dqmLB dqmRA dqmRB];
dqlLA = v_log__robot__state_lALegVelocity;
dqlLB = v_log__robot__state_lBLegVelocity;
dqlRA = v_log__robot__state_rALegVelocity;
dqlRB = v_log__robot__state_rBLegVelocity;
dql   = [dqlLA dqlLB dqlRA dqlRB];
dDq   = dqm-dql;

springConstant   = 1600; % N*m/rad
springDeflection = Dq;
springVelocity   = dDq;
springTorque     = springConstant*springDeflection;
springPower      = springVelocity.*springTorque;

% Motor Power
motorVelocity  = dqm;
motorPower = -springTorque.*motorVelocity;

% Spring-motor comparisons
%t1 = 157000;
%t2 = 159800;
%for n = 1:4
%    subplot(2,2,n)
%    plot(motorPower(t1:t2,n)+springPower(t1:t2,n+2),'c.')
%    hold on
%    plot(springPower(t1:t2,n),'r.')
%    xlabel('Time (ms)')
%    ylabel('Power (w)')
%    if n == 1
%        title('Left A Power')
%    elseif n == 2
%        title('Left B Power')
%    elseif n == 3
%        title('Right A Power')
%    else
%        title('Right B Power')
%    end
%end
%legend('Gait Power','Spring Power','Location','Best')

% Only the right leg
t1 = 157000;
t2 = t1+1500;
for n = 1:2
    subplot(1,2,n)
    plot(motorPower(t1:t2,n+2)+springPower(t1:t2,n+2),'c.')
    hold on
    plot(springPower(t1:t2,n+2),'r.')
    xlabel('Time (ms)')
    ylabel('Power (w)')
    if n == 1
        title('Right A Power')
    else
        title('Right B Power')
    end
end
legend('Gait Power','Spring Power','Location','Best')
