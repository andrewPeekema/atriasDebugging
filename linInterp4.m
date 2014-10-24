function interpVal = linInterp4(I,values,Rx,Ry,Rz)
% A linear interpolation function for 4 dimensions
% Can't use interpn because matlab coder doesn't support it
% Interpolation formula from:
% http://bmia.bmt.tue.nl/people/BRomeny/Courses/8C080/Interpolation.pdf
% Input
%   I: Target point
%   values: Matrix of values
%   Rx, Ry, Rz: Ranges that the values matrix covers
%   % point = values(x,y,z)

% Bound the target point to the variable range
I(1) = max(I(1),Rx(1));   % Lower bound
I(1) = min(I(1),Rx(end)); % Upper bound
I(2) = max(I(2),Ry(1));   % Lower bound
I(2) = min(I(2),Ry(end)); % Upper bound
I(3) = max(I(3),Rz(1));   % Lower bound
I(3) = min(I(3),Rz(end)); % Upper bound

% Calculate the upper and lower bounding points given the target point
% Find the lower point
xi = sum(Rx <= I(1));
yi = sum(Ry <= I(2));
zi = sum(Rz <= I(3));
% Bound these points to one less than the maximum vector length
xi = min(xi,length(Rx)-1);
yi = min(yi,length(Ry)-1);
zi = min(zi,length(Rz)-1);
xyz0 = [Rx(xi) Ry(yi) Rz(zi)];
% The upper point
xyz1 = [Rx(xi+1) Ry(yi+1) Rz(zi+1)];

% Generate bounding hypercube points
nPoints = 0;
for i1 = 0:1
for i2 = 0:1
for i3 = 0:1
    % Increment the number of points
    nPoints = nPoints + 1;
    % Find the point combination
    pointCombo(nPoints,:) = [i1 i2 i3];
    % Find the point values
    points(nPoints,:) = pointMash(xyz0,xyz1,pointCombo(nPoints,:));
end
end
end

% Generate the interpolated value based on the bounding points weighted by
% their opposing hypervolumes
interpVal = 0;
totalHypervolume = hypervolume(xyz0,xyz1);
% For each point
for n = 1:nPoints
    % Find the normalized hypervolume
    pointHypervolume = hypervolume(points(n,:),I);
    % Normalize the hypervolume
    nHypervolume = pointHypervolume/totalHypervolume;
    % Find the point opposite the current point
    oppositePointCombo = ~pointCombo(n,:);
    oppositePoint = pointMash(xyz0,xyz1,oppositePointCombo);
    % Weight the point value based on the hypervolume
    interpVal = interpVal + pointToValue(oppositePoint,values,Rx,Ry,Rz)*nHypervolume;
end


function p = pointMash(p1,p2,pI)
    % Combine two points based on pI, where pI are the points of p2 to use
    p = p1.*~pI + p2.*pI;
end

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
    % For each point index
    for a = 1:n
        % Generate the volume
        V = V*abs(p1(a)-p2(a));
    end
end % hypervolume

end % linInterp4
