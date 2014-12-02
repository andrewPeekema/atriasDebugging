classdef dampingCheck < handle
    % Check to see if this encoder is decelerating

    properties
        v0 = 0; % Initial velocity [rad/s]
        t  = 0; % Time decelerating [s]
        vMin = 0.3; % Minimum velocity [rad/s]
        % TODO: check to see how long it would take to exceed vMin = 0.3.  0.3
        % rad/sec should be an order of magnitude above the noise floor
    end

    properties % TODO: add protections
        gearRatio = 50;   % [unitless]
        maxCurrent = 100; % [A]
        motorConstant = ?; % [?]
        reflectedMotorInertia = ???*gearRatio^2; % [?]
        expectedDecelConst = gearRatio*maxCurrent*motorConstant/reflectedMotorInertia; % [?]
        % TODO: Check units of expectedDecelConst
    end

    methods
        function o = dampingCheck(vMin)
            % Set the minimum velocity (0.3 rad/s is reasonable)
            o.vMin = abs(vMin);
        end % dampingCheck

        function o = initialVelocity(o,v0)
            % Time starts when v0 is set
            o.v0 = v0;
            o.t  = 0;
        end % initialVelocity

        % Check if deceleration has failed
        % Given
        %   v: Current velocity
        % Return
        %   o: object with incremented time variable
        %   decelFail: true if failing to decelerate
        function [o,decelFail] = checkDeceleration(o,v)
            % Increment time
            o.t = o.t + 0.001;

            % Boundary equation
            vBound = abs(o.v0) + o.vMin - o.expectedDecelConst*o.t*0.9;
            % TODO: Check units of vBound

            % Set a minimum bounding velocity
            vBound = max(abs(vBound), abs(o.vMin));

            % If we're not slowing down
            if abs(v) > vBound
                decelFail = true;
            else % We are slowing down
                decelFail = false;
            end
        end % checkDeceleration

    end % methods

end % dampingCheck
