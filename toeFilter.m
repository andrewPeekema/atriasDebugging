classdef toeFilter < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        n  % number of history points
        h  % history
        t  % value threshold
    end

    methods
        function o = toeFilter(window,threshold)
            o.n = window;
            o.h = zeros(1,window);  % history
            o.t = threshold;
        end

        function b = switched(o,y)
            o.h = [o.h(2:end) y];
            b = median(o.h);
            %b = b > o.t;
        end

    end

end

