function forceplateAnalysis
% Plot data from the forceplate alongside data from the robot

% Cleanup
close all
clear all
clc

% The data directory
directory = '/Users/andrew/Desktop/Force Control Testing/';

% Analyze a logfile
filePath = [directory 'atrias_2014-06-06-12-59-10.mat'];
filePath2 = [directory 'force_test00007.txt'];
fitAndPlotForces(filePath,filePath2,[25490:50730]);
title('Feedback Linearization Force Control')

% Analyze another logfile
filePath = [directory 'atrias_2014-06-05-14-28-14.mat'];
filePath2 = [directory 'force_test00004.txt'];
fitAndPlotForces(filePath,filePath2,[20160:41520]);
title('Feedback Linearization Force Control')

% Analyze another logfile
filePath = [directory 'atrias_2014-06-06-12-48-14.mat'];
filePath2 = [directory 'force_test00006.txt'];
fitAndPlotForces(filePath,filePath2,[22480:45400]);
title('PD Force Control')

% Analyze another logfile
filePath = [directory 'atrias_2014-06-05-14-34-34.mat'];
filePath2 = [directory 'force_test00005.txt'];
fitAndPlotForces(filePath,filePath2,[19950:46180]);
title('PD Force Control')

function fitAndPlotForces(fp, fp2, shortenI)
    [c rs cs] = logfileToStruct(fp,fp2);

    % If the data should be shortened
    if ~isempty(shortenI)
        % Crop to the force test
        rs = shortenData(rs,shortenI);
        cs = shortenData(cs,shortenI);
    end

    % Fit the force data
    bestFit = fitForceData(rs);
    display(['Best fit force offset: ' num2str(bestFit.y0)]);
    display(['Best fit spring constant: ' num2str(bestFit.ks)]);

    % Find the world forces
    force = rsToWorldForce(rs, bestFit.ks);
    LFz = bestFit.y0 - force.LF.Fz;

    figure
    plot(rs.time, rs.forceplateF,'.');
    hold on
    %plot(rs.time, cs.fzDes,'b')
    plot(rs.time, -cs.computeFzL,'r')
    plot(rs.time, LFz,'g')

    xlabel('Time (s)')
    ylabel('Force (N)')
end % fitAndPlotForces

end % forceplateAnalysis
