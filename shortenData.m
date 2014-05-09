function returnData = shortenData(data,n)
% Input:
%       data = struct of data with vectors of uniform length
%       n = index vector
% Output:
%       returnData = pruned data

% Shorten all vectors in the struct
returnData = structfun(@shorten,data,'UniformOutput',false);

% Shorten the vector
function D = shorten(d)
    D = d(n);
end

end % function returnData
