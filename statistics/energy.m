% Find:
%  Kenetic Energy
%  Potential Energy
%  Total Energy

% Cleanup
clc
close all
clear all

% The logfile to analyze
filePath = '/Users/andrew/Desktop/atrias_2014-05-06-16-03-12.mat';
rs = simplifyLogfile(filePath);
display(['Analyzing: ' filePath])

%% Kenetic Energy
v = hypot(rs.dx,rs.dz);
KE = 1/2*rs.m*v.^2;

% TODO: Add rotational KE (1/2*I*dq^2) of torso and rotors
display('Warning: Rotational KE neglected')

%% Potential Energy
% Spring PE
PEs = 1/2*rs.ks*(rs.lADfl.^2+rs.lBDfl.^2+rs.rADfl.^2+rs.rBDfl.^2);

% Gravitational PE
PEg = rs.m*rs.g*rs.z;
% Zero w.r.t the start
PEg = PEg-min(PEg(1:20000));

% Remove any points over maxE (noise)
maxE = 500; % J
PEs(PEs>maxE) = 0;
PEg(PEg>maxE) = 0;
KE(KE>maxE)   = 0;

% Visualization
figure
plot(PEs,'b.')
hold on
plot(PEg,'g.')
plot(KE,'r.')
title('Kinetic and Potential Energy')
xlabel('Time (ms)')
ylabel('Energy (J)')
legend('Spring PE','Gravitational PE','KE','Location','best')

% TODO: Plot vertical lines to indicate events
% TODO: use "fill" to make shaded regions
prevYLim = ylim; % Get vertical limits
for n = 1:length(rs.td)
    plot([rs.td(n) rs.td(n)],prevYLim)
end
for n = 1:length(rs.to)
    plot([rs.to(n) rs.to(n)],prevYLim)
end

figure
plot(PEs+PEg+KE,'b.')
title('System Energy')
xlabel('Time (ms)')
ylabel('Energy (J)')
