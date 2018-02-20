%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                         %%
%%      Tally co-occurences of two syllables across        %%
%%      a subset of utterances from the CHILDES database   %%
%%                                                         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script uses a file providing utterances in CDS directed 
% towards children under 9-months converted into syllabified IPA by Lisa
% Pearl et al. at UC Irvine, which is found on the CHILDES Database website
% under "Derived Corpora & Counts". The original file was altered (outside Matlab) to give a
% header line "Utterance" to provide a variable name for the Matlab tdfread
% function

clear

% Start a timing variable
tic

% Give the name of the base file and location
projName = 'brent9mos-text-klatt-syls.txt';
projFolder = '/Users/Dylan/Desktop/';

% Create a structure entitled "data" with all of the utterances
fprintf('\n\n\n\nPulling in data...\n...\n...\n...\n')
fname = fullfile(projFolder,projName);
data = tdfread(fname, 'tab');

% Convert utterance string variables to cells, and remove the / which demarcates syllables within words in the original file 
data.Utterance = cellstr(data.Utterance);
data.Utterance = regexprep(data.Utterance,'/',' ');

% Get the overall file length
nrows = length(data.Utterance);

% Set up a tally for the syllable list created below
a = 0;

% Extract the individual syllables from the utterances
fprintf('Converting utterances to individual syllables...\n...\n...\n...\n')
for irow = 1:nrows
    % Using ' ' (space) delimiter to split the syllables up, as indicated in the original file 
    splitStr = regexp(data.Utterance{irow},' ','split');
    % Put transpose the string configuration from columns to rows
    utterance = transpose(splitStr);
    syllength = length(utterance);
    % Create a new variable, syllable, that contains all of the syllables
    % in one column
    for syl = 1:syllength
        a = (a+1);
        syllable{a,1} = sprintf('%s',utterance{syl});
    end
end

% Convert the syllable string variable into cells
syllable = cellstr(syllable);

% Get a list of each unique syllable in the corpus
UniqueSyl = unique(syllable);
nSyl = length(UniqueSyl);

% Remove spaces from the utterance data, so that syllable combinations can
% be examined
data.Utterance = regexprep(data.Utterance,' ',''); 

% Open a new file that will contain a tally of occurence of each
% syllable to syllable transition
fid = fopen(fullfile(projFolder,'ForwardTransProbTally.txt'),'at');

fprintf(fid, 'Syllable');

fprintf('There are %d syllable combinations...\n', (nSyl*nSyl))
fprintf('This will take a while... Press any key to continue\n...\n...\n...\n')

pause

fprintf('Tallying syllable co-occurences...\n...\n...\n...\n')

% Print the final syllable of the pair at the top of the file
for isyl = 1:nSyl
    fprintf(fid, '\t%s', UniqueSyl{isyl});
end

fprintf(fid, '\n');

% Work through each syllable pair to tally the number of times each pair occurs within
% the utterances in the original file

for isyl = 1:nSyl
    % Get the current sequence initial syllable
    syl1 = UniqueSyl{isyl};
    fprintf('Working on initial syllable "%s"...\n', UniqueSyl{isyl})
    % Print initial sylable name to the file
    fprintf(fid, '%s', UniqueSyl{isyl});
    % Timining variable onset
    time1 = toc;
    
    for isyl2 = 1:nSyl
        % Get the current sequence final syllable
        syl2 = UniqueSyl{isyl2};
        % Create a tally for the occurences of the syllable combination
        tally = 0;
        % Find the indices of occurances of the current syllable pair
        index = regexp(data.Utterance,[syl1 syl2]);
        nrows = length(index);
        % Sum the number of occurances across all of the utterances in the
        % original file. This uses length to capture individual or multiple occurances
        % in an utterance (non-occurances will have a length of zero)
        for irow = 1:nrows
            tally = tally + length(index{irow});
        end
        
        % Print the tally to the file
        fprintf(fid, '\t%d', tally);
    end
    
    % Get the time it took to tally information for the initial syllable
    time2 = toc;
    fprintf('Syllable "%s" took %d seconds...\n...\n', UniqueSyl{isyl}, round(time2-time1))
    fprintf(fid,'\n');
end
fprintf('The entire process took about %d seconds...\n...\n...\n...\n', round(toc))
