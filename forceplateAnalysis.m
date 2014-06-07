function forceplateAnalysis
% Plot data from the forceplate alongside data from the robot

% Cleanup
close all
clear all
clc

% The data directory
directory = '/Users/andrew/Desktop/Force Control Testing/';

%{
%% Straight leg initialization, 0.88 m test
filePath = [directory 'atrias_2014-06-06-12-59-10.mat'];
filePath2 = [directory 'force_test00007.txt'];
fitAndPlotForces(filePath,filePath2,[25490:50730]);
title('Feedback Linearization Force Control')

filePath = [directory 'atrias_2014-06-06-12-48-14.mat'];
filePath2 = [directory 'force_test00006.txt'];
fitAndPlotForces(filePath,filePath2,[22480:45400]);
title('PD Force Control')

%% 0.75 m leg initialization, 0.82 m test
filePath = [directory 'atrias_2014-06-05-14-28-14.mat'];
filePath2 = [directory 'force_test00004.txt'];
fitAndPlotForces(filePath,filePath2,[20160:41520]);
title('Feedback Linearization Force Control')

filePath = [directory 'atrias_2014-06-05-14-34-34.mat'];
filePath2 = [directory 'force_test00005.txt'];
fitAndPlotForces(filePath,filePath2,[19950:46180]);
title('PD Force Control')

%% 0.61 m leg initialization, 0.71 m test
filePath = [directory 'atrias_2014-06-07-08-53-42.mat'];
filePath2 = [directory 'force_test00008.txt'];
range = [31810:52390];
points = [34822 37377 39782 42357 44812 44832 47322];
fitAndPlotForces(filePath,filePath2,range,points);
title('Feedback Linearization Force Control')

filePath = [directory 'atrias_2014-06-07-09-05-00.mat'];
filePath2 = [directory 'force_test00009.txt'];
range = [23130:47500];
points = [24292 30607 30627 33072 33097 35207 38037 40647 46727];
fitAndPlotForces(filePath,filePath2,range,points);
title('PD Force Control')

%% 0.61 m leg initialization, 0.84 m test
filePath = [directory 'atrias_2014-06-07-09-44-51.mat'];
filePath2 = [directory 'force_test00010.txt'];
range = [30930:54300];
points = [35635 37765 40255 43155 45220 48010 50515];
fitAndPlotForces(filePath,filePath2,range,points);
title('PD Force Control')

filePath = [directory 'atrias_2014-06-07-09-48-45.mat'];
filePath2 = [directory 'force_test00011.txt'];
range = [34110:50290];
points = [37755 40405 42585 45235 47885];
fitAndPlotForces(filePath,filePath2,range,points);
title('Feedback Linearization Force Control')
%}

%% 0.61 m leg initialization, 0.72 m test, ks = 1727
filePath = [directory 'atrias_2014-06-07-12-30-35.mat'];
filePath2 = [directory 'force_test00013.txt'];
range = [29910:50030];
points = [];
fitAndPlotForces(filePath,filePath2,range,points);
title('PD Force Control')

filePath = [directory 'atrias_2014-06-07-13-27-52.mat'];
filePath2 = [directory 'force_test00014.txt'];
range = [27460:48290];
points = [];
fitAndPlotForces(filePath,filePath2,range,points);
title('Feedback Linearization Force Control')


function fitAndPlotForces(fp, fp2, shortenI, Points)
    [c rs cs] = logfileToStruct(fp,fp2);

    % If the data should be shortened
    if ~isempty(shortenI)
        % Crop to the force test
        rs = shortenData(rs,shortenI);
        cs = shortenData(cs,shortenI);
    end

    figure
    % A time vector
    time = (rs.time-rs.time(1))/1000;
    % What the robot is actually applying
    I = ~isnan(rs.forceplateF);
    plot(time(I), rs.forceplateF(I), 'b')
    hold on
    % What the robot thinks it's applying
    plot(time, -cs.computeFzL, 'r')
    % What the robot wants to apply
    I = ~isnan(cs.fzDes); % Index with no NaNs
    if any(cs.fzDes(I) ~= 0) % For feedback linearization
        plot(time, cs.fzDes, 'c')
    else % For PD control
        plot(time, -cs.controlFzL, 'c')
    end

    % Fit the force data if given points to fit
    if ~isempty(Points)
        % Fit the data
        bestFit = fitForceData(rs,Points);
        display(['Best fit force offset: ' num2str(bestFit.y0)])
        display(['Best fit spring constant: ' num2str(bestFit.ks)])

        % Find the world forces
        force = rsToWorldForce(rs, bestFit.ks);
        LFz = bestFit.y0 - force.LF.Fz;

        plot(time, LFz,'g')
    else
        display('Not fitting force data, legend will have extra entries.')
    end

    % Plot properties
    xlabel('Time (s)')
    ylabel('Force (N)')
    ylim([0 450])
    xlim([0 20])
    legend('Forceplate Measured','Robot Measured','Desired','Best Fit','Location','NorthEast')
end % fitAndPlotForces

end % forceplateAnalysis
