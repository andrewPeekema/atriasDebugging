function [dqA dqB] = leg2MotorVel(r, dq, dr)

dqA = dq + dr/(1-r^2)^0.5;
dqB = dq - dr/(1-r^2)^0.5;

end
