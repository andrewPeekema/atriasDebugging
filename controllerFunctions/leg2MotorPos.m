function [qA qB] = leg2MotorPos(q,r)
% Leg angle: q
% Leg length: r
% Motor Angles: qA, qB
qA = q - acos(r);
qB = q + acos(r);

end
