clc
clear
close


syms x q real
fp = SE3([0 0 0 0 0 q])*SE3([x 0 0]);

% Cartesean foot point (x,y) in polar coordinates (q,x)
x = matlabFunction(fp.x);
y = matlabFunction(fp.y);

% Angle to sweep
q1 = -pi/2-0.35;
q2 = -pi/2+0.35;

% Constant angle change, constant length
s = linspace(q1,q2,20);
xp1 = x(s,1);
yp1 = y(s,1);

% Constant angle change, constant length change
s = linspace(q1,q2,20);
r = linspace(1,0.5,20);
xp2 = x(s,r);
yp2 = y(s,r);
% Visualize
plot([0 xp1(1)]  ,[0 yp1(1)]  ,'--')
hold on
plot([0 xp1(end)],[0 yp1(end)],'--')
plot(xp1,yp1,'.')
plot(xp2,yp2,'.')


