%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                               %%
%%   Reformat Frame-by-frame Data Coding File    %%
%%                                               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                                   %%
%%   Fill in the following information, then run the full script (including this):   %%
%%                                                                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ProjectName = 'PROJECT NAME';
foldername = '/Users/Dylan/Desktop/';
filename = 'PROJECT NAME Data.txt';

framerate = 30;               % Framerate for the original stimuli (default 30frames/sec)
windowonset = 367;            % Onset for the target analysis window (i.e., F367)
windowoffset = 2000;          % Offset for the target analysis window (i.e., F'windowoffset')         

containsFamiliar = 1;         % Should be 1 if the data contains familiar objects
minTrials = 8;                % Minimum number of trials each subject must contribute to be included
minTrialTypeNOV = 2;          % Minimun number of each trial type that each subject must contribute to be included 
minTrialFAM = 2;              % Minimum number of familiar trials (if used) of any type that the subject must have completed
awayCrit = 0.5;               % Proportion of frames for each trial during the analysis window that must be looks towards one of the objects for the trial to be included
NovObjBias = 0.75;            % Percent of looking time towards a novel object during the PRELABEL window beyond which that trial is considered to have an extreme object bias    

famobject1 = 'INSERT NAME';   % Familiar object1 name, as it appears in the data file
famobject2 = 'INSERT NAME';   % Familiar object2 name, as it appears in the data file
famobject3 = 'INSERT NAME';   % Familiar object3 name, as it appears in the data file
famobject4 = 'INSERT NAME';   % Familiar object4 name, as it appears in the data file

novelobject1 = 'INSERT NAME'; % Target object1 name, as it appears in the data file
novelobject2 = 'INSERT NAME'; % Target object2 name, as it appears in the data file
novelobject3 = 'INSERT NAME'; % Target object3 name, as it appears in the data file
novelobject4 = 'INSERT NAME'; % Target object4 name, as it appears in the data file

agerange1 = 0:0;              % Age group #1's age range (to create AGE variable from months column of data)
agelabel1 = 'INSERT NAME';    % Provide label for age group 1
agerange2 = 0:0;              % Age group #2's age range (to create AGE variable from months column of data)
agelabel2 = 'INSERT NAME';    % Provide label for age group 2
agerange3 = 0:0;              % Age group #3's age range (to create AGE variable from months column of data)
agelabel3 = 'INSERT NAME';    % Provide label for age group 3


condition1 = 'INSERT NAME';   % Keyword string for identifiying condition 1 (SEPARATE KEYWORDS WITH |)
cond1lab   = 'INSERT NAME';   % New grouping variable name for condition 1
condition2 = 'INSERT NAME';   % Keyword string for identifiying condition 2 (SEPARATE KEYWORDS WITH |)
cond2lab   = 'INSERT NAME';   % New grouping variable name for condition 2
condition3 = 'INSERT NAME';   % Keyword string for identifiying condition 3 (SEPARATE KEYWORDS WITH |)
cond3lab   = 'INSERT NAME';   % New grouping variable name for condition 3
condition4 = 'INSERT NAME';   % Keyword string for identifiying condition 4 (SEPARATE KEYWORDS WITH |)
cond4lab   = 'INSERT NAME';   % New grouping variable name for condition 4


%%%%%%%%%%%%%%%%%%%%%%%%%
%%                     %%
%%    Reformatting:    %%
%%                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%

tic

% This will give an error if the folder does not exist in the current
% directory
if ~isdir(foldername)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', foldername);
  uiwait(warndlg(errorMessage));
  return;
end

fprintf('\n\n\n\n\n\nPulling in data...\n...\n...\n...\n')
warning('off','stats:dataset:subsasgn:DefaultValuesAddedVariable')
warning('off','stats:dataset:genvalidnames:ModifiedVarnames')
data = dataset('File',fullfile(foldername,filename), 'ReadVarNames', true);
nrows = length(data.SubNum);
extrahead = sum(strcmp(data.SubNum,'Sub Num')); % Gets number of extra header rows

fprintf('Deleting extra headers...\n...\n...\n...\n')
for irow = 1:(nrows-extrahead) 
    
    % Deletes extra header rows
    if strcmp(data.SubNum(irow),'Sub Num')  
        data(irow,:) = [];
    end 
    
end


nrows = length(data.SubNum);
data.Months = str2double(data.Months); % Convert Month string to numeric values
WindowOnset = find(strcmp(data.Properties.VarNames, ['F',num2str(windowonset)])); % find the column number for the window onset (F0)
WindowOffset = find(strcmp(data.Properties.VarNames, ['F',num2str(windowoffset)])); % find the column number for the window offset (F'windowoffset')
BeforeOnset = find(strcmp(data.Properties.VarNames,'CritOffSet'))+1; % Find the column number for the before window onset (B0)
BeforeOffset = WindowOnset-1; % Find the column number for the before window offset (B'windowonset-1')
novelobjects = [novelobject1,'|',novelobject2,'|',novelobject3,'|',novelobject4];
famobjects = [famobject1,'|',famobject2,'|',famobject3,'|',famobject4];

