function returnData = filterData(data,roll)
% Input
%       data = struct of data
%       roll = number of samples to average
% Output
%       fData = filtered data

% If the time field exists
if isfield(data,'time')
    % Same and remove the time vector
    time = data.time;
    data = rmfield(data,'time');
end

% Filter all vectors in the struct
returnData = structfun(@filt,data,'UniformOutput',false);

% If the time field existed
if exist('time')
    % Re-insert the shortened time vector
    returnData.time = time(roll:end);
end


% Filter the vector
function filtD = filt(d)
    % Preallocate
    filtD = d;

    % For each sample
    for n = roll:length(d)
        % Rolling average
        filtD(n) = mean(filtD((n-roll+1):n));
    end

    % Remove the unfiltered points
    filtD = filtD(roll:end);
end

end % function fData
