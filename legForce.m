function force = legForce(r, r0)
% Return the nonlinear ATRIAS leg force
% Given
%  r: current leg length
%  r0: rest leg length

% Leg member lengths
L1 = 0.5; % m
L2 = 0.5; % m
% Stiffness
ks = 1600; % N*m/rad

% Resulting axial leg force
force =  -(ks*(acos(r0) - acos(r)).*(L1 + L2))/(2*L1*L2*(1-r.^2).^0.5);

end