% Loop to create the before window variable names
for ivar = 0:(BeforeOffset-BeforeOnset)
    dvar = (ivar+1);
    beforevar{1, dvar} = sprintf('B%d',round(ivar*(1000/framerate)));
end

% Loop to add before window variable names
for ivar = BeforeOnset:BeforeOffset
    dvar = ivar-BeforeOnset+1;
    data.Properties.VarNames{ivar} = beforevar{dvar};
end

fprintf('Creating Age, Group, and Accuracy variables...\n...\n...\n...\n')
fid2 = fopen(fullfile(foldername,[ProjectName, 'Disqual.txt']),'w');
fprintf(fid2,'SubNum\tTrial\tReason\n');
for irow = 1:nrows
    
    % Creates an Age grouping variable based on the info from the Months
    % column and ranges above
    if ismember(data.Months(irow), agerange1);
        data.Age(irow) = {agelabel1};
    elseif ismember(data.Months(irow), agerange2);
        data.Age(irow) = {agelabel2};
    elseif ismember(data.Months(irow), agerange3);
        data.Age(irow) = agelabel3;
    else data.Age(irow) = {'UNKNOWN AGE'};
    end % End if statement for Age grouping
    
    % Creates a Condition grouping variable based on the info from the Order variable and the labesl above
    if any(~cellfun(@isempty, regexpi(data.Order(irow), condition1)));
        data.Condition(irow) = {cond1lab};
    elseif any(~cellfun(@isempty, regexpi(data.Order(irow), condition2)));
        data.Condition(irow) = {cond2lab};
    elseif any(~cellfun(@isempty, regexpi(data.Order(irow), condition3)));
        data.Condition(irow) = {cond3lab};
    elseif any(~cellfun(@isempty, regexpi(data.Order(irow), condition4)));
        data.Condition(irow) = {cond4lab};
    else  data.Condition(irow) = {'UNKNOWN CONDITION'};
    end % End if statement for Condition grouping
    
    % Creating an accuracy variable for before and after the target window (specified above)
    aft = dataset2cell(data(irow,WindowOnset:WindowOffset)); % Creates a string with the values within the analysis window specified above
    bef = dataset2cell(data(irow,BeforeOnset:BeforeOffset)); % Creates a string with the values befpore the analysis window specified above
    
    aft = aft(2,:); % removes dataset headers
    bef = bef(2,:);
    
    windowavg = ~cellfun(@isempty,regexp(aft,'1|0')); % Selets just the frames with look towards target/dist (zeros or ones) during the target window
    beforeavg = ~cellfun(@isempty,regexp(bef,'1|0')); % Selets just the frames with look towards target/dist (zeros or ones) before the target window
    
    data.AfterAccur(irow) = mean(str2double(aft(windowavg))); % Gets the mean of the zeros and ones (reflecting accuracy) in the target window
    data.BeforeAccur(irow) = mean(str2double(bef(beforeavg))); % Gets the mean of the zeros and ones (reflecting accuracy) before the target window         
    data.DiffAftBefore(irow) = data.AfterAccur(irow) - data.BeforeAccur(irow);
    
    % Prints to the disqualified file 
    if sum(windowavg) < (awayCrit*length(aft))
       fprintf(fid2,'%s\t%s\tAway\n', data.SubNum{irow},data.TrNum{irow}); 
       data.Delete(irow) = 1;
    elseif data.BeforeAccur(irow) > NovObjBias || data.BeforeAccur(irow) < 1-NovObjBias && ~cellfun(@isempty, regexpi(data.TargetImage(irow), novelobjects));
       fprintf(fid2,'%s\t%s\tAway\n', data.SubNum{irow},data.TrNum{irow}); 
       data.Delete(irow) = 1;
    else data.Delete(irow) = 0;

    end

end % End for loop

data(data.Delete==1,:)=[]; % Delete the rows that do not meet looking qualification (determined above)

data.SubNum = str2double(data.SubNum);
subid = unique(data.SubNum);
nsub = length(subid);
targid = unique(data.TargetImage);
ntarg = length(targid);
NumSubRemoved = 0;

fammask = ~cellfun(@isempty, regexpi(data.TargetImage, famobjects));
novelmask = ~cellfun(@isempty, regexpi(data.TargetImage, novelobjects));
nov1mask = ~cellfun(@isempty, regexpi(data.TargetImage, novelobject1));
nov2mask = ~cellfun(@isempty, regexpi(data.TargetImage, novelobject2));
nov3mask = ~cellfun(@isempty, regexpi(data.TargetImage, novelobject3));
nov4mask = ~cellfun(@isempty, regexpi(data.TargetImage, novelobject4));
fam1mask = ~cellfun(@isempty, regexpi(data.TargetImage, famobject1));
fam2mask = ~cellfun(@isempty, regexpi(data.TargetImage, famobject2));
fam3mask = ~cellfun(@isempty, regexpi(data.TargetImage, famobject3));
fam4mask = ~cellfun(@isempty, regexpi(data.TargetImage, famobject4));

