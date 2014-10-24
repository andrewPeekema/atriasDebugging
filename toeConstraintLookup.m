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

% Boundaries
xyz0 = [0 0 0];
xyz1 = [2 3 5];

% Filler values
x = [0 2];
y = [0 3];
z = [0 5];
values = NaN(length(x),length(y),length(z));
for xi = x
for yi = y
for zi = z
    values(xi,yi,zi) = rand*10;
end
end
end

% Target point
x2 = 1;
y2 = 1.4;
z2 = 4.2;

% Points
A = xyz0*[1 1 0] + xyz1*[0 0 1];
B = xyz0*[1 0 0] + xyz1*[0 1 1];
C = xyz0*[0 1 0] + xyz1*[1 0 1];
D = xyz0*[0 0 0] + xyz1*[1 1 1];
E = xyz0*[1 1 1] + xyz1*[0 0 0];
F = xyz0*[1 0 1] + xyz1*[0 1 0];
G = xyz0*[0 1 1] + xyz1*[1 0 0];
H = xyz0*[0 0 1] + xyz1*[1 1 0];

I = [x2 y2 z2];

% Normalized hypervolumes
Na = hypervolume(H,I)/hypervolume(E,D);
Nb = hypervolume(G,I)/hypervolume(E,D);
Nc = hypervolume(F,I)/hypervolume(E,D);
Nd = hypervolume(E,I)/hypervolume(E,D);
Ne = hypervolume(D,I)/hypervolume(E,D);
Nf = hypervolume(C,I)/hypervolume(E,D);
Ng = hypervolume(B,I)/hypervolume(E,D);
Nh = hypervolume(A,I)/hypervolume(E,D);

v8 = v0*Na + v1*Nb + v2*Nc + v3*Nd + v4*Ne + v5*Nf + v6*Ng + v7*Nh;

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

% TODO: Test this function
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
