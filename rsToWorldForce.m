function force = rsToWorldForce(rs, ks)
% Inputs:
%   rs: robot state struct
%   ks: radial spring constant
% Outputs
%   force.LF.Fx: force in the x-direction
%   force.LF.Fz: force in the z-direction
%   force.LF.F:  force magnitude

% Spring torque at the motor
tauLA = (rs.qLmA - rs.qLlA)*ks;
tauLB = (rs.qLmB - rs.qLlB)*ks;
tauRA = (rs.qRmA - rs.qRlA)*ks;
tauRB = (rs.qRmB - rs.qRlB)*ks;

% End effector force
force.LF = motorTorqueToWorldForce(tauLA, tauLB, rs.qLlA, rs.qLlB, rs.qb);
force.RF = motorTorqueToWorldForce(tauRA, tauRB, rs.qRlA, rs.qRlB, rs.qb);


function F = motorTorqueToWorldForce(tausA, tausB, qlA, qlB, qb)
    % End effector force from leg configuration
    L1   = 0.5;
    L2   = 0.5;
    F.Fx = -(L2.*tausB.*sin(qb + qlA) - L1.*tausA.*sin(qb + qlB))./(L1.*L2.*sin(qlA - qlB));
    F.Fz = -(L2.*tausB.*cos(qb + qlA) - L1.*tausA.*cos(qb + qlB))./(L1.*L2.*sin(qlA - qlB));
    F.F  = hypot(F.Fx, F.Fz);
end

end % function
