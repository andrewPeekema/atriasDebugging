function [q r] = motor2LegPos(qA, qB)
% Motor Angles: qA, qB
% Leg angle: q
% Leg length: r
q = (qA + qB)/2;
r = cos((qA-qB)/2);


end
