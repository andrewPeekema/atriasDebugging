function toeConstraintLookup
% Create a lookup table for the hip angle
% Can't use interpn because matlab coder doesn't support it

% Cleanup
clc
clear all
close all

% 4D Linear Interpolation
% Formula from: http://bmia.bmt.tue.nl/people/BRomeny/Courses/8C080/Interpolation.pdf
% Where a, b, c, d are the 4 inputs
% 0, 1, and 2 are the lower, upper, and desired points respectively

% Variable ranges
x = [0 2];
y = [-3 3];
z = [0 5];
% Filler values
values = NaN(length(x),length(y),length(z));
for xi = 1:length(x)
for yi = 1:length(y)
for zi = 1:length(z)
    values(xi,yi,zi) = 10;
end
end
end

% Target point
I = [1 1.4 4.2];

% Calculate boundary points from target point
xyz0 = lowerBoundary(I,x,y,z);
xyz1 = upperBoundary(I,x,y,z);

% TODO: Generate point permutations
% TODO: Find point and opposite point
% Points
A = xyz0*[1 1 0] + xyz1*[0 0 1];
B = xyz0*[1 0 0] + xyz1*[0 1 1];
C = xyz0*[0 1 0] + xyz1*[1 0 1];
D = xyz0*[0 0 0] + xyz1*[1 1 1];
E = xyz0*[1 1 1] + xyz1*[0 0 0];
F = xyz0*[1 0 1] + xyz1*[0 1 0];
G = xyz0*[0 1 1] + xyz1*[1 0 0];
H = xyz0*[0 0 1] + xyz1*[1 1 0];

return % Debugging

% Normalized hypervolumes
Na = hypervolume(H,I)/hypervolume(E,D);
Nb = hypervolume(G,I)/hypervolume(E,D);
Nc = hypervolume(F,I)/hypervolume(E,D);
Nd = hypervolume(E,I)/hypervolume(E,D);
Ne = hypervolume(D,I)/hypervolume(E,D);
Nf = hypervolume(C,I)/hypervolume(E,D);
Ng = hypervolume(B,I)/hypervolume(E,D);
Nh = hypervolume(A,I)/hypervolume(E,D);

% Calculate values
interpVal = pointToValue(A)*Na + ...
            pointToValue(B)*Nb + ...
            pointToValue(C)*Nc + ...
            pointToValue(D)*Nd + ...
            pointToValue(E)*Ne + ...
            pointToValue(F)*Nf + ...
            pointToValue(G)*Ng + ...
            pointToValue(H)*Nh;

%{
% The hip angle data
load('data/toeConstraint.mat')

% Plot
% data structure: qHip(q2,q3,ql,qq)
% Size: 3 29 11 314
for n = 1:29
    surf(qq,ql,squeeze(qLHip(1,n,:,:)))
    xlabel('qq')
    ylabel('ql')
    zlabel('qHip')
    drawnow
    pause(0.1)
end
%}

function p = pointMasher(p1,p2,pI)
    % Combine two points based on pI, where pI are the points of p2 to use
    % TODO: Finish this
    %p = p1
end

function p = upperBoundary(p,Rx,Ry,Rz)
    % Find the point indices
    xi = sum(Rx < p(1));
    yi = sum(Ry < p(2));
    zi = sum(Rz < p(3));

    % Get the point
    p = [Rx(xi+1) Ry(yi+1) Rz(zi+1)];
end % pointToValue

function p = lowerBoundary(p,Rx,Ry,Rz)
    % Find the point indices
    xi = sum(Rx < p(1));
    yi = sum(Ry < p(2));
    zi = sum(Rz < p(3));

    % Get the point
    p = [Rx(xi) Ry(yi) Rz(zi)];
end % pointToValue

function value = pointToValue(p,values,Rx,Ry,Rz)
    % Find the point indices
    p1i = sum(Rx <= p(1));
    p2i = sum(Ry <= p(2));
    p3i = sum(Rz <= p(3));

    % Get the value
    value = values(p1i,p2i,p3i);
end % pointToValue

function V = hypervolume(p1,p2)
    % p1, p2: points with n dimensions
    n = length(p1);

    % Find the volume
    V = 1;
    for a = 1:n
        V = V*abs(p1(a)-p2(a))
    end
end % hypervolume

end % toeConstraintLookup
