function [c, rs, cs] = logfileToStruct(varargin)
% Input:
%     varargin{1} = logfile path (.mat)
%     varargin{2} = force data path (.txt)
% Output:
%     c  = robot constants
%     rs = robot state struct
%     cs = controller state struct

% Initialize structs
cs = [];
rs = [];

% Set constants
c.m  = 60.0; % kg
c.ks = 4400; % N*m/rad
c.g  = 9.81; % m/s^2

% Return early if only constants are requested
if nargout == 1
    return
end

% Load the logfile if a path is given
if length(varargin) >= 1
    % Load the logfile
    load(varargin{1})
    display(['Analyzing: ' varargin{1}])
else
    return
end

% Robot data format:
%         1   2   3   4   5   6   7   8   9   10 11 12 13
% state: rBl rBm rAl rAm lBl lBm lAl lAm rHm lHm bR bY bP
%         14   15   16   17   18   19   20   21   22   23   24  25  26
% state: drBl drBm drAl drAm dlBl dlBm dlAl dlAm drHm dlHm dbR dbY dbP
%        27 28 29 30 31 32 33 34
% state: rB rA rH lB lA lH t  t
% time

% Angles
rs.qLlA = state(:,7);
rs.qLlB = state(:,5);
rs.qRlA = state(:,3);
rs.qRlB = state(:,1);
rs.qLmA = state(:,8);
rs.qLmB = state(:,6);
rs.qRmA = state(:,4);
rs.qRmB = state(:,2);
rs.qLh  = state(:,10);
rs.qRh  = state(:,9);
rs.qb   = state(:,13);
% Spring deflections
rs.lADfl = -rs.qLlA+rs.qLmA;
rs.lBDfl =  rs.qLlB-rs.qLmB;
rs.rADfl = -rs.qRlA+rs.qRmA;
rs.rBDfl =  rs.qRlB-rs.qRmB;

% Angular velocities
rs.dqLlA = state(:,7+13);
rs.dqLlB = state(:,5+13);
rs.dqRlA = state(:,3+13);
rs.dqRlB = state(:,1+13);
rs.dqLmA = state(:,8+13);
rs.dqLmB = state(:,6+13);
rs.dqRmA = state(:,4+13);
rs.dqRmB = state(:,2+13);
rs.dqLh  = state(:,10+13);
rs.dqRh  = state(:,9+13);
rs.dqb   = state(:,13+13);

% Commanded torques
rs.cmdLA = state(:,31);
rs.cmdLB = state(:,30);
rs.cmdLH = state(:,32);
rs.cmdRA = state(:,28);
rs.cmdRB = state(:,27);
rs.cmdRH = state(:,29);

% Toe Sensors
rs.lToe = state(:,33); % TODO: Check the L/R convention
rs.rToe = state(:,34); % TODO: Check the L/R convention

% Boom data
rs.bR  = state(:,11);
rs.bY  = state(:,12);
rs.bP  = state(:,13);
rs.dbR = state(:,11+13);
rs.dbY = state(:,12+13);
rs.dbP = state(:,13+13);

% The robot state time vector (ms)
rs.time = time;

% Calculated angles and lengths
rs.qLl = (rs.qLlA+rs.qLlB)/2;
rs.rLl = cos(rs.qLl-rs.qLlA);
rs.qRl = (rs.qRlA+rs.qRlB)/2;
rs.rRl = cos(rs.qRl-rs.qRlA);
rs.qLm = (rs.qLmA+rs.qLmB)/2;
rs.rLm = cos(rs.qLm-rs.qLmA);
rs.qRm = (rs.qRmA+rs.qRmB)/2;
rs.rRm = cos(rs.qRm-rs.qRmA);


% TODO: Fix for the new system
%{
%% Load the force data if a path is given
if length(varargin) == 2
    fpRaw = csvread(varargin{2});
    fpHz = 200;
    display(['Analyzing: ' varargin{2}])
    display(['(Assuming forceplate data was captured at a rate of ' num2str(fpHz) ' Hz)'])

    % Make NaN vectors the same length as rs.time
    rs.forceplateFx = NaN(length(rs.time),1);
    rs.forceplateFy = NaN(length(rs.time),1);
    rs.forceplateFz = NaN(length(rs.time),1);
    rs.forceplateF  = NaN(length(rs.time),1);

    % The first forceplate point in terms of the rs index
    fpI = find(v_log__robot__state_rtOpsState==2,1);

    % If the controller starts as enabled, we didn't catch the beginning of the
    % controller data and our timing is off
    if fpI == 1
        display('WARNING: forceplate data timing is inaccurate')
    end

    % How many rs samples per one forceplate sample?
    fpdI = 1000/fpHz;

    % What is the last forceplate sample in terms of the rs index?
    fpEnd = fpI - 1 + length(fpRaw)*fpdI;

    % Add the force data to the robot state struct
    rs.forceplateFx(fpI:fpdI:fpEnd) = fpRaw(:,1);
    rs.forceplateFy(fpI:fpdI:fpEnd) = fpRaw(:,2);
    rs.forceplateFz(fpI:fpdI:fpEnd) = fpRaw(:,3);
    rs.forceplateF = (rs.forceplateFx.^2 + rs.forceplateFy.^2 + rs.forceplateFz.^2).^0.5;
end
%}


%% Controller specific data
% Return early if controller data is not requested
if nargout == 2
    return
end

% Return controller specific data after this if necessary

display(['Finished analyzing: ' varargin{1}])

end % logfileToStruct
