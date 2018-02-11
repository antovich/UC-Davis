%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Script to reformat raw SMI eye-tracker data %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This will take all of the files in a folder and concatenate the data 
% as well as adding a subject variable based on file name and a trial timing variable
% that will give the relative timing of events within a trial in ms rather
% than across all trials in microseconds

% The files should have the header variables "Time" "Type" "Trial"
% "L POR X [px]" "L POR Y [px]" "L AOI Hit" "L Event Info"
% "Stimulus"

% The trial timing variable assumes that the original file was organized in chronological
% order, that each stimulus file constitutes a trial, and that there are no stimuli that occur twice back-to-back

% If there are issues, the original data files may need to be converted to
% Windows line break format for processing in Matlab. This can be done with
% the free program TextWrangler.

clear

% Folder where all files to be concatenated are stored, AND ONLY THOSE
% FILES

projName = 'XSL';

projFolder = ['/Users/Dylan/Desktop/XSL/Double'];

% This will give an error if the folder does not exist in the current
% directory
if ~isdir(projFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', projFolder);
  uiwait(warndlg(errorMessage));
  return;
end

% Finds all of the .txt files in the folder specified above
filePattern = fullfile(projFolder, '*.txt');
dataFiles = dir(filePattern);

fprintf('\n\n\nCreating data file\n...\n...\n')
% Creates a new file called 'CompData' that will hold all participant's
% data, all data will be appended to this file
fid = fopen(fullfile(projFolder,[projName 'CompData.txt']),'at');

% Prints the header at the top of the txt file 'CompData'
fprintf(fid, 'Subject\tTrialTime\tTime\tL_POR_X\tL_POR_Y\tL_AOI_Hit\tL_Event_Info\tStimulus\n');

% Loops through each txt file in the directory
for itxt = 1:length(dataFiles)
    tic
    % Creates a structure with variables from the current txt file
    fprintf('Working on file %s...\n...\n', dataFiles(itxt).name)
    data = tdfread(fullfile(projFolder,dataFiles(itxt).name));
    nrows = length(data.Time);
    
    % Convert the char vectors into cells
    data.L_AOI_Hit = cellstr(data.L_AOI_Hit);
    data.L_Event_Info = cellstr(data.L_Event_Info);
    data.Stimulus = cellstr(data.Stimulus);
   

    % Create a variable that will provide event timing based on the beginning of
    % the stimulus trial rather than the beginning of the experiment, and convert from
    % microseconds to milliseconds
    
    % Gives each data line a stimulus number
    [~,~,c] = unique(data.Stimulus);
    % A logical mask indicating the starting line of each trial, based on changes in the stimulus number 
    trialstartmask = logical([1;(diff(c)~=0)]);
    
    % Loops through each line
    for itime = 1:nrows
        % If it is the beginning of the trial (based on '1' value in
        % trialstartmask) then that time is marked as the zero point for
        % the trial, until another zero point is encountered
        if trialstartmask(itime) == 1
            zeromark = data.Time(itime);
            data.TrialTime(itime) = 0;
        % If it is not the beginning of the trial (based on '0' value in
        % trialstartmask) then the zero point determined above is
        % subtracted from the current line's time, and converted from
        % microseconds to milliseconds
        elseif trialstartmask(itime) == 0
            data.TrialTime(itime) = (data.Time(itime) - zeromark)*.001;
        end
    end
    
    % Removes the extra info from the file name (i.e., study name) to create a subject ID 
    s = regexp(dataFiles(itxt).name,'_','split');
    
    % Add a variable for the Subject
    % Print data to CompData file
    for irow = 1:nrows
        % Takes the subject number out from the file name
        data.Subject{irow,1} = s{2};
      
        % Prints and appends all of the data from the current txt file to
        % the CompData file
        fprintf(fid, '%s\t%g\t%d\t%g\t%g\t%s\t%s\t%s\n', data.Subject{irow}, data.TrialTime(irow),data.Time(irow), data.L_POR_X_0x5Bpx0x5D(irow), data.L_POR_Y_0x5Bpx0x5D(irow), data.L_AOI_Hit{irow}, data.L_Event_Info{irow}, data.Stimulus{irow});
    end % end create subject variable and print data
    fprintf('Subj %s took %d sec to complete\n\n', data.Subject{irow},round(toc))
end % end loop through txt files

fclose(fid); % close the CompData file
fprintf('Done creating data compilation file...\n')

