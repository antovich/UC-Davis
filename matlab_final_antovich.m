clear 
format SHORTG
% load data
fname = fullfile('C:','Users','antovich','Desktop','vox_sample_data.txt');
vox = tdfread(fname, 'tab');

% convert the strings variables to cell arrays of strings  
vox.Subject = cellstr(vox.Subject);
vox.Area_of_Interest = cellstr(vox.Area_of_Interest);
vox.Stimulus = cellstr(vox.Stimulus);
vox.Trial = cellstr(vox.Trial);

subID = unique(vox.Subject);
nSub = length(subID);
stimID = unique(vox.Stimulus);
nStim = length(stimID);
aoiID = unique(vox.Area_of_Interest);
incorrect = {'tog','dook','gar','vaby','foo','gall'};
correct = {'dog','book','car','baby','shoe','ball'};

% Masks to identify trials with incorrect or correct pronunciation of the
% target work (based on stimulus file name)
incorrectmask = ~cellfun(@isempty, regexp(vox.Stimulus, 'tog|dook|gar|vaby|foo|gall'));
correctmask = ~cellfun(@isempty, regexp(vox.Stimulus, 'dog|book|car|baby|shoe|ball'));

cellfun(@(x)(any(~cellfun(@isempty,regexp(x,incorrect)))),vox.Stimulus);

