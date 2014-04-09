% Cleanup
clc
close all

% Toe data
toe = v_log__robot__state_lToeSwitch;

% Change type from uint16 to double
toe = double(toe);

%{
% For debugging
% Count the number of instances
num = 256;
toeMod = mod(toe,num);
toeModCount = NaN(1,num+1);
for n = 1:(num+1)
    toeModCount(n) = sum(toeMod == n-1);
end

plot(0:num,toeModCount,'.')

% Don't execute the rest of the program
return
%}

% Preallocate
toeFilt = toe;

% For each sample
for n = 2:length(toe)
    % Remove the top and bottom extreme
    if (toe(n) == 4095) || (toe(n) == 0)
        toeFilt(n) = toeFilt(n-1);
    end
    % If the data jumps by more than 1000, ignore the datapoint
    if abs(toeFilt(n-1) - toeFilt(n)) > 1000
        toeFilt(n) = toeFilt(n-1);
    end
end

% Rolling average
roll = 4;
for n = (roll+1):length(toe)
    toeFilt(n) = mean(toeFilt((n-roll):n));
end

% TODO: Make stance and flight indicators

% Display the data
plot(toe,'.b')
hold on
plot(toeFilt,'.r')

% Debug
%toeDiff = diff(toe);
%plot(toeDiff,'.g')
