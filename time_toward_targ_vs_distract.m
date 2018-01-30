%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Looking to Target vs Distractor %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% This script will output a data file called <ProjectName> Targ vs Dist.txt
% The script requires that the CompData file (created in a separate script)
% is available. The file should have headings Subject, TrialTime, Time, L_POR_X, L_POR_Y, L_AOI_Hit, L_Event_Info, & Stimulus
% Change the project name and file location, and indicate whether a time
% window should be used for the analysis.


clear

% load data
projName = 'XSL';
projFolder = ['/Users/Dylan/Desktop/XSL/Double'];

% If data analysis requires a time window, supply window onset and offset
% in milliseconds

UseTimeWindow = 'No'; 
WindowOnset = 100;
WindowOffset = 4000;

% Open a new file to put the Target and Distractor looking times
fid = fopen(fullfile(projFolder,[projName 'Targ vs Dist.txt']),'at');

% Get the data file 
fname = fullfile(projFolder,[projName 'CompData.txt']);
fprintf('...\n...\n...\nPulling in %s data...\n...\n...\n...\n', projName)

tic % Gets the start time to calculate the total time it takes to run this script

% Create a structure called "data" to store the info in the data file
data = tdfread(fname, 'tab');
fprintf('Reading in data took about %d sec...\n...\n...\n...\n', round(toc))

% Convert the char vectors into cells
fprintf('Converting variables into cells...\n...\n...\n...\n')
data.Subject = cellstr(data.Subject);
data.L_AOI_Hit = cellstr(data.L_AOI_Hit);
data.L_Event_Info = cellstr(data.L_Event_Info);
data.Stimulus = cellstr(data.Stimulus);

% Masks to get the fixation events, and target/distractor AOI events,
% test items, and single vs double labeled words
fprintf('Creating masking variables...\n...\n...\n...\n')
targetmask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, 'Target'));
distractmask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, 'Distractor'));

% Decides whether it was indicated that a time window would be used and
% creates a mask for the datapoints within the time window specified above
% or if no time window is needed, the timewindowmask becomes a column of
% all ones, which will not select out any part of the data

if strcmp(UseTimeWindow,'Yes')
    timewindowmask = data.TrialTime>= WindowOnset & data.TrialTime<=WindowOffset;
else timewindowmask = ones(length(data.TrialTime), 1);
end
% Get basic variable info

% List of unique subjects
subID = unique(data.Subject);
% Length of subject list
nSub = length(subID);
% List of unique stimulus names (trials)
trialID  = unique(data.Stimulus);
% Length of stimulus list
nTrial = length(trialID);

% Print column header for data file:
fprintf(fid, 'SubID');
for itrial = 1:nTrial
    fprintf(fid, '\t%s TARG\t%s DIST',trialID{itrial},trialID{itrial});
end
fprintf(fid,'\n');



for isub = 1:nSub
    submask = strcmp(data.Subject, subID(isub));
    fprintf('Working on subject: %s\n...\n...\n...\n', subID{isub})
    fprintf(fid, '%s', subID{isub});
    for itrial = 1:nTrial
        trialmask = strcmp(data.Stimulus,trialID{itrial});
        
        % FOR TARGET
        targcompmask = submask & trialmask & targetmask & timewindowmask;
        targbeg = find(diff(targcompmask)==1)+1; % Gets the beginning of each block of fixation events
        targend = find(diff(targcompmask)==-1); % Gets the end of each block of fixation events
        if length(targbeg)>length(targend) % To ensure that blocks get counted even if they are at the end of a trial
            targend = [targend; find(targcompmask,1,'last')];
        elseif length(targbeg)<length(targend)
            targbeg = [find(targcompmask,1,'first');targbeg];
        end
        targfixs = (data.Time(targend)-data.Time(targbeg))*0.001; % Gets the difference between the time of the first and last fixation event in a block, then converts from microseconds to milliseconds and rounds to a whole number
        
        % FOR DISTRACTOR
        distcompmask = submask & trialmask & distractmask & timewindowmask;
        distbeg = find(diff(distcompmask)==1)+1; % Gets the beginning of each block of fixation events
        distend = find(diff(distcompmask)==-1); % Gets the end of each block of fixation events
        if length(distbeg)>length(distend) % To ensure that blocks get counted even if they are at the end of a trial
            distend = [distend; find(distcompmask,1,'last')];
        elseif length(distbeg)<length(distend)
            distbeg = [find(distcompmask,1,'first');distbeg];
        end
        distfixs = (data.Time(distend)-data.Time(distbeg))*0.001; % Gets the difference between the time of the first and last fixation event in a block, then converts from microseconds to milliseconds and rounds to a whole number
        % print to the total fixation time per trial for target and
        % distractor to the file
        
        fprintf(fid,'\t%d\t%d',round(sum(targfixs)),round(sum(distfixs)));
    end % end trial loop
    fprintf(fid,'\n');
end % end subject loop

fclose(fid); % close the Targ vs Dist file

fprintf('Done with data file')
