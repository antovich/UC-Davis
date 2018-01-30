
clear

fname = '/Users/Dylan/Desktop/PhonoSeg2.txt';
Condition1 = 'CA';       
Condition2 = 'CP';       
Ages1 = [19,20,21];  
Ages2 = [26,27];
Novel1 = 'reen';
Novel2 = 'lang';
Familiar1 = 'ball';
Familiar2 = 'shoe';
TargetAOI = 'Target';
DistractAOI = 'Distractor';
Inclusion = 'I-G|I-B';

fprintf('...\n...\n...\nPulling in data...\n...\n...\n...\n')

% Bring in data within dataframe called "data"
data = tdfread(fname, 'tab');

% Convert character variables to cell variables
data.Trial = cellstr(data.Trial);
data.Subject = cellstr(data.Subject);
data.Color = cellstr(data.Color);
data.Gender = cellstr(data.Gender);
data.Inclusion_Status = cellstr(data.Inclusion_Status); 
data.Stimulus = cellstr(data.Stimulus);
data.Area_of_Interest = cellstr(data.Area_of_Interest);
data.Entry_Time_0x5Bms0x5D = cellstr(data.Entry_Time_0x5Bms0x5D); 
data.Sequence = cellstr(data.Sequence);
data.Revisits = cellstr(data.Revisits); 

% Create masking variables for groups/conditions
Condition1mask = strcmp(data.Condition, {Condition1});
Condition2mask = strcmp(data.Condition, {Condition2});
Ages1mask = ismember(data.Age, Ages1);
Ages2mask = ismember(data.Age, Ages2);
Novel1mask = ~cellfun(@isempty, regexpi(data.Stimulus, Novel1));
Novel2mask = ~cellfun(@isempty, regexpi(data.Stimulus, Novel2));
Familiar1mask = ~cellfun(@isempty, regexpi(data.Stimulus, Familiar1));
Familiar2mask = ~cellfun(@isempty, regexpi(data.Stimulus, Familiar2));
Targetmask = strcmp(data.Area_of_Interest, TargetAOI);
Distractmask = strcmp(data.Area_of_Interest, DistractAOI);
Inclusionmask = ~cellfun(@isempty, regexpi(data.Inclusion_Status, Inclusion));
FirstHalfmask = ~cellfun(@isempty, regexpi(data.Stimulus, 'or2|ol1|pl1|pr2'));

fid = fopen('/Users/Dylan/Desktop/newdata.txt','at');

fprintf(fid, 'Conditions\tDiff\tProp\tTTEST p-value\n');

a = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages1mask & Novel1mask & Targetmask & Inclusionmask);
b = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages1mask & Novel1mask & Distractmask & Inclusionmask);
[~,p]= ttest(a,b);
fprintf(fid,'Condition1 Age1 Novel1\t%f\t%f\t%f\n', mean(a)-mean(b),mean(a)/(mean(a)+mean(b)),p);

c = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages1mask & Novel2mask & Targetmask & Inclusionmask);
d = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages1mask & Novel2mask & Distractmask & Inclusionmask);
[~,p]= ttest(c,d);
fprintf(fid,'Condition1 Age1 Novel2\t%f\t%f\t%f\n', mean(c)-mean(d),mean(c)/(mean(c)+mean(d)),p);

e = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages2mask & Novel1mask & Targetmask & Inclusionmask);
f = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages2mask & Novel1mask & Distractmask & Inclusionmask);
[~,p]= ttest(e,f);
fprintf(fid,'Condition1 Age2 Novel1\t%f\t%f\t%f\n', mean(e)-mean(f),mean(e)/(mean(e)+mean(f)),p);

g = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages2mask & Novel2mask & Targetmask & Inclusionmask);
h = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages2mask & Novel2mask & Distractmask & Inclusionmask);
[~,p]= ttest(g,h);
fprintf(fid,'Condition1 Age2 Novel2\t%f\t%f\t%f\n', mean(g)-mean(h),mean(g)/(mean(g)+mean(h)),p);

i = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages1mask & Novel1mask & Targetmask & Inclusionmask);
j = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages1mask & Novel1mask & Distractmask & Inclusionmask);
[~,p]= ttest(i,j);
fprintf(fid,'Condition2 Age1 Novel1\t%f\t%f\t%f\n', mean(i)-mean(j),mean(i)/(mean(i)+mean(j)),p);

k = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages1mask & Novel2mask & Targetmask & Inclusionmask);
l = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages1mask & Novel2mask & Distractmask & Inclusionmask);
[~,p]= ttest(k,l);
fprintf(fid,'Condition2 Age1 Novel2\t%f\t%f\t%f\n', mean(k)-mean(l),mean(k)/(mean(k)+mean(l)),p);

m = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages2mask & Novel1mask & Targetmask & Inclusionmask);
n = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages2mask & Novel1mask & Distractmask & Inclusionmask);
[~,p]= ttest(m,n);
fprintf(fid,'Condition2 Age2 Novel1\t%f\t%f\t%f\n', mean(m)-mean(n),mean(m)/(mean(m)+mean(n)),p);

o = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages2mask & Novel2mask & Targetmask & Inclusionmask);
p = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages2mask & Novel2mask & Distractmask & Inclusionmask);
[~,pv]= ttest(o,p);
fprintf(fid,'Condition2 Age2 Novel2\t%f\t%f\t%f\n', mean(o)-mean(p),mean(o)/(mean(o)+mean(p)),pv);

q = data.Net_Dwell_Time_0x5Bms0x5D(Ages1mask & Familiar1mask & Targetmask & Inclusionmask);
r = data.Net_Dwell_Time_0x5Bms0x5D(Ages1mask & Familiar1mask & Distractmask & Inclusionmask);
[~,p]= ttest(q,r);
fprintf(fid,'Familiar1 Age1\t%f\t%f\t%f\n', mean(q)-mean(r),mean(q)/(mean(q)+mean(r)),p);

s = data.Net_Dwell_Time_0x5Bms0x5D(Ages1mask & Familiar2mask & Targetmask & Inclusionmask);
t = data.Net_Dwell_Time_0x5Bms0x5D(Ages1mask & Familiar2mask & Distractmask & Inclusionmask);
[~,p]= ttest(s,t);
fprintf(fid,'Familiar2 Age1\t%f\t%f\t%f\n', mean(s)-mean(t),mean(s)/(mean(s)+mean(t)),p);

u = data.Net_Dwell_Time_0x5Bms0x5D(Ages2mask & Familiar1mask & Targetmask & Inclusionmask);
v = data.Net_Dwell_Time_0x5Bms0x5D(Ages2mask & Familiar1mask & Distractmask & Inclusionmask);
[~,p]= ttest(u,v);
fprintf(fid,'Familiar1 Age2\t%f\t%f\t%f\n', mean(u)-mean(v),mean(u)/(mean(u)+mean(v)),p);

w = data.Net_Dwell_Time_0x5Bms0x5D(Ages2mask & Familiar2mask & Targetmask & Inclusionmask);
x = data.Net_Dwell_Time_0x5Bms0x5D(Ages2mask & Familiar2mask & Distractmask & Inclusionmask);
[~,p]= ttest(w,x);

fprintf(fid,'Familiar2 Age2\t%f\t%f\t%f\n', mean(w)-mean(x),mean(w)/(mean(w)+mean(x)),p);

y = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages1mask & (Novel1mask|Novel2mask) & Targetmask & Inclusionmask);
z = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages1mask & (Novel1mask|Novel2mask) & Distractmask & Inclusionmask);
[~,p]= ttest(y,z);

fprintf(fid,'Cond1 Novel Age1\t%f\t%f\t%f\n', mean(y)-mean(z),mean(y)/(mean(y)+mean(z)),p);

yy = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages2mask & (Novel1mask|Novel2mask) & Targetmask & Inclusionmask);
zz = data.Net_Dwell_Time_0x5Bms0x5D(Condition1mask & Ages2mask & (Novel1mask|Novel2mask) & Distractmask & Inclusionmask);
[~,p]= ttest(yy,zz);

fprintf(fid,'Cond1 Novel Age2\t%f\t%f\t%f\n', mean(yy)-mean(zz),mean(yy)/(mean(yy)+mean(zz)),p);

yyy = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages1mask & (Novel1mask|Novel2mask) & Targetmask & Inclusionmask);
zzz = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages1mask & (Novel1mask|Novel2mask) & Distractmask & Inclusionmask);
[~,p]= ttest(yyy,zzz);

fprintf(fid,'Cond2 Novel Age1\t%f\t%f\t%f\n', mean(yyy)-mean(zzz),mean(yyy)/(mean(yyy)+mean(zzz)),p);

yyyy = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages2mask & (Novel1mask|Novel2mask) & Targetmask & Inclusionmask);
zzzz = data.Net_Dwell_Time_0x5Bms0x5D(Condition2mask & Ages2mask & (Novel1mask|Novel2mask) & Distractmask & Inclusionmask);
[~,p]= ttest(yyyy,zzzz);

fprintf(fid,'Cond2 Novel Age2\t%f\t%f\t%f\n', mean(yyyy)-mean(zzzz),mean(yyyy)/(mean(yyyy)+mean(zzzz)),p);

fclose(fid);
