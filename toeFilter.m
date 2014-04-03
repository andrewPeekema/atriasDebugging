% Cleanup
clc
close all

% Toe data
toe = v_log__robot__state_lToeSwitch;

% For each sample
for n = 2:length(toe)
    % Remove the top and bottom extreme
    if (toe(n) == 4095) || (toe(n) == 0)
        toe(n) = toe(n-1);
    end
    %{
    % If the remainder is 10
    r = mod(toe(n),256);
    if any(r == [0 9 10 14 15 50 51 52 53 54 55 71 73 128 255])
        toe(n) = toe(n-1);
    end
    %}
end

% Rolling average
roll = 50;
toeRoll = NaN(1,length(toe));
for n = (roll+1):length(toe)
    toeRoll(n) = mean(toe((n-roll):n));
end

% Display the data
plot(toe,'.b')
hold on
plot(toeRoll,'.r')

%{
% Count the number of instances
toeMod = mod(toe,256);
toeModCount = NaN(1,257);
for n = 1:257
    toeModCount(n) = sum(toeMod == n-1);
end

plot(0:256,toeModCount,'.')
%}
