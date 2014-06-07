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
c.ks = 1600; % N*m/rad
c.g  = 9.81; % m/s^2

% Return early if only constants are requested
if nargout == 1
    return
end

% Load the logfile if a path is given
if length(varargin) >= 1
    % Any structs that are loaded need to be declared beforehand in order to be
    % used by parfor
    v_ATCForceControlDemo__log_fxDes = [];
    v_ATCForceControlDemo__log_fzDes = [];
    v_ATCForceControlDemo__ascLegForceL__log_control__fx = [];
    v_ATCForceControlDemo__ascLegForceL__log_control__fz = [];
    v_ATCForceControlDemo__ascLegForceL__log_compute__fx = [];
    v_ATCForceControlDemo__ascLegForceL__log_compute__fz = [];
    % Load the logfile
    load(varargin{1})
    display(['Analyzing: ' varargin{1}])
else
    return
end

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


%% Controller specific data
% Return early if controller data is not requested
if nargout == 2
    return
end

if exist('v_ATCSlipWalking__log___time')
    % The controller time vector (ms)
    atcTime = 1000*v_ATCSlipWalking__log___time;
    % Single/Double support, left/right legs
    cs.state = double(v_ATCSlipWalking__log_walkingState);
    cs.rvpp = v_ATCSlipWalking__input_rvpp;
    cs.qvpp = v_ATCSlipWalking__input_qvpp;
    cs.q1   = v_ATCSlipWalking__input_q1;
    cs.q2   = v_ATCSlipWalking__input_q2;
    cs.q3   = v_ATCSlipWalking__input_q3;
    cs.q4   = v_ATCSlipWalking__input_q4;
    cs.r0   = v_ATCSlipWalking__input_leg__length;
    % Preallocate
    rsTimeN = [1 length(rs.time)];
    controlFxL = NaN(rsTimeN);
    controlFzL = NaN(rsTimeN);
    controlFxR = NaN(rsTimeN);
    controlFzR = NaN(rsTimeN);
    computeFxL = NaN(rsTimeN);
    computeFzL = NaN(rsTimeN);
    computeFxR = NaN(rsTimeN);
    computeFzR = NaN(rsTimeN);

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
            rsN = find(atcTime(n) == rs.time,1,'last');
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

    % Left leg force controller
    forceContTime = v_ATCSlipWalking__ascLegForceL__log___time*1000;
    % Find which robot state times have a subcontroller time
    rsSubBool = ismember(rs.time, forceContTime);
    % Get the robot state indices for those times
    rsIndices = find(rsSubBool)';
    % For each robot state time that has a subcontroller time
    for rsN = rsIndices
        % Find the subcontroller time for this robot state time
        n = find(rs.time(rsN) == forceContTime,1,'last');
        % Store the control data
        controlFxL(rsN) = v_ATCSlipWalking__ascLegForceL__log_control__fx(n);
        controlFzL(rsN) = v_ATCSlipWalking__ascLegForceL__log_control__fz(n);
        computeFxL(rsN) = v_ATCSlipWalking__ascLegForceL__log_compute__fx(n);
        computeFzL(rsN) = v_ATCSlipWalking__ascLegForceL__log_compute__fz(n);
    end

    % Right leg force controller
    forceContTime = v_ATCSlipWalking__ascLegForceR__log___time*1000;
    % Find which robot state times have a subcontroller time
    rsSubBool = ismember(rs.time, forceContTime);
    % Get the robot state indices for those times
    rsIndices = find(rsSubBool)';
    % For each robot state time that has a subcontroller time
    for rsN = rsIndices
        % Find the subcontroller time for this robot state time
        n = find(rs.time(rsN) == forceContTime,1,'last');
        % Store the control data
        controlFxR(rsN) = v_ATCSlipWalking__ascLegForceR__log_control__fx(n);
        controlFzR(rsN) = v_ATCSlipWalking__ascLegForceR__log_control__fz(n);
        computeFxR(rsN) = v_ATCSlipWalking__ascLegForceR__log_compute__fx(n);
        computeFzR(rsN) = v_ATCSlipWalking__ascLegForceR__log_compute__fz(n);
    end

    % Store the forces in the controller state struct
    cs.controlFxL = controlFxL;
    cs.controlFzL = controlFzL;
    cs.computeFxL = computeFxL;
    cs.computeFzL = computeFzL;
    cs.controlFxR = controlFxR;
    cs.controlFzR = controlFzR;
    cs.computeFxR = computeFxR;
    cs.computeFzR = computeFzR;


elseif exist('v_ATCForceControlDemo__log___time')
    % The controller time vector (ms)
    atcTime = 1000*v_ATCForceControlDemo__log___time;
    rsTimeN = [1 length(rs.time)];
    % Preallocate
    fxDes = NaN(rsTimeN);
    fzDes = NaN(rsTimeN);
    controlFxL = NaN(rsTimeN);
    controlFzL = NaN(rsTimeN);
    computeFxL = NaN(rsTimeN);
    computeFzL = NaN(rsTimeN);

    % Space controller data out
    % Left leg force controller
    forceContTime = v_ATCForceControlDemo__ascLegForceL__log___time*1000;
    % For each robot state time
    parfor rsN = 1:length(rs.time)
        % Find the subcontroller time for this robot state time
        n = find(rs.time(rsN) == atcTime,1,'last');
        % If the subcontroller has a time for this robot state time
        if ~isempty(n)
            % Store the data
            fxDes(rsN) = v_ATCForceControlDemo__log_fxDes(n);
            fzDes(rsN) = v_ATCForceControlDemo__log_fzDes(n);
        end

        % Find the subcontroller time for this robot state time
        n = find(rs.time(rsN) == forceContTime,1,'last');
        % If the subcontroller has a time for this robot state time
        if ~isempty(n)
            % Store the contol data
            controlFxL(rsN) = v_ATCForceControlDemo__ascLegForceL__log_control__fx(n);
            controlFzL(rsN) = v_ATCForceControlDemo__ascLegForceL__log_control__fz(n);
            computeFxL(rsN) = v_ATCForceControlDemo__ascLegForceL__log_compute__fx(n);
            computeFzL(rsN) = v_ATCForceControlDemo__ascLegForceL__log_compute__fz(n);
        end
    end

    % Store the variables in the controller state struct
    cs.fxDes      = fxDes;
    cs.fzDes      = fzDes;
    cs.controlFxL = controlFxL;
    cs.controlFzL = controlFzL;
    cs.computeFxL = computeFxL;
    cs.computeFzL = computeFzL;

else
    display('WARNING: Unknown controller data format')

end



display(['Finished analyzing: ' varargin{1}])

end % simplifyLogfile
