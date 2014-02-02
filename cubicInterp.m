function [y dy] = cubicInterp(x1, x2, y1, y2, dy1, dy2, x, dx)
% Cubic interpolation between two points (x1 and x2)
% Given the current position and velocity (x and dx)
% And maps between two output (position,velocity) states (y1,dy1) and (y2,dy2)

% Clamp x between x1 and x2
if x < x1
    x = x1;
elseif x > x2
    x = x2;
end

a0 = 2*(y1 - y2) + (dy1 + dy2)*(x2 - x1);
a1 = y2 - y1 - dy1*(x2 - x1) - a0;
a2 = dy1*(x2 - x1);
a3 = y1;
s = (x - x1)/(x2 - x1);

% Output position and velocity
y = a0*s*s*s + a1*s*s + a2*s + a3;
dy = dx*(-3*a0*(x - x1)^2/(x1 - x2)^3 + 2*a1*(x - x1)/(x1 - x2)^2 - a2/(x1 - x2));

end % cubicInterp
