% The logfile to analyze
filePath = '/Users/andrew/Documents/MATLAB/atriasDebugging/data/2014-03-31-10-49-04-vpp-walking-11-steps/atrias_2014-03-31-10-49-04.mat';
[c rs cs] = logfileToStruct(filePath);

rs = shortenData(rs,[52490:62770]);  % atrias_2014-03-31-10-49-04
