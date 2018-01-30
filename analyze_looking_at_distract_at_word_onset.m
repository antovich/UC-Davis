%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get data for kids looking at distractor at target word onset %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script will pull out data for kids who were looking at the
% distractor object for a given window around the target word onset, with a
% given onset time

% THIS ASSUMES ALL DATA POINTS WERE COLLECTED AT THE SAME FREQUENCY (i.e.
% 120Hz)

clear 
format SHORT G
% Load data
projFolder = 'C:\Users\antovich\Desktop\Raw Data';
projName = 'Vox';
fname = fullfile(projFolder,[projName 'CompData.txt']);
data = tdfread(fname, 'tab');

% Set target word onset(ms) and window around 
% target word onset(number of data points,each datapt ~= 8ms at 120Hz) during which
% the child cannot have looked at the target

targonset = 500;
pretargwindow = 10;
posttargwindow = 4;
% Convert char arrays into cell arrays
data.Subject = cellstr(data.Subject);
data.L_AOI_Hit = cellstr(data.L_AOI_Hit);
data.L_Event_Info = cellstr(data.L_Event_Info);
data.Stimulus = cellstr(data.Stimulus);

subID = unique(data.Subject);
nSub = length(subID);
stimID = unique(data.Stimulus);
nStim = length(stimID);
aoiID = unique(data.L_AOI_Hit);

% Set masks to identify trials with incorrect or correct pronunciation of the
% target work (based on stimulus file name)
incorrectmask = ~cellfun(@isempty, regexp(data.Stimulus, 'tog|dook|gar|vaby|foo|gall'));
correctmask = ~cellfun(@isempty, regexp(data.Stimulus, 'dog|book|car|baby|shoe|ball'));

% Set masks to look at the pre distractor as well as pre and post targ AOIs
% Masks to get the fixation events, and target/distractor AOI events
fixmask = strcmp(data.L_Event_Info,  'Fixation');
targetmask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, 'Target'));
distractmask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, 'Distract'));

% Create counters for each of output vector
a = 0;
b = 0;
c = 0;
d = 0;
e = 0;
f = 0;
g = 0;
h = 0;

