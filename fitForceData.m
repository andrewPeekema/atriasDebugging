function sol = fitForceData(rs,points)
% Input:
%   rs: a robot state struct
%   points: the points that should be matched
% Output:
%   sol.y0: an offset
%   sol.ks: The spring constant that best fits the data

% Search for the best data fit
options = optimset(...
    'TolX',1e-18,...
    'TolFun',1e-18,...
    'MaxFunEvals',1500,...
    'UseParallel','always',...
    'Display','none');
%    'Display','iter');

% Remove all NaN samples
fpI = ~isnan(rs.forceplateF);
F = rs.forceplateF(fpI);
rs.time = rs.time(fpI);
rs.qLmA = rs.qLmA(fpI);
rs.qLmB = rs.qLmB(fpI);
rs.qRmA = rs.qRmA(fpI);
rs.qRmB = rs.qRmB(fpI);
rs.qLlA = rs.qLlA(fpI);
rs.qLlB = rs.qLlB(fpI);
rs.qRlA = rs.qRlA(fpI);
rs.qRlB = rs.qRlB(fpI);
rs.qb   = rs.qb(fpI);

% Convert from time to indices
for x = 1:length(points)
    I(x) = find(round(rs.time) == points(x),1,'first');
end
points = I';

% Best guess for spring stiffness and force offset
guess = [1600;
         0];

bestGuess = fminsearch(@sumOfSquares,guess,options);

% Return the best guess
sol.ks = bestGuess(1);
sol.y0 = bestGuess(2);

function s = sumOfSquares(Guess)
    % Get the world forces
    force = rsToWorldForce(rs, Guess(1));

    % Offset the data
    LFz = Guess(2) - force.LF.Fz;

    % Sum of squares error
    s = sum((LFz(points) - F(points)).^2);
end % function sumOfSquares

end % function fitForceData
