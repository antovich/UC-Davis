
# coding: utf-8

# In[9]:

def ImportGazeFile (filename):
    data = pd.read_csv(filename, sep= "\t")
    return(data.head())


# In[3]:

def GazeData(AOIOneCoor, AOITwoCoor, xcoor, ycoor, subs, time, stim):
    
    import numpy as np
    import pandas as pd
    import matplotlib as plt
    import matplotlib.ticker as ticker
    get_ipython().magic('matplotlib inline')
    
    #the AOI variables expect a list of length 4: xmin, ymin, xmax, ymax
    AOIOneXmin = AOIOneCoor[0] 
    AOIOneYmin = AOIOneCoor[1] 
    AOIOneXmax = AOIOneCoor[2] 
    AOIOneYmax = AOIOneCoor[3]

    AOITwoXmin = AOIOneCoor[0] 
    AOITwoYmin = AOIOneCoor[1]  
    AOITwoXmax = AOIOneCoor[2]  
    AOITwoYmax = AOIOneCoor[3] 

    trialNum = []
    trialList = []
    trialLen = []
    curstim = []
    subList = []
    gazedur1 = []
    gazedur2 = []
    for subID in set(subs):
        #get index of trial changes, based on change in stim name, 'MediaName' variable
        trials = np.roll(stim[subs == subID],1)!=stim[subs == subID] # onset of change in trial
        trialsOFF = np.roll(stim[subs == subID],-1)!=stim[subs == subID] # offset of change in trial
        trialLen.extend(np.subtract(time[subs == subID][trialsOFF], time[subs == subID][trials]))# build list of trial lengths for output dataframe
        trialNum.extend(trials.cumsum()) #get trial number by increasing trial number each time a new trial onset is found
        trialList.extend(np.unique(trialNum)) # build list of trials by subject for output dataframe
        subList.extend([subID]*len(trialList)) # build list of subjects for output dataframe

        for Trial in np.unique(trialNum):

            # Get onset/offset of gaze event changes for current subject and trial for AOIOne
            eventON1 = np.roll(AOIOne[subs == subID][trialNum == Trial],1) != AOIOne[subs == subID][trialNum == Trial]
            eventOFF1 = np.roll(AOIOne[subs == subID][trialNum == Trial],-1) != AOIOne[subs == subID][trialNum == Trial]

            # Get onset/offset of gaze event changes for current subject and trial for AOITwo
            eventON2 = np.roll(AOITwo[subs == subID][trialNum == Trial],1) != AOITwo[subs == subID][trialNum == Trial]
            eventOFF2 = np.roll(AOITwo[subs == subID][trialNum == Trial],-1) != AOITwo[subs == subID][trialNum == Trial]

            curstim.append(np.array(stim[subs == subID][trialNum == Trial])[0]) # build list of stimulus name for output dataframe

            # Get the difference between the gaze event onset and offset values in the timestamp, to get the total duration of gaze event, then sum up these events for the trial
            gazedur1.append(np.subtract(time[subs == subID][trialNum == Trial][AOIOne == True][eventOFF1], time[subs == subID][trialNum == Trial][AOIOne == True][eventON1]).sum())
            # Get the difference between the gaze event onset and offset values in the timestamp, to get the total duration of gaze event, then sum up these events for the trial
            gazedur2.append(np.subtract(time[subs == subID][trialNum == Trial][AOITwo == True][eventOFF2], time[subs == subID][trialNum == Trial][AOITwo == True][eventON2]).sum())
    
    # Build data frame from lists created in for loops
    outputDF = pd.DataFrame({'Subject': subList,
                             'Trial': trialList,
                             'TrialDuration_ms': trialLen,
                             'Stimulus': curstim,
                             'AOI_One_ms': gazedur1,
                             'AOI_Two_ms': gazedur2})
    outputDF = outputDF[['Subject','Trial', 'TrialDuration_ms','Stimulus', 'AOI_One_ms', 'AOI_Two_ms']]
    return(outputDF)


# In[8]:

def GazeDataGroup (outputDF, kind):
    if kind == 'stim':
        outputGROUP = outputDF.groupby(by = "Stimulus").mean() #get mean looking time to AOIs by stimulus name

    elif kind == 'sub':
        outputGROUP = outputDF.groupby(by = "Subject").mean() #get mean looking time to AOIs by subject ID

    elif kind == 'trial':
        outputGROUP = outputDF.groupby(by = "Trial").mean() #get mean looking time to AOIs by trial ID
    
    return(outputGROUP)


# In[10]:

def ExportGazeData (filetitle, outputDF):
    outputDF.to_csv(filetitle + '.csv')


# In[14]:

def PlotTrialProp(outputGROUP, kind):
    if kind == 'stim':
        outputGROUP.AOI1propLook = (outputGROUP.AOI_One_ms/outputGROUP.TrialDuration_ms)
        outputGROUP.AOI2propLook = (outputGROUP.AOI_Two_ms/outputGROUP.TrialDuration_ms)
        ax = outputGROUP.AOI1propLook.plot(color='r', figsize=(30, 10), legend = True, label = 'AOI One')
        outputGROUP.AOI2propLook.plot(color='b', legend = True, label = 'AOI Two')
        tick_spacing = 5
        ax.set_xlabel('Stimulus', fontsize = 20)
        ax.set_ylabel('Proportion of looking to AOI', fontsize = 20)
        ax.xaxis.set_major_locator(ticker.MultipleLocator(tick_spacing))
        ax.tick_params(labelsize=20)
    elif kind == 'trial':
        outputTRIAL.AOI1propLook = (outputTRIAL.AOI_One_ms/outputTRIAL.TrialDuration_ms)
        outputTRIAL.AOI2propLook = (outputTRIAL.AOI_Two_ms/outputTRIAL.TrialDuration_ms)
        ax = outputTRIAL.AOI1propLook.plot(color='r', figsize=(30, 10), legend = True, label = 'AOI One')
        outputTRIAL.AOI2propLook.plot(color='b', legend = True, label = 'AOI Two')
        tick_spacing = 5
        ax.set_xlabel('Trial', fontsize = 20)
        ax.set_ylabel('Proportion of looking to AOI', fontsize = 20)
        ax.xaxis.set_major_locator(ticker.MultipleLocator(tick_spacing))
        ax.tick_params(labelsize=20)


# In[ ]:

ImportGazeFile()

