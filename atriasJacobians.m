% Generate various Jacobians for ATRIAS

syms q1 q2 real
%% Jacobian for motor to polar coordinates
%S = sin(q2-q1)/2;
%A = [0.5*S -0.5*S;
%     0.5    0.5];
%
%% Polar coordinates
%ql = (q1+q2)/2;
%l  = cos((q2-q1)/2);
%% Jacobian for polar to cartesean coordinates
%B = [cos(ql) -l*sin(ql);
%     sin(ql)  l*cos(ql)];
%
%% Jacobian for motor to cartesean coordinates
%J = B*A;
%
%% Transformation for motor torques to cartesean forces
%simplify(inv(J'))

% Direct transformation from motor angles to cartesean coordinates
x = 1/2*(sin(q1)+sin(q2));
y = 1/2*(cos(q1)+cos(q2));
J = jacobian([x,y],[q1,q2]);
simplify(inv(J'))