fprintf('Averaging across trial types...\n...\n...\n...\n')
for isub = 1:nsub
    submask = data.SubNum == subid(isub);
    if sum(submask) < minTrials 
        fprintf(fid2,'%d\tAll\tMinTrialNum\n', subid(isub));
        data.Delete(submask) = 1;
        NumSubRemoved = NumSubRemoved+1;
    elseif sum(submask & nov1mask) < minTrialTypeNOV
        fprintf(fid2,'%d\tAll\tMinTrialNum\n', subid(isub));
        data.Delete(submask) = 1;
        NumSubRemoved = NumSubRemoved+1;
    elseif ~any(strcmp(novelobject2,'INSERT NAME')) && sum(submask & nov2mask) < minTrialTypeNOV
        fprintf(fid2,'%d\tAll\tMinTrialNum\n', subid(isub));
        data.Delete(submask) = 1;
        NumSubRemoved = NumSubRemoved+1;
    elseif ~any(strcmp(novelobject3,'INSERT NAME')) && sum(submask & nov3mask) < minTrialTypeNOV
        fprintf(fid2,'%d\tAll\tMinTrialNum\n', subid(isub));
        data.Delete(submask) = 1;
        NumSubRemoved = NumSubRemoved+1;
    elseif ~any(strcmp(novelobject4,'INSERT NAME')) && sum(submask & nov4mask) < minTrialTypeNOV
        fprintf(fid2,'%d\tAll\tMinTrialNum\n', subid(isub));
        data.Delete(submask) = 1;
        NumSubRemoved = NumSubRemoved+1;
    elseif containsFamiliar == 1 && sum(submask) < minTrials
           fprintf(fid2,'%d\tAll\tMinTrialNum\n', subid(isub)); 
           data.Delete(submask) = 1;
           NumSubRemoved = NumSubRemoved+1;
    elseif containsFamiliar == 1 && sum(submask & fammask) < minTrialFAM
        fprintf(fid2,'%d\tAll\tMinTrialNum\n', subid(isub)); 
        data.Delete(submask) = 1;
        NumSubRemoved = NumSubRemoved+1;
    else data.Delete(submask) = 0;
    end
    
    if containsFamiliar == 1 
    famcompmask = submask & fammask;
    famtargavgAFT(isub) = nanmean(data.AfterAccur(famcompmask));
    famtargavgBEF(isub) = nanmean(data.BeforeAccur(famcompmask));
    famtargavgDIF(isub) = nanmean(data.DiffAftBefore(famcompmask));
    else famtargavgAFT(isub) = 'N/A';
         famtargavgBEF(isub) = 'N/A';
    end
    novcompmask = submask & novelmask;
    novtargavgAFT(isub) = nanmean(data.AfterAccur(novcompmask));
    novtargavgBEF(isub) = nanmean(data.BeforeAccur(novcompmask));
    novtargavgDIF(isub) = nanmean(data.DiffAftBefore(novcompmask));
end
fprintf(fid2,'TotalSubsRemoved\t%d\tNA\n', NumSubRemoved);

data(data.Delete==1,:) = []; % Delete all of subjects data that do not meet the number of trials criteria determined above

fprintf('Writing to file...\n...\n...\n...\n')
fid = fopen(fullfile(foldername,[ProjectName, 'Formatted.txt']),'w');
fprintf(fid,'SubNum\tSex\tAgeGroup\tCondition\tFamiliarBefore\tFamiliarAfter\tFamDiff\tNovelBefore\tNovelAfter\tNovDiff\n');

subid = unique(data.SubNum);
nsub = length(subid);
for isub = 1:nsub
    subindex = find(data.SubNum == subid(isub),1,'first');
    fprintf(fid,'%d\t%s\t%s\t%s\t%f\t%f\t%f\t%f\t%f\t%f\n', subid(isub), data.Sex{subindex}, data.Age{subindex}, data.Condition{subindex}, famtargavgBEF(isub), famtargavgAFT(isub), famtargavgDIF(isub), novtargavgBEF(isub), novtargavgAFT(isub), novtargavgDIF(isub)); 
end  

fclose(fid);
fclose(fid2);
warning('on','stats:dataset:subsasgn:DefaultValuesAddedVariable')
warning('on','stats:dataset:genvalidnames:ModifiedVarnames')

timing = toc;
fprintf('DONE!. It took %.2f seconds to reformat this file\n',timing)


