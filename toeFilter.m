% Cleanup
clc
close all

% Toe data
toe = v_log__robot__state_lToeSwitch;

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

% For each sample
for n = 2:length(toe)
    % Remove the top and bottom extreme
    if (toe(n) == 4095) || (toe(n) == 0)
        toe(n) = toe(n-1);
    end
    % If the remainder is...
    r = mod(toe(n),256);
    if any(r == [0 9 10 14 15 50 51 52 53 54 55 71 73 128 255])
        toe(n) = toe(n-1);
    end
end

% Rolling average
roll = 10;
toeRoll = NaN(1,length(toe));
for n = (roll+1):length(toe)
    toeRoll(n) = mean(toe((n-roll):n));
end

% Display the data
plot(toe,'.b')
%hold on
%plot(toeRoll,'.r')
