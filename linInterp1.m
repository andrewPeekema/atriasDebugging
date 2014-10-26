function interpVal = linInterp1(I,values,R1)
% A linear interpolation function for 1 dimension
% Simplified implementation of linInterp4 for algorithm testing
% Interpolation formula from:
% http://bmia.bmt.tue.nl/people/BRomeny/Courses/8C080/Interpolation.pdf
% Input
%   I: Point that will be interpolated to
%   values: Matrix of values with the same dimensions as the ranges
%   R1: Range that the values matrix covers

% Bound the target point to the variable range
I(1) = max(I(1),R1(1));   % Lower bound
I(1) = min(I(1),R1(end)); % Upper bound

% Calculate the upper and lower bounding points given the target point
% Find the lower point
ia = sum(R1 <= I(1));
% Bound these points to one less than the maximum vector length
ia = min(ia,length(R1)-1);
lowerPoint = R1(ia);
% The upper point
upperPoint = R1(ia+1);

% Generate bounding hypercube points
nPoints = 0;
for i1 = 0:1
    % Increment the number of points
    nPoints = nPoints + 1;
    % Find the point combination
    pointCombo(nPoints,:) = i1;
    % Find the point values
    points(nPoints,:) = pointMash(lowerPoint,upperPoint,pointCombo(nPoints,:));
end

% Generate the interpolated value based on the bounding points weighted by
% their opposing hypervolumes
interpVal = 0;
totalHypervolume = hypervolume(lowerPoint,upperPoint);
% For each point
for n = 1:nPoints
    % Find the normalized hypervolume
    pointHypervolume = hypervolume(points(n,:),I);
    % Normalize the hypervolume
    nHypervolume = pointHypervolume/totalHypervolume;
    % Find the point opposite the current point
    oppositePointCombo = double(~pointCombo(n,:));
    oppositePoint = pointMash(lowerPoint,upperPoint,oppositePointCombo)
    % Weight the point value based on the hypervolume
    interpVal = interpVal + pointToValue(oppositePoint,values,R1)*nHypervolume;
end


function p = pointMash(p1,p2,pI)
    % Combine two points based on pI, where pI are the points of p2 to use
    p = p1.*~pI + p2.*pI;
end

function value = pointToValue(p,values,R1)
    % Find the point indices
    p1i = sum(R1 <= p(1));

    % Get the value
    value = values(p1i);
end % pointToValue

function V = hypervolume(p1,p2)
    % p1, p2: points with n dimensions
    lengthP = length(p1);

    % Find the volume
    V = 1;
    % For each point index
    for a = 1:lengthP
        % Generate the volume
        V = V*abs(p1(a)-p2(a));
    end
end % hypervolume

end % linInterp1
