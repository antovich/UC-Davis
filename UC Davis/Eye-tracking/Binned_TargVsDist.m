%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%     Binned proportion of looking towards target across trials    %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          

clear

% Yields a proportion of looking toward the correct
% object per subject, averaged across all trials within specified time bins

% SubInfo file MUST BE CONVERTED TO WINDOWS LINE BREAK FORMAT (Can be done
% in TextWrangler)

% Identify project name and data folder
projName = 'PhonoSeg';
projFolder = ['/Users/Dylan/Desktop/', projName];
SubInfoFileName = 'SubInfo';

% Specify bin size etc. (ms)

BinSize = 200;
MaxTrialLength = 4400;

% Identify AOI labels (must be exact)
obj1AOIlabel = 'Lang';
obj2AOIlabel = 'Reen';

% Identify test stimuli target (must be exact)
obj1STIMlabel = 'lang test';
obj2STIMlabel = 'reen test';

% Open data file and load data
fname = fullfile(projFolder,[projName 'CompData.txt']);
fname2 = fullfile(projFolder,[SubInfoFileName '.txt']);

fprintf('...\n...\n...\nPulling in %s data...\n...\n...\n...\n', projName)

tic
data = tdfread(fname, 'tab');
SubInfo = tdfread(fname2, 'tab');
fprintf('Reading in data took about %d sec...\n...\n...\n...\n', round(toc))

% Convert string variables to cells
fprintf('Converting variables into cells...\n...\n...\n...\n')
data.Subject = cellstr(data.Subject);
data.L_AOI_Hit = cellstr(data.L_AOI_Hit);
data.L_Event_Info = cellstr(data.L_Event_Info);
data.Stimulus = cellstr(data.Stimulus);
SubInfo.Subject = cellstr(SubInfo.Subject);
SubInfo.Condition = cellstr(SubInfo.Condition);
SubInfo.Gender = cellstr(SubInfo.Gender);
SubInfo.Inclusion_Status = cellstr(SubInfo.Inclusion_Status);

fprintf('Creating masking variables...\n...\n...\n...\n')

% Mark the test trials and AOI hits
obj1mask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, obj1AOIlabel));
obj2mask = ~cellfun(@isempty, regexpi(data.L_AOI_Hit, obj2AOIlabel));
obj1lab = ~cellfun(@isempty, regexpi(data.Stimulus, obj1STIMlabel));
obj2lab = ~cellfun(@isempty, regexpi(data.Stimulus, obj2STIMlabel));
testmask = logical(obj1lab + obj2lab);
nrows = length(data.Stimulus);

fprintf('Binning data...\n...\n...\n...\n')

% Designate bins based on time provided above
BinEdge = 0:BinSize:MaxTrialLength;
BinEnds = BinEdge - 1;

% Create a list of the time bins
starts = BinEdge(1:(length(BinEdge)-1));
ends = BinEnds(2:length(BinEnds));

for list = 1:length(starts)
    currbin = sprintf('%d-%dms', starts(list),ends(list));
    BinList(list) = cellstr(currbin);
end

% Mark each sample with one of the bins specified above
[~,data.Bin] = histc(data.TrialTime,BinEdge);

% Identifies which time bin each line of data falls under, based on the
% trial time variable, and creates a variable indicating whether each data line
% is a hit to the target or elsewhere
for irow = 1:nrows
    % Make Target variable, where target hit = 1, other looks = 0
    if obj1mask(irow) & obj1lab(irow)
        data.Target(irow) = 1;
    elseif obj2mask(irow) & obj2lab(irow)
        data.Target(irow) = 1;
    else data.Target(irow) = 0;
    end
end

% Gets a list of all the time bins
bins = unique(data.Bin(testmask));
nBins = length(bins);

fprintf('Creating BinnedTrialAvg file for %s...\n...\n...\n...\n', projName)

% Open a new file for the binned data
fid = fopen(fullfile(projFolder,[projName 'BinnedTrialAvg.txt']),'at');
fprintf(fid,'SubID\tCondition\tOrder\tInclusionStatus');
for ibins = 1:nBins
    fprintf(fid,'\t%s',BinList{ibins});
end
fprintf(fid,'\n');

subID = unique(data.Subject);
nSub = length(subID);

% Averages the number of data samples (lines) looking toward the target (1) versus
% distrator (0), which yields a proportion of looking toward the correct
% object for each subject averaged across all trials within each time bin

for isub = 1:nSub
    submask = strcmp(subID{isub},data.Subject);
    subinfomask = strcmp(subID{isub},SubInfo.Subject);
    fprintf(fid,'%s\t%s\t%d\t%s',subID{isub},SubInfo.Condition{subinfomask},SubInfo.Order(subinfomask),SubInfo.Inclusion_Status{subinfomask});
    for ibins = 1:nBins
        binsmask = data.Bin == bins(ibins);
        currmean(isub,ibins) = mean(data.Target(binsmask & submask & testmask));
        fprintf(fid,'\t%g', currmean(isub,ibins));
    end
    fprintf(fid,'\n');
end

fclose(fid); % close the BinnedTrialAvg file
fprintf('Done creating data file...\n')

    
