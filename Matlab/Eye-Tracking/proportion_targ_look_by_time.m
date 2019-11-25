%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ploting prop of looking %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This will plot the proportion of all trials for all 
% subjects in which a child was looking toward the 
% target object / targ + distract by time window (set below) for
% the length of the trial

clear

% load data
projFolder = 'C:\Users\antovich\Desktop\VOX data';
projName = 'Vox';
fname = fullfile(projFolder,[projName 'CompData.txt']);
data = tdfread(fname, 'tab');

% Set trial length (ms), window size(ms) for proportions and timing of the
% target word onset (ms)
triallength = 3000;
windowsize = 50;
wordonset = 750;
onset = (wordonset/windowsize);

% Convert char arrays into cell arrays
data.Subject = cellstr(data.Subject);
data.L_AOI_Hit = cellstr(data.L_AOI_Hit);
data.L_Event_Info = cellstr(data.L_Event_Info);
data.Stimulus = cellstr(data.Stimulus);

% Set masks for which trials (based on stimulus name) you want to compare
incorrectmask = ~cellfun(@isempty, regexpi(data.Stimulus, 'tog|dook|gar|vaby|foo|gall'));
correctmask = ~cellfun(@isempty, regexpi(data.Stimulus, 'dog|book|car|baby|shoe|ball'));

eventID = unique(data.L_Event_Info);
nEvent = length(eventID);
subID = unique(data.Subject);
nSub = length(subID);
trialID  = unique(data.Stimulus);
nTrial = length(trialID);

% Masks to get the fixation events, and target/distractor AOI events
fixmask = strcmp(data.L_Event_Info,  'Fixation');
targetmask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, 'Target'));
distractmask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, 'Distract'));

% Create a list of time windows that I would like to look at events within
nint = triallength/windowsize;
timewindow = 0:windowsize:triallength;
for int = 1:nint
    interval(int).minmax = [timewindow(int) (timewindow(int+1)-1)];
end

% Preallocate my eventin variable
eventin = NaN(length(data.TrialTime),1);
% For each interval set up above
for int = 1:nint
    % Get max
    currintmin = interval(int).minmax(1);
    % Get min
    currintmax = interval(int).minmax(2);
    % For each eye-tracker event
    for ievent = 1:length(data.TrialTime)
        % If the element falls within the current interval, eventin
        % returns true, else returns false
        eventin(ievent) = currintmin<=data.TrialTime(ievent) && data.TrialTime(ievent)<currintmax;
        fprintf('Working on subj %s, interval %d - %d\n',data.Subject{ievent}, currintmin, currintmax);
    end % end eye-tracker event loop
    % Logical masks to select the fixation events in a given condition(incorrect vs correct) 
    % towards a given AOI (target vs distractor) that fall within the current interval 
    correcttargmask = eventin & fixmask & correctmask & targetmask;
    correctdistmask = eventin & fixmask & correctmask & distractmask;
    incorrecttargmask = eventin & fixmask & incorrectmask & targetmask;
    incorrectdistmask = eventin & fixmask & incorrectmask & distractmask;
    % Determines proportion of eye-tracker events toward the target
    % object over events towards both the target and distractor in both
    % conditions
    incorrprop(int) = sum(incorrecttargmask)/sum(incorrectdistmask+incorrecttargmask);
    corrprop(int) = sum(correcttargmask)/sum(correctdistmask+correcttargmask);
    chance(int) = 0.5;
end % end interval loop

% Plot the incorrect pronunciation looking proportion
plot(incorrprop,'r^:')
hold on
% Plot the correct pronunciation looking proportion
plot(corrprop,'go-')
% plot line at %50 for chance looking
plot(chance,'k--')
% plot vertical line for word onset 
line([onset onset],[0 1], 'Color', [0 0 0], 'LineStyle',':' )
legend('Incorrect Pronunciation','Correct Pronunciation', 'Chance Looking','Word Onset','Location','NorthWest')
title('Proportion of looking towards target object by condition')
xlabel('Trial Time (ms)')
ylabel('Proportion')
set(gca,'XTickLabel',0:(10*windowsize):triallength)
