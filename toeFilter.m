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
roll = 5;
for n = (roll+1):length(toe)
    toeFilt(n) = mean(toeFilt((n-roll):n));
end

% Display the data
plot(toe,'.b')
hold on
plot(toeFilt,'.r')

% Detect Stance
% Baseline samples
nStartAvg = 120;
nEndAvg   = 20;
% Preallocate
stance = zeros(1,length(toeFilt));
threshold = zeros(1,length(toeFilt));
% For each datapoint
for n = (nStartAvg+1):length(toeFilt)
    % Threshold value
    startN = n-nStartAvg;
    endN   = n-nEndAvg;
    threshold(n) = 200;
    threshold(n) = mean(toeFilt(startN:endN))+threshold(n);
    % In stance if the value is greater than the threshold
    stance(n) = toeFilt(n) > threshold(n);
end
% Plot stance
plot(stance.*threshold,'b')

%{
% Stance is the baseline value plus some threshold
flightVal = mean(toeFilt(1:20))
%flightVal = mean(toeFilt(4000:5000))
threshold = 400;
stance = toeFilt > (flightVal+threshold);
% Plot stance
plot(stance*(flightVal+threshold),'b')
%}
