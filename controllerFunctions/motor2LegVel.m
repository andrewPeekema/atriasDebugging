function [dq dr] = motor2LegVel(qA, qB, dqA, dqB);

dq = (dqA+dqB)/2;
dr = -(sin((qA-qB)/2).*(dqA-dqB))/2;

end
