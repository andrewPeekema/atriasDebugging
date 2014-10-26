function interpVal = linInterp2(I,values,R1,R2)
% A linear interpolation function for 2 dimensions
% Simplified implementation of linInterp4 for algorithm testing
% Interpolation formula from:
% http://bmia.bmt.tue.nl/people/BRomeny/Courses/8C080/Interpolation.pdf
% Input
%   I: Point that will be interpolated to
%   values: Matrix of values with the same dimensions as the ranges
%   R1, R2: Ranges that the values matrix covers

% Bound the target point to the variable range
I(1) = max(I(1),R1(1));   % Lower bound
I(1) = min(I(1),R1(end)); % Upper bound
I(2) = max(I(2),R2(1));   % Lower bound
I(2) = min(I(2),R2(end)); % Upper bound

% Calculate the upper and lower bounding points given the target point
% Find the lower point
ia = sum(R1 <= I(1));
ib = sum(R2 <= I(2));
% Bound these points to one less than the maximum vector length
ia = min(ia,length(R1)-1);
ib = min(ib,length(R2)-1);
lowerPoint = [R1(ia) R2(ib)];
% The upper point
upperPoint = [R1(ia+1) R2(ib+1)];

% Generate bounding hypercube points
nPoints = 0;
for i1 = 0:1
for i2 = 0:1
    % Increment the number of points
    nPoints = nPoints + 1;
    % Find the point combination
    pointCombo(nPoints,:) = [i1 i2];
    % Find the point values
    points(nPoints,:) = pointMash(lowerPoint,upperPoint,pointCombo(nPoints,:));
end
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
    oppositePoint = pointMash(lowerPoint,upperPoint,oppositePointCombo);
    % Weight the point value based on the hypervolume
    interpVal = interpVal + pointToValue(oppositePoint,values,R1,R2)*nHypervolume;
end


function p = pointMash(p1,p2,pI)
    % Combine two points based on pI, where pI are the points of p2 to use
    p = p1.*~pI + p2.*pI;
end

function value = pointToValue(p,values,R1,R2)
    % Find the point indices
    p1i = sum(R1 <= p(1));
    p2i = sum(R2 <= p(2));

    % Get the value
    value = values(p1i,p2i);
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

end % linInterp2