% Create counters for each of my output vectors
a = 1;
b = 1;
c = 1;
d = 1;
% Loop through each subject
for isub = 1:nSub                                                   
    currsub = subID{isub};
    submask = strcmp(vox.Subject, currsub);
    % Loop through each stimulus (based on file name)
    for istim = 1:nStim
        currstim = stimID{istim};
        stimmask = strcmp(vox.Stimulus,currstim);
        % Logical mask for the target object AOI before the onset of target
        % word and after
        pretargmask = strcmp(vox.Area_of_Interest, 'Target_Pre');
        posttargmask = strcmp(vox.Area_of_Interest, 'Target_Post');
        postdistmask = strcmp(vox.Area_of_Interest, 'Distract_Post');
        compmask = stimmask & submask & pretargmask;
        % Only select trials where the infant did not look at the target
        % before the onset of the word (not hits to pre-word
        % onset target object AOI
        if vox.Dwell_Time_ms_(compmask)==0
           % Get the the post word onset target AOI dwell time
           incorrtargmask = stimmask & submask & posttargmask & incorrectmask;
           % If this is an instance that exists in the data, add the dwell
           % time to the data vector 
           if sum(incorrtargmask)~=0
              incorrtarg(a) = vox.Net_Dwell_Time_ms_(incorrtargmask);
              a = a+1;
           end
           corrtargmask = stimmask & submask & posttargmask & correctmask;
           % If this is an instance that exists in the data, add the dwell
           % time to the data vector 
           if sum(corrtargmask)~=0
              corrtarg(b) = vox.Net_Dwell_Time_ms_(corrtargmask);
              b = b+1;
           end
           % Get the the post word onset distractor AOI dwell time
           incorrdistmask = stimmask & submask & postdistmask & incorrectmask;
           % If this is an instance that exists in the data, add the dwell
           % time to the data vector 
           if sum(incorrdistmask)~=0
              incorrdist(c) = vox.Net_Dwell_Time_ms_(incorrdistmask);
              c = c+1;
           end
           % If this is an instance that exists in the data, add the dwell
           % time to the data vector 
           corrdistmask = stimmask & submask & postdistmask & correctmask;
           if sum(corrdistmask)~=0
              corrdist(d) = vox.Net_Dwell_Time_ms_(corrdistmask);
              d = d+1;
           end
        end
    end
end


nct = length(corrtarg);
ncd = length(corrdist);
nit = length(incorrtarg);
nid = length(incorrdist);

for iprop = 1:nct
    corrprop(iprop) = corrtarg(iprop)/(corrdist(iprop)+corrtarg(iprop));
end
for iprop = 1:nit
    incorrprop(iprop) = incorrtarg(iprop)/(incorrdist(iprop)+incorrtarg(iprop));
end

[rejectnulltotal,pvaltotal] = ttest2(incorrtarg, corrtarg);
[rejectnullprop,pvalprop] = ttest2(incorrprop, corrprop);



clear

% load data
fname = fullfile('C:','Users','antovich','Desktop','matlab_vox_sub1.txt');
voxevent = tdfread(fname, 'tab');

% Convert char arrays into cell arrays
voxevent.Event_Type = cellstr(voxevent.Event_Type);
voxevent.trial = cellstr(voxevent.trial);
voxevent.AOI_hit = cellstr(voxevent.AOI_hit);

eventID = unique(voxevent.Event_Type);
nEvent = length(eventID);
subID = unique(voxevent.Subject);
nSub = length(subID);
trialID  = unique(voxevent.trial);
nTrial = length(trialID);

incorrectmask = ~cellfun(@isempty, regexpi(voxevent.trial, 'tog|dook|gar|vaby|foo|gall'));
correctmask = ~cellfun(@isempty, regexpi(voxevent.trial, 'dog|book|car|baby|shoe|ball'));
fixmask = strcmp(voxevent.Event_Type,  'Fixation_L');
targetmask = ~cellfun(@isempty, regexpi(voxevent.AOI_hit, 'Target'));
distractmask = ~cellfun(@isempty, regexpi(voxevent.AOI_hit, 'Distract'));

% Create variables that will provide event timing based on the beginning of
% the trial rather than the beginning of the experiment, and convert from
% microseconds to milliseconds
for itrial = 1: nTrial
    % Select the current trial
    trialmask = strcmp(voxevent.trial,trialID(itrial));
    % Get the starting index of that trial
    trialstart = find(trialmask,1);
    % calculate the timing of the events in ms based on the starttime of
    % the trial
    voxevent.starttime(trialmask,1) = (voxevent.Start(trialmask)-voxevent.Start(trialstart))*0.001;
    voxevent.endtime(trialmask,1) = (voxevent.End(trialmask)-voxevent.Start(trialstart))*0.001;
end

% Create a list of all interval time points between the beginning and end
% of an event
for ievent = 1:length(voxevent.starttime)
    voxevent.interval(ievent,1).time = voxevent.starttime(ievent):1:voxevent.endtime(ievent);
end

nint = 3000/100;
timewindow = 0:100:3000;
for int = 1:nint
    interval(int).event = [timewindow(int) (timewindow(int+1)-1)];
end

% For each interval set up above
for int = 1:nint
    % Get max
    currintmin = interval(int).event(1);
    % Get min
    currintmax = interval(int).event(2);
    % For each eye-tracker event
    for ievent = 1:length(voxevent.starttime)
        % Get the sublist of time range created above
        currint = voxevent.interval(ievent).time;
        % For each element of the time range
        for subevent = 1:length(currint)
            % If the element falls within the current interval, subventin
            % returns true, else returns false
            subeventin(subevent) = currintmin<=voxevent.interval(ievent).time(subevent) && voxevent.interval(ievent).time(subevent)<=currintmax;
            fprintf('Working on subj %d, interval %d - %d\n',voxevent.Subject(ievent), currintmin, currintmax);
        end
        % If any elements in the sublist of the time range for the current
        % event were within the current interval, eventin returns true,
        % else false
        eventin(ievent,1) = any(subeventin);
        subeventin = [];
    end
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
end
plot(10,0:.05:1,'k-')
plot(incorrprop,'r^:')
hold on
plot(corrprop,'go-')
plot(chance,'k--')
legend('Incorrect Pronunciation','Correct Pronunciation', 'Chance', 'Location','NorthWest')
title('Proportion of children looking towards target object by condition')
xlabel('Trial Time (ms)')
ylabel('Proportion')
set(gca,'XTickLabel',0:500:3000)
mTextBox = uicontrol('style','text');
set(mTextBox,'String','Word Onset >>>','Units','characters', 'Position',[62 8 18 1], 'BackgroundColor', [1 1 1])
clf

