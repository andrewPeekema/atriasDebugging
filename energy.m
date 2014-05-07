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
rs = logfileToStruct(filePath);
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
plot(rs.time,PEs,'b.')
hold on
plot(rs.time,PEg,'g.')
plot(rs.time,KE,'r.')
title('Kinetic and Potential Energy')
xlabel('Time (ms)')
ylabel('Energy (J)')
legend('Spring PE','Gravitational PE','KE','Location','best')



% Show single and double support
prevYLim = ylim; % Get vertical limits
% Single Support
for n = 1:length(rs.SS)
    nSS = [rs.SS(n,1) rs.SS(n,1) rs.SS(n,2) rs.SS(n,2)];
    y   = [prevYLim(1) prevYLim(2) prevYLim(2) prevYLim(1)];
    color = 1 - [0.2 0 0];
    p = patch(rs.time(nSS),y,color);
    set(p,'EdgeColor','None')
end
% Double Support
for n = 1:length(rs.DS)
    nDS = [rs.DS(n,1) rs.DS(n,1) rs.DS(n,2) rs.DS(n,2)];
    y   = [prevYLim(1) prevYLim(2) prevYLim(2) prevYLim(1)];
    color = 1 - [0.3 0 0];
    p = patch(rs.time(nDS),y,color);
    set(p,'EdgeColor','None')
end

figure
plot(rs.time,PEs+PEg+KE,'b.')
title('System Energy')
xlabel('Time (ms)')
ylabel('Energy (J)')