% Loop through each subject
for isub = 1:nSub                                                   
    currsub = subID{isub};
    submask = strcmp(data.Subject, currsub);
    % Loop through each stimulus (based on file name)
    for istim = 1:nStim
        currstim = stimID{istim};
        stimmask = strcmp(data.Stimulus,currstim); 
        % Mask to find all data points that occur before the target word
        % onset (defined above)
        premask = data.TrialTime<=targonset;
        % Mask to find all data points that occur after the target word
        % onset (defined above)
        postmask = data.TrialTime>=targonset;
        % Mask to find fixations events towards the distractor object
        compmask = distractmask & fixmask;
        % Mask to look at events pre & post target word onset for the
        % current subject in the current trial
        precompmask = submask & stimmask & premask;
        postcompmask = submask & stimmask & postmask;
        % If statement to see if a specified number of events directly before and after the 
        % target word onset (timing defined above in targonset and number 
        % of events defined above in pre- or posttargwindow) are all
        % fixations towards the distractor for this subject in this trial
        if sum(compmask(find(precompmask,pretargwindow,'last')))==pretargwindow && sum(compmask(find(postcompmask,posttargwindow,'first')))==posttargwindow
            fprintf('Sub %s, trial %s is in!\n', currsub, currstim)
            % Sets up masks to be used below that target fixations towards 
            % both the target and distractor, before and after the target
            % word onset in both the correct and incorrect pronunciation
            % condition for the current subject and trial
            postincorrdistmask = submask & stimmask & fixmask & postmask & incorrectmask & distractmask;
            postcorrdistmask = submask & stimmask & fixmask & postmask & correctmask & distractmask;
            preincorrdistmask = submask & stimmask & fixmask & premask & incorrectmask & distractmask;
            precorrdistmask = submask & stimmask & fixmask & premask & correctmask & distractmask;
            postincorrtargmask = submask & stimmask & fixmask & postmask & incorrectmask & targetmask;
            postcorrtargmask = submask & stimmask & fixmask & postmask & correctmask & targetmask;
            preincorrtargmask = submask & stimmask & fixmask & premask & incorrectmask & targetmask;
            precorrtargmask = submask & stimmask & fixmask & premask & correctmask & targetmask;
            % This series of if statements relates to the different
            % condition/timing/target masks set up above. If there are any
            % candidates from the mask, this determines the beginning and
            % end of each contiguos block of fixations towards the appropriate object
            % in the appropriate condition at the appropriate time window.
            % Then the initial time of the fixation block is subtracted
            % from the final time to get a net dwell time for that
            % fixation. This is then summed for each trial for each subject
            % the letter should be a count of the number of trials that
            % could be included. 
            if any(postincorrdistmask)
                a = a+1;
                poindilast = find(diff(postincorrdistmask)==-1);
                poindifirst = find(diff(postincorrdistmask)==1)+1;
                poindifixtime(a) = sum(data.TrialTime(poindilast) - data.TrialTime(poindifirst));
            else a = a+1; poindifixtime(a) = 0;
            end
            if any(postcorrdistmask)
                b = b+1;
                pocodilast = find(diff(postcorrdistmask)==-1);
                pocodifirst = find(diff(postcorrdistmask)==1)+1;
                pocodifixtime(b) = sum(data.TrialTime(pocodilast) - data.TrialTime(pocodifirst));
            else b = b+1; pocodifixtime(b) = 0;
            end
            if any(preincorrdistmask)
                c = c+1;
                prindilast = find(diff(preincorrdistmask)==-1);
                prindifirst = find(diff(preincorrdistmask)==1)+1;
                prindifixtime(c) = sum(data.TrialTime(prindilast) - data.TrialTime(prindifirst));
            else c = c+1; prindifixtime(c) = 0;
            end
            if any(precorrdistmask)
                d = d+1;
                prcodilast = find(diff(precorrdistmask)==-1);
                prcodifirst = find(diff(precorrdistmask)==1)+1;
                prcodifixtime(d) = sum(data.TrialTime(prcodilast) - data.TrialTime(prcodifirst));
            else d = d+1; prcodifixtime(d) = 0;
            end
            if any(postincorrtargmask)
                e = e+1;
                pointalast = find(diff(postincorrtargmask)==-1);
                pointafirst = find(diff(postincorrtargmask)==1)+1;
                pointafixtime(e) = sum(data.TrialTime(pointalast) - data.TrialTime(pointafirst));
            else e = e+1; pointafixtime(e) = 0;
            end
            if any(postcorrtargmask)
                f = f+1;
                pocotalast = find(diff(postcorrtargmask)==-1);
                pocotafirst = find(diff(postcorrtargmask)==1)+1;
                pocotafixtime(f) = sum(data.TrialTime(pocotalast) - data.TrialTime(pocotafirst));
            else f = f+1; pocotafixtime(f) = 0;
            end
            if any(preincorrtargmask)
                g = g+1;
                printalast = find(diff(preincorrtargmask)==-1);
                printafirst = find(diff(preincorrtargmask)==1)+1;
                printafixtime(g) = sum(data.TrialTime(printalast) - data.TrialTime(printafirst));
            else g = g+1; printafixtime(g) = 0;
            end
            if any(precorrtargmask)
                h = h+1;
                prcotalast = find(diff(precorrtargmask)==-1);
                prcotafirst = find(diff(precorrtargmask)==1)+1;
                prcotafixtime(h) = sum(data.TrialTime(prcotalast) - data.TrialTime(prcotafirst));
            else h = h+1; prcotafixtime(h) = 0;
            end
        end
    end
end

corrtotalprop = sum(pocotafixtime)/(sum(pocotafixtime) + sum(pocodifixtime));
corrmeanprop = mean(pocotafixtime)/(mean(pocotafixtime) + mean(pocodifixtime));
incorrtotalprop = sum(pointafixtime)/(sum(pointafixtime) + sum(poindifixtime));
incorrmeanprop = mean(pointafixtime)/(mean(pointafixtime) + mean(poindifixtime));

precorrtotalprop = sum(prcotafixtime)/(sum(prcotafixtime) + sum(prcodifixtime));
precorrmeanprop = mean(prcotafixtime)/(mean(prcotafixtime) + mean(prcodifixtime));
preincorrtotalprop = sum(printafixtime)/(sum(printafixtime) + sum(prindifixtime));
preincorrmeanprop = mean(printafixtime)/(mean(printafixtime) + mean(prindifixtime));

length(
indcorrtotalprop = (pocotafixtime/(pocotafixtime + pocodifixtime))-(pointafixtime/(pointafixtime + poindifixtime));
indincorrtotalprop =;


propdiff = corrtotalprop-incorrtotalprop;
[rejectnulltotal,pvaltotal] = ttest(totaldiff);
[rejectnullprop,pvalprop] = ttest(propdiff);

