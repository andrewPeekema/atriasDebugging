function rs = simplifyLogfile(filepath)
% Input: logfile path
% Output: robot state struct

% Load the logfile
load(filepath)

% Set constants
rs.m  = 60.0; % kg
rs.ks = 1600; % N*m/rad
rs.g  = 9.81; % m/s^2

% General robot state
% Angles
rs.qLlA = v_log__robot__state_lALegAngle;
rs.qLlB = v_log__robot__state_lBLegAngle;
rs.qRlA = v_log__robot__state_rALegAngle;
rs.qRlB = v_log__robot__state_rBLegAngle;
rs.qLmA = v_log__robot__state_lAMotorAngle;
rs.qLmB = v_log__robot__state_lBMotorAngle;
rs.qRmA = v_log__robot__state_rAMotorAngle;
rs.qRmB = v_log__robot__state_rBMotorAngle;
rs.qLrA = v_log__robot__state_lARotorAngle;
rs.qLrB = v_log__robot__state_lBRotorAngle;
rs.qRrA = v_log__robot__state_rARotorAngle;
rs.qRrB = v_log__robot__state_rBRotorAngle;
rs.qb   = v_log__robot__state_bodyPitch;
% Spring deflections
rs.lADfl = -rs.qLlA+rs.qLmA;
rs.lBDfl =  rs.qLlA-rs.qLmA;
rs.rADfl = -rs.qRlA+rs.qRmA;
rs.rBDfl =  rs.qRlA-rs.qRmA;

% Angular velocities
rs.dqLlA = v_log__robot__state_lALegVelocity;
rs.dqLlB = v_log__robot__state_lBLegVelocity;
rs.dqRlA = v_log__robot__state_rALegVelocity;
rs.dqRlB = v_log__robot__state_rBLegVelocity;
rs.dqLmA = v_log__robot__state_lAMotorVelocity;
rs.dqLmB = v_log__robot__state_lBMotorVelocity;
rs.dqRmA = v_log__robot__state_rAMotorVelocity;
rs.dqRmB = v_log__robot__state_rBMotorVelocity;
rs.dqLrA = v_log__robot__state_lARotorVelocity;
rs.dqLrB = v_log__robot__state_lBRotorVelocity;
rs.dqRrA = v_log__robot__state_rARotorVelocity;
rs.dqRrB = v_log__robot__state_rBRotorVelocity;
rs.dqb   = v_log__robot__state_bodyPitchVelocity;

% Positions and velocities
rs.x = v_log__robot__state_xPosition;
rs.y = v_log__robot__state_yPosition;
rs.z = v_log__robot__state_zPosition;
rs.dx = v_log__robot__state_xVelocity;
rs.dy = v_log__robot__state_yVelocity;
rs.dz = v_log__robot__state_zVelocity;

% Commanded currents
rs.cmdLA = v_log__robot__state_lAClampedCmd;
rs.cmdLB = v_log__robot__state_lBClampedCmd;
rs.cmdRA = v_log__robot__state_rAClampedCmd;
rs.cmdRB = v_log__robot__state_rBClampedCmd;

% The robot state time vector (ms)
rs.time = 1000*v_log__robot__state___time;

%% Controller specific data
if exist('v_ATCSlipWalking__log_walkingState')
    % The controller time vector (ms)
    rs.cTime = 1000*v_ATCSlipWalking__log___time;
    % Single/Double support, left/right legs
    rs.state = double(v_ATCSlipWalking__log_walkingState);
else
    display('simplifyLogfile warning: Unknown controller data format')
end


% If relevant, get timing data
if isfield(rs,'state')
    % Find event transitions in controller time
    rs.event = diff(rs.state);

    % Initialize vectors
    rs.ltd = [];
    rs.rto = [];
    rs.rtd = [];
    rs.lto = [];
    rs.to  = [];
    rs.td  = [];

    % For each possible event
    for n = 1:length(rs.event)
        % Convert controller time to robotState time
        % If there is an event
        if rs.event(n) ~= 0
            % Find the robot state index for this log time
            rsN = find(rs.cTime(n) == rs.time,1,'last');
        end

        % Each type of event
        % Left leg touchdown
        if rs.event(n) == 1
            rs.ltd(end+1) = rsN;
            rs.td(end+1)  = rsN;
        % Right leg takeoff
        elseif rs.event(n) == 2
            rs.rto(end+1) = rsN;
            rs.to(end+1)  = rsN;
        % Right leg touchdown
        elseif rs.event(n) == 3
            rs.rtd(end+1) = rsN;
            rs.td(end+1)  = rsN;
        % Left leg takeoff
        elseif rs.event(n) == -6
            rs.lto(end+1) = rsN;
            rs.to(end+1)  = rsN;
        end % if event
    end % for n


    % Find single support and double support
    % Find the number of single and double support phases
    nSS = length(rs.to);
    nDS = length(rs.td);

    % Assume the first event is takeoff
    % For single support, the last event is touchdown
    nTo = length(rs.to);
    if rs.td(end) < rs.to(end) % If the last event is takeoff
        nTo = nTo-1; % Shorten the number of takeoffs
    end
    % For each singe support phase
    for n = 1:nTo
        rs.SS(n,:) = [rs.to(n) rs.td(n)];
    end

    % For double support, the last event is takeoff
    nTd = length(rs.td);
    if rs.to(end) < rs.td(end) % If the last event is touchdown
        nTd = nTd-1; % Shorten the number of touchdowns
    end
    % For each double support phase
    for n = 1:nTd
        rs.DS(n,:) = [rs.td(n) rs.to(n+1)];
    end

end % isfield


end % simplifyLogfile
