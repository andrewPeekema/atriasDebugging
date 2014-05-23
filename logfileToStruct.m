function [c, rs, cs] = logfileToStruct(filePath)
% Input: logfile path
% Output:
%     c  = robot constants
%     rs = robot state struct
%     cs = controller state struct

% Initialize structs
cs = [];
rs = [];

% Set constants
c.m  = 60.0; % kg
c.ks = 1600; % N*m/rad
c.g  = 9.81; % m/s^2

% Return early if only constants are requested
if nargout == 1
    return
end


% Load the logfile
load(filePath)
display(['Analyzing: ' filePath])

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

% Boom data
rs.qBoom   = v_log__robot__state_boomAngle;
rs.dqBoom  = v_log__robot__state_boomAngleVelocity;
rs.qBoomX  = v_log__robot__state_xAngle;
rs.dqBoomX = v_log__robot__state_xAngleVelocity;

% Torso data
rs.qT  = v_log__robot__state_bodyPitch;
rs.dqT = v_log__robot__state_bodyPitchVelocity;

% Hip Data
rs.qLh  = v_log__robot__state_lLegBodyAngle;
rs.dqLh = v_log__robot__state_lLegBodyVelocity;
rs.qRh  = v_log__robot__state_rLegBodyAngle;
rs.dqRh = v_log__robot__state_rLegBodyVelocity;

% The robot state time vector (ms)
rs.time = 1000*v_log__robot__state___time;

% Calculated angles and lengths
rs.qLl = (rs.qLlA+rs.qLlB)/2;
rs.rLl = cos(rs.qLl-rs.qLlA);
rs.qRl = (rs.qRlA+rs.qRlB)/2;
rs.rRl = cos(rs.qRl-rs.qRlA);
rs.qLm = (rs.qLmA+rs.qLmB)/2;
rs.rLm = cos(rs.qLm-rs.qLmA);
rs.qRm = (rs.qRmA+rs.qRmB)/2;
rs.rRm = cos(rs.qRm-rs.qRmA);


%% Controller specific data
% Return early if controller data is not requested
if nargout == 2
    return
end

if exist('v_ATCSlipWalking__log_walkingState')
    % The controller time vector (ms)
    cs.time = 1000*v_ATCSlipWalking__log___time;
    % Single/Double support, left/right legs
    cs.state = double(v_ATCSlipWalking__log_walkingState);
    cs.rvpp = v_ATCSlipWalking__input_rvpp;
    cs.qvpp = v_ATCSlipWalking__input_qvpp;
    cs.q1   = v_ATCSlipWalking__input_q1;
    cs.q2   = v_ATCSlipWalking__input_q2;
    cs.q3   = v_ATCSlipWalking__input_q3;
    cs.q4   = v_ATCSlipWalking__input_q4;
    cs.r0   = v_ATCSlipWalking__input_leg__length;
    rsTimeN = [1 length(rs.time)];
    cs.controlFxL = NaN(rsTimeN);
    cs.controlFzL = NaN(rsTimeN);
    cs.controlFxR = NaN(rsTimeN);
    cs.controlFzR = NaN(rsTimeN);
    cs.computeFxL = NaN(rsTimeN);
    cs.computeFzL = NaN(rsTimeN);
    cs.computeFxR = NaN(rsTimeN);
    cs.computeFzR = NaN(rsTimeN);
else
    display('simplifyLogfile warning: Unknown controller data format')
end


% If relevant, get timing data
if isfield(cs,'state')
    % Find event transitions in controller time
    cs.event = diff(cs.state);

    % Initialize vectors
    cs.ltd = [];
    cs.rto = [];
    cs.rtd = [];
    cs.lto = [];
    cs.to  = [];
    cs.td  = [];

    % For each possible event
    for n = 1:length(cs.event)
        % Convert controller time to robotState time
        % If there is an event
        if cs.event(n) ~= 0
            % Find the robot state index for this log time
            rsN = find(cs.time(n) == rs.time,1,'last');
        end

        % Each type of event
        % Left leg touchdown
        if cs.event(n) == 1
            cs.ltd(end+1) = rsN;
            cs.td(end+1)  = rsN;
        % Right leg takeoff
        elseif cs.event(n) == 2
            cs.rto(end+1) = rsN;
            cs.to(end+1)  = rsN;
        % Right leg touchdown
        elseif cs.event(n) == 3
            cs.rtd(end+1) = rsN;
            cs.td(end+1)  = rsN;
        % Left leg takeoff
        elseif cs.event(n) == -6
            cs.lto(end+1) = rsN;
            cs.to(end+1)  = rsN;
        end % if event
    end % for n


    %% Find single support and double support
    % Assume the first event is takeoff
    % For single support, the last event is touchdown
    nTo = length(cs.to);
    if cs.td(end) < cs.to(end) % If the last event is takeoff
        nTo = nTo-1; % Shorten the number of takeoffs
    end
    % For each singe support phase
    for n = 1:nTo
        cs.SS(n,:) = [cs.to(n) cs.td(n)];
    end

    % For double support, the last event is takeoff
    nTd = length(cs.td);
    if cs.to(end) < cs.td(end) % If the last event is touchdown
        nTd = nTd-1; % Shorten the number of touchdowns
    end
    % For each double support phase
    for n = 1:nTd
        cs.DS(n,:) = [cs.td(n) cs.to(n+1)];
    end

end % isfield

% If relevant, get force data
if isfield(cs,'controlFxL')
    % Left leg force controller
    forceContTime = v_ATCSlipWalking__ascLegForceL__log___time*1000;
    % For all log times
    for n = 1:length(forceContTime)
        % The robot state time index for this robot state time
        rsN = find(forceContTime(n) == rs.time,1,'last');
        % If this force controller time is in the robot state
        if ~isempty(rsN)
            % Store the contol data
            cs.controlFxL(rsN) = v_ATCSlipWalking__ascLegForceL__log_control__fx(n);
            cs.controlFzL(rsN) = v_ATCSlipWalking__ascLegForceL__log_control__fz(n);
            cs.computeFxL(rsN) = v_ATCSlipWalking__ascLegForceL__log_compute__fx(n);
            cs.computeFzL(rsN) = v_ATCSlipWalking__ascLegForceL__log_compute__fz(n);
        end
    end % for n

    % Right leg force controller
    forceContTime = v_ATCSlipWalking__ascLegForceR__log___time*1000;
    % For all log times
    for n = 1:length(forceContTime)
        % The robot state time index for this robot state time
        rsN = find(forceContTime(n) == rs.time,1,'last');
        % If this force controller time is in the robot state
        if ~isempty(rsN)
            % Store the contol data
            cs.controlFxR(rsN) = v_ATCSlipWalking__ascLegForceR__log_control__fx(n);
            cs.controlFzR(rsN) = v_ATCSlipWalking__ascLegForceR__log_control__fz(n);
            cs.computeFxR(rsN) = v_ATCSlipWalking__ascLegForceR__log_compute__fx(n);
            cs.computeFzR(rsN) = v_ATCSlipWalking__ascLegForceR__log_compute__fz(n);
        end
    end % for n
end % isfield


end % simplifyLogfile
