clear

[data,sylloffset, syllonset] = tblread('/Users/Dylan/Desktop/ForwardTransProbTally 7-15-14.txt', 'tab');

minfreq = 10;
sylloffset = cellstr(sylloffset);
syllonset = cellstr(syllonset);

freq = unique(data);
minfreqrow = find(freq==minfreq);

nfreq = length(freq);
fid = fopen('/Users/Dylan/Desktop/TP Summary Info.txt','at');

fprintf(fid, 'Frequency\tSyllables\n');

for ifreq = minfreqrow:nfreq
    currfreq = freq(ifreq);
    fprintf(fid,'%d', currfreq);
    [rows,columns] = find(data==currfreq);
    for irow = 1:length(rows)
    fprintf(fid,'\t%s',[syllonset{rows(irow)} sylloffset{columns(irow)}]);
    end
    fprintf(fid,'\n');
end
       
fclose(fid);