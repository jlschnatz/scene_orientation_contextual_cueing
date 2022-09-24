#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v2021.2.3),
    on Tue Sep 20 13:18:17 2022
If you publish work using this script the most relevant publication is:

    Peirce J, Gray JR, Simpson S, MacAskill M, Höchenberger R, Sogo H, Kastman E, Lindeløv JK. (2019) 
        PsychoPy2: Experiments in behavior made easy Behav Res 51: 195. 
        https://doi.org/10.3758/s13428-018-01193-y

"""

from __future__ import absolute_import, division

from psychopy import locale_setup
from psychopy import prefs
from psychopy import sound, gui, visual, core, data, event, logging, clock, colors
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)

import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle, choice as randchoice
import os  # handy system and path functions
import sys  # to get file system encoding

from psychopy.hardware import keyboard



# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)

# Store info about the experiment session
psychopyVersion = '2021.2.3'
expName = 'exp_builder_script'  # from the Builder filename that created this script
expInfo = {'participant': '', 'age': '', 'handedness': '', 'gender': ''}
dlg = gui.DlgFromDict(dictionary=expInfo, sortKeys=False, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='/Users/luca/Library/CloudStorage/OneDrive-Persönlich/Dokumente/Studium/4_Semester/PsyBSc14_Grundlagen_der_Psychologie_Vertiefung/priming_scene_orientation/experiment_setup/exp_builder_script_lastrun.py',
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp
frameTolerance = 0.001  # how close to onset before 'same' frame

# Start Code - component code to be run after the window creation

# Setup the Window
win = visual.Window(
    size=[1440, 900], fullscr=True, screen=0, 
    winType='pyglet', allowGUI=False, allowStencil=False,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    blendMode='avg', useFBO=True, 
    units='height')
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Setup eyetracking
ioDevice = ioConfig = ioSession = ioServer = eyetracker = None

# create a default keyboard (e.g. to check for escape)
defaultKeyboard = keyboard.Keyboard()

# Initialize components for Routine "instruction"
instructionClock = core.Clock()
instr_text = visual.TextStim(win=win, name='instr_text',
    text='Hey!\nWelcome to our experiment. Today, you will be shown images of everyday scenes and we will ask you to search for an object in it. We’ll demonstrate the object to you in a second. \nWe included a fixation cross before each image which will move your mouse to the exact same starting point before you start your search. Once you found the object simply klick on it with your mouse, then the next fixation cross and the next scene will appear automatically. Try to find the object as quickly as possible as the image will only be shown for 7 seconds.\nSurely you can end this experiment every time you want but of course we’d be very happy if you stick till the end! :) \nAll the data will be collected anonymously and will be stored for scientific purpose. By starting the experiment you agree to the terms and conditions. \n\nIf you’re ready, press the space bar and you’ll see the object. Have fun!\n',
    font='Open Sans',
    pos=(0, 0), height=0.035, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
instr_key_resp = keyboard.Keyboard()

# Initialize components for Routine "init_stimulus_presentation"
init_stimulus_presentationClock = core.Clock()
stimulus_text_01 = visual.TextStim(win=win, name='stimulus_text_01',
    text='This is the stimulus. In the experiment the stimulus will be presented in grey.\n',
    font='Open Sans',
    pos=(0, 0.15), height=0.035, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
stimulus_text_02 = visual.TextStim(win=win, name='stimulus_text_02',
    text='Take your time and remember it well! When you´re ready to start the experiment, press „space“.',
    font='Open Sans',
    pos=(0, -.2), height=0.035, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=-1.0);
stimulus_key_resp = keyboard.Keyboard()
text_3 = visual.TextStim(win=win, name='text_3',
    text='T',
    font='Open Sans',
    pos=(0, 0), height=0.04, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=-3.0);

# Initialize components for Routine "inititalise_block"
inititalise_blockClock = core.Clock()
text_2 = visual.TextStim(win=win, name='text_2',
    text='Press „space“ for starting the experiment',
    font='Open Sans',
    pos=(0, 0), height=0.04, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=-1.0);
key_resp = keyboard.Keyboard()

# Initialize components for Routine "initialise_trial"
initialise_trialClock = core.Clock()

# Initialize components for Routine "fixation_cross_block_1"
fixation_cross_block_1Clock = core.Clock()
text_cross = visual.TextStim(win=win, name='text_cross',
    text='+',
    font='Open Sans',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
key_resp_cross = keyboard.Keyboard()
drift_mouse = event.Mouse(win=win)
x, y = [None, None]
drift_mouse.mouseClock = core.Clock()
text_cross_space = visual.TextStim(win=win, name='text_cross_space',
    text='Press „space“ when ready',
    font='Open Sans',
    pos=(0, -0.2), height=0.035, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=-3.0);

# Initialize components for Routine "present_image_block_01"
present_image_block_01Clock = core.Clock()
timeout_clock = core.Clock()
stimulus = visual.Rect(
    win=win, name='stimulus',
    width=(.04, .04)[0], height=(.04, .04)[1],
    ori=0.0, pos=[0,0],
    lineWidth=1.0,     colorSpace='rgb',  lineColor='white', fillColor='white',
    opacity=None, depth=-1.0, interpolate=True)
image_scene = visual.ImageStim(
    win=win,
    name='image_scene', 
    image='sin', mask=None,
    ori=1.0, pos=(0, 0), size=(1.5, 1),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-2.0)
find_target = event.Mouse(win=win)
x, y = [None, None]
find_target.mouseClock = core.Clock()
target_letter = visual.TextStim(win=win, name='target_letter',
    text='T',
    font='Open Sans',
    pos=[0,0], height=0.04, wrapWidth=None, ori=0.0, 
    color='grey', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=-4.0);

# Initialize components for Routine "debriefing"
debriefingClock = core.Clock()
debr_text = visual.TextStim(win=win, name='debr_text',
    text='Congratulations, you made it! \nThank you very much for your participation, we hope you had some fun.\nYou can close the window now. \n\nBye :)\n',
    font='Open Sans',
    pos=(0, 0), height=0.035, wrapWidth=None, ori=0.0, 
    color='white', colorSpace='rgb', opacity=None, 
    languageStyle='LTR',
    depth=0.0);
debr_key_resp = keyboard.Keyboard()

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

# ------Prepare to start Routine "instruction"-------
continueRoutine = True
# update component parameters for each repeat
instr_key_resp.keys = []
instr_key_resp.rt = []
_instr_key_resp_allKeys = []
# keep track of which components have finished
instructionComponents = [instr_text, instr_key_resp]
for thisComponent in instructionComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
instructionClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
frameN = -1

# -------Run Routine "instruction"-------
while continueRoutine:
    # get current time
    t = instructionClock.getTime()
    tThisFlip = win.getFutureFlipTime(clock=instructionClock)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *instr_text* updates
    if instr_text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        instr_text.frameNStart = frameN  # exact frame index
        instr_text.tStart = t  # local t and not account for scr refresh
        instr_text.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(instr_text, 'tStartRefresh')  # time at next scr refresh
        instr_text.setAutoDraw(True)
    
    # *instr_key_resp* updates
    waitOnFlip = False
    if instr_key_resp.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        instr_key_resp.frameNStart = frameN  # exact frame index
        instr_key_resp.tStart = t  # local t and not account for scr refresh
        instr_key_resp.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(instr_key_resp, 'tStartRefresh')  # time at next scr refresh
        instr_key_resp.status = STARTED
        # keyboard checking is just starting
        waitOnFlip = True
        win.callOnFlip(instr_key_resp.clock.reset)  # t=0 on next screen flip
        win.callOnFlip(instr_key_resp.clearEvents, eventType='keyboard')  # clear events on next screen flip
    if instr_key_resp.status == STARTED and not waitOnFlip:
        theseKeys = instr_key_resp.getKeys(keyList=['space'], waitRelease=False)
        _instr_key_resp_allKeys.extend(theseKeys)
        if len(_instr_key_resp_allKeys):
            instr_key_resp.keys = _instr_key_resp_allKeys[-1].name  # just the last key pressed
            instr_key_resp.rt = _instr_key_resp_allKeys[-1].rt
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instructionComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instruction"-------
for thisComponent in instructionComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "instruction" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "init_stimulus_presentation"-------
continueRoutine = True
# update component parameters for each repeat
stimulus_key_resp.keys = []
stimulus_key_resp.rt = []
_stimulus_key_resp_allKeys = []
# keep track of which components have finished
init_stimulus_presentationComponents = [stimulus_text_01, stimulus_text_02, stimulus_key_resp, text_3]
for thisComponent in init_stimulus_presentationComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
init_stimulus_presentationClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
frameN = -1

# -------Run Routine "init_stimulus_presentation"-------
while continueRoutine:
    # get current time
    t = init_stimulus_presentationClock.getTime()
    tThisFlip = win.getFutureFlipTime(clock=init_stimulus_presentationClock)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *stimulus_text_01* updates
    if stimulus_text_01.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        stimulus_text_01.frameNStart = frameN  # exact frame index
        stimulus_text_01.tStart = t  # local t and not account for scr refresh
        stimulus_text_01.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(stimulus_text_01, 'tStartRefresh')  # time at next scr refresh
        stimulus_text_01.setAutoDraw(True)
    
    # *stimulus_text_02* updates
    if stimulus_text_02.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        stimulus_text_02.frameNStart = frameN  # exact frame index
        stimulus_text_02.tStart = t  # local t and not account for scr refresh
        stimulus_text_02.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(stimulus_text_02, 'tStartRefresh')  # time at next scr refresh
        stimulus_text_02.setAutoDraw(True)
    
    # *stimulus_key_resp* updates
    waitOnFlip = False
    if stimulus_key_resp.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        stimulus_key_resp.frameNStart = frameN  # exact frame index
        stimulus_key_resp.tStart = t  # local t and not account for scr refresh
        stimulus_key_resp.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(stimulus_key_resp, 'tStartRefresh')  # time at next scr refresh
        stimulus_key_resp.status = STARTED
        # keyboard checking is just starting
        waitOnFlip = True
        win.callOnFlip(stimulus_key_resp.clock.reset)  # t=0 on next screen flip
        win.callOnFlip(stimulus_key_resp.clearEvents, eventType='keyboard')  # clear events on next screen flip
    if stimulus_key_resp.status == STARTED and not waitOnFlip:
        theseKeys = stimulus_key_resp.getKeys(keyList=['space'], waitRelease=False)
        _stimulus_key_resp_allKeys.extend(theseKeys)
        if len(_stimulus_key_resp_allKeys):
            stimulus_key_resp.keys = _stimulus_key_resp_allKeys[-1].name  # just the last key pressed
            stimulus_key_resp.rt = _stimulus_key_resp_allKeys[-1].rt
            # a response ends the routine
            continueRoutine = False
    
    # *text_3* updates
    if text_3.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        text_3.frameNStart = frameN  # exact frame index
        text_3.tStart = t  # local t and not account for scr refresh
        text_3.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(text_3, 'tStartRefresh')  # time at next scr refresh
        text_3.setAutoDraw(True)
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in init_stimulus_presentationComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "init_stimulus_presentation"-------
for thisComponent in init_stimulus_presentationComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "init_stimulus_presentation" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
BlockLoop = data.TrialHandler(nReps=1.0, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('block_number.xlsx'),
    seed=None, name='BlockLoop')
thisExp.addLoop(BlockLoop)  # add the loop to the experiment
thisBlockLoop = BlockLoop.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisBlockLoop.rgb)
if thisBlockLoop != None:
    for paramName in thisBlockLoop:
        exec('{} = thisBlockLoop[paramName]'.format(paramName))

for thisBlockLoop in BlockLoop:
    currentLoop = BlockLoop
    # abbreviate parameter names if possible (e.g. rgb = thisBlockLoop.rgb)
    if thisBlockLoop != None:
        for paramName in thisBlockLoop:
            exec('{} = thisBlockLoop[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "inititalise_block"-------
    continueRoutine = True
    # update component parameters for each repeat
    if BlockNumber == 1:
        ConditionFile = "condition_participant/ConditionFile_Mirror_Block1_" + str(expInfo['participant']) + ".xlsx"
    elif BlockNumber == 2:
        ConditionFile = "condition_participant/ConditionFile_Mirror_Block2_" + str(expInfo['participant']) + ".xlsx"
    
    print(ConditionFile)
    key_resp.keys = []
    key_resp.rt = []
    _key_resp_allKeys = []
    # keep track of which components have finished
    inititalise_blockComponents = [text_2, key_resp]
    for thisComponent in inititalise_blockComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    inititalise_blockClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
    frameN = -1
    
    # -------Run Routine "inititalise_block"-------
    while continueRoutine:
        # get current time
        t = inititalise_blockClock.getTime()
        tThisFlip = win.getFutureFlipTime(clock=inititalise_blockClock)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_2* updates
        if text_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            text_2.frameNStart = frameN  # exact frame index
            text_2.tStart = t  # local t and not account for scr refresh
            text_2.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(text_2, 'tStartRefresh')  # time at next scr refresh
            text_2.setAutoDraw(True)
        
        # *key_resp* updates
        waitOnFlip = False
        if key_resp.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            key_resp.frameNStart = frameN  # exact frame index
            key_resp.tStart = t  # local t and not account for scr refresh
            key_resp.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(key_resp, 'tStartRefresh')  # time at next scr refresh
            key_resp.status = STARTED
            # keyboard checking is just starting
            waitOnFlip = True
            win.callOnFlip(key_resp.clock.reset)  # t=0 on next screen flip
            win.callOnFlip(key_resp.clearEvents, eventType='keyboard')  # clear events on next screen flip
        if key_resp.status == STARTED and not waitOnFlip:
            theseKeys = key_resp.getKeys(keyList=['space'], waitRelease=False)
            _key_resp_allKeys.extend(theseKeys)
            if len(_key_resp_allKeys):
                key_resp.keys = _key_resp_allKeys[-1].name  # just the last key pressed
                key_resp.rt = _key_resp_allKeys[-1].rt
                # a response ends the routine
                continueRoutine = False
        
        # check for quit (typically the Esc key)
        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in inititalise_blockComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "inititalise_block"-------
    for thisComponent in inititalise_blockComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "inititalise_block" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    TrialLoop = data.TrialHandler(nReps=1.0, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions(ConditionFile),
        seed=None, name='TrialLoop')
    thisExp.addLoop(TrialLoop)  # add the loop to the experiment
    thisTrialLoop = TrialLoop.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisTrialLoop.rgb)
    if thisTrialLoop != None:
        for paramName in thisTrialLoop:
            exec('{} = thisTrialLoop[paramName]'.format(paramName))
    
    for thisTrialLoop in TrialLoop:
        currentLoop = TrialLoop
        # abbreviate parameter names if possible (e.g. rgb = thisTrialLoop.rgb)
        if thisTrialLoop != None:
            for paramName in thisTrialLoop:
                exec('{} = thisTrialLoop[paramName]'.format(paramName))
        
        # ------Prepare to start Routine "initialise_trial"-------
        continueRoutine = True
        # update component parameters for each repeat
        if BlockNumber == 2 and TrialType == "mirrored":
            Xpos = -Xcoord
            Ypos = Ycoord
        else: 
            Xpos = Xcoord
            Ypos = Ycoord
        # keep track of which components have finished
        initialise_trialComponents = []
        for thisComponent in initialise_trialComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        initialise_trialClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
        frameN = -1
        
        # -------Run Routine "initialise_trial"-------
        while continueRoutine:
            # get current time
            t = initialise_trialClock.getTime()
            tThisFlip = win.getFutureFlipTime(clock=initialise_trialClock)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in initialise_trialComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "initialise_trial"-------
        for thisComponent in initialise_trialComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # the Routine "initialise_trial" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        # ------Prepare to start Routine "fixation_cross_block_1"-------
        continueRoutine = True
        # update component parameters for each repeat
        key_resp_cross.keys = []
        key_resp_cross.rt = []
        _key_resp_cross_allKeys = []
        # setup some python lists for storing info about the drift_mouse
        gotValidClick = False  # until a click is received
        drift_mouse.setPos((0,0))
        # keep track of which components have finished
        fixation_cross_block_1Components = [text_cross, key_resp_cross, drift_mouse, text_cross_space]
        for thisComponent in fixation_cross_block_1Components:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        fixation_cross_block_1Clock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
        frameN = -1
        
        # -------Run Routine "fixation_cross_block_1"-------
        while continueRoutine:
            # get current time
            t = fixation_cross_block_1Clock.getTime()
            tThisFlip = win.getFutureFlipTime(clock=fixation_cross_block_1Clock)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *text_cross* updates
            if text_cross.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                text_cross.frameNStart = frameN  # exact frame index
                text_cross.tStart = t  # local t and not account for scr refresh
                text_cross.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(text_cross, 'tStartRefresh')  # time at next scr refresh
                text_cross.setAutoDraw(True)
            
            # *key_resp_cross* updates
            waitOnFlip = False
            if key_resp_cross.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                key_resp_cross.frameNStart = frameN  # exact frame index
                key_resp_cross.tStart = t  # local t and not account for scr refresh
                key_resp_cross.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(key_resp_cross, 'tStartRefresh')  # time at next scr refresh
                key_resp_cross.status = STARTED
                # keyboard checking is just starting
                waitOnFlip = True
                win.callOnFlip(key_resp_cross.clock.reset)  # t=0 on next screen flip
                win.callOnFlip(key_resp_cross.clearEvents, eventType='keyboard')  # clear events on next screen flip
            if key_resp_cross.status == STARTED and not waitOnFlip:
                theseKeys = key_resp_cross.getKeys(keyList=['space'], waitRelease=False)
                _key_resp_cross_allKeys.extend(theseKeys)
                if len(_key_resp_cross_allKeys):
                    key_resp_cross.keys = _key_resp_cross_allKeys[-1].name  # just the last key pressed
                    key_resp_cross.rt = _key_resp_cross_allKeys[-1].rt
                    # a response ends the routine
                    continueRoutine = False
            
            # *text_cross_space* updates
            if text_cross_space.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                text_cross_space.frameNStart = frameN  # exact frame index
                text_cross_space.tStart = t  # local t and not account for scr refresh
                text_cross_space.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(text_cross_space, 'tStartRefresh')  # time at next scr refresh
                text_cross_space.setAutoDraw(True)
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in fixation_cross_block_1Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "fixation_cross_block_1"-------
        for thisComponent in fixation_cross_block_1Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # check responses
        if key_resp_cross.keys in ['', [], None]:  # No response was made
            key_resp_cross.keys = None
        TrialLoop.addData('key_resp_cross.keys',key_resp_cross.keys)
        if key_resp_cross.keys != None:  # we had a response
            TrialLoop.addData('key_resp_cross.rt', key_resp_cross.rt)
        # store data for TrialLoop (TrialHandler)
        TrialLoop.addData('text_cross_space.started', text_cross_space.tStartRefresh)
        TrialLoop.addData('text_cross_space.stopped', text_cross_space.tStopRefresh)
        # the Routine "fixation_cross_block_1" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        # ------Prepare to start Routine "present_image_block_01"-------
        continueRoutine = True
        # update component parameters for each repeat
        print(FileName, type(FileName))
        if FileName == None:
            continueRoutine=False
        else:
            continueRoutine=True
            Imagename = "raw_scenes/" + FileName + ".png"
            timeout_clock.reset()
        
            #image_scene_2.flipHoriz = True
            if TrialType == "mirrored" and BlockNumber == 2:
                image_scene.flipHoriz = True
            else:
                image_scene.flipHoriz = False
        stimulus.setPos((Xpos,Ypos))
        image_scene.setOri(0.0)
        image_scene.setImage(Imagename)
        # setup some python lists for storing info about the find_target
        find_target.x = []
        find_target.y = []
        find_target.leftButton = []
        find_target.midButton = []
        find_target.rightButton = []
        find_target.time = []
        find_target.clicked_name = []
        gotValidClick = False  # until a click is received
        target_letter.setPos((Xpos,Ypos))
        # keep track of which components have finished
        present_image_block_01Components = [stimulus, image_scene, find_target, target_letter]
        for thisComponent in present_image_block_01Components:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        # reset timers
        t = 0
        _timeToFirstFrame = win.getFutureFlipTime(clock="now")
        present_image_block_01Clock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
        frameN = -1
        
        # -------Run Routine "present_image_block_01"-------
        while continueRoutine:
            # get current time
            t = present_image_block_01Clock.getTime()
            tThisFlip = win.getFutureFlipTime(clock=present_image_block_01Clock)
            tThisFlipGlobal = win.getFutureFlipTime(clock=None)
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            if timeout_clock.getTime() > 15:
                ClickInTime = 0
                continueRoutine=False
            else:
                ClickInTime = 1
                continueRoutine=True
            
            # *stimulus* updates
            if stimulus.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                stimulus.frameNStart = frameN  # exact frame index
                stimulus.tStart = t  # local t and not account for scr refresh
                stimulus.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(stimulus, 'tStartRefresh')  # time at next scr refresh
                stimulus.setAutoDraw(True)
            
            # *image_scene* updates
            if image_scene.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                image_scene.frameNStart = frameN  # exact frame index
                image_scene.tStart = t  # local t and not account for scr refresh
                image_scene.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(image_scene, 'tStartRefresh')  # time at next scr refresh
                image_scene.setAutoDraw(True)
            # *find_target* updates
            if find_target.status == NOT_STARTED and t >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                find_target.frameNStart = frameN  # exact frame index
                find_target.tStart = t  # local t and not account for scr refresh
                find_target.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(find_target, 'tStartRefresh')  # time at next scr refresh
                find_target.status = STARTED
                find_target.mouseClock.reset()
                prevButtonState = find_target.getPressed()  # if button is down already this ISN'T a new click
            if find_target.status == STARTED:  # only update if started and not finished!
                buttons = find_target.getPressed()
                if buttons != prevButtonState:  # button state changed?
                    prevButtonState = buttons
                    if sum(buttons) > 0:  # state changed to a new click
                        # check if the mouse was inside our 'clickable' objects
                        gotValidClick = False
                        try:
                            iter(stimulus)
                            clickableList = stimulus
                        except:
                            clickableList = [stimulus]
                        for obj in clickableList:
                            if obj.contains(find_target):
                                gotValidClick = True
                                find_target.clicked_name.append(obj.name)
                        x, y = find_target.getPos()
                        find_target.x.append(x)
                        find_target.y.append(y)
                        buttons = find_target.getPressed()
                        find_target.leftButton.append(buttons[0])
                        find_target.midButton.append(buttons[1])
                        find_target.rightButton.append(buttons[2])
                        find_target.time.append(find_target.mouseClock.getTime())
                        if gotValidClick:  # abort routine on response
                            continueRoutine = False
            
            # *target_letter* updates
            if target_letter.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
                # keep track of start time/frame for later
                target_letter.frameNStart = frameN  # exact frame index
                target_letter.tStart = t  # local t and not account for scr refresh
                target_letter.tStartRefresh = tThisFlipGlobal  # on global time
                win.timeOnFlip(target_letter, 'tStartRefresh')  # time at next scr refresh
                target_letter.setAutoDraw(True)
            
            # check for quit (typically the Esc key)
            if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in present_image_block_01Components:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "present_image_block_01"-------
        for thisComponent in present_image_block_01Components:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        #if find_target.leftButton == [1] or find_target.midButton == [1] or find_target.rightButton == [1]:
        #    ClickInTime = 1
        #else:
        #    ClickInTime = 0
        
        
        
        thisExp.addData("id_participant", expInfo['participant'])
        thisExp.addData("age", expInfo['age'])
        thisExp.addData("handedness", expInfo['handedness'])
        thisExp.addData("gender", expInfo['gender'])
        thisExp.addData("Xpos", Xpos)
        thisExp.addData("Ypos", Ypos)
        thisExp.addData("ClickInTime", ClickInTime)
        # store data for TrialLoop (TrialHandler)
        if len(find_target.x): TrialLoop.addData('find_target.x', find_target.x[0])
        if len(find_target.y): TrialLoop.addData('find_target.y', find_target.y[0])
        if len(find_target.leftButton): TrialLoop.addData('find_target.leftButton', find_target.leftButton[0])
        if len(find_target.midButton): TrialLoop.addData('find_target.midButton', find_target.midButton[0])
        if len(find_target.rightButton): TrialLoop.addData('find_target.rightButton', find_target.rightButton[0])
        if len(find_target.time): TrialLoop.addData('find_target.time', find_target.time[0])
        if len(find_target.clicked_name): TrialLoop.addData('find_target.clicked_name', find_target.clicked_name[0])
        # the Routine "present_image_block_01" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
    # completed 1.0 repeats of 'TrialLoop'
    
    thisExp.nextEntry()
    
# completed 1.0 repeats of 'BlockLoop'


# ------Prepare to start Routine "debriefing"-------
continueRoutine = True
# update component parameters for each repeat
debr_key_resp.keys = []
debr_key_resp.rt = []
_debr_key_resp_allKeys = []
# keep track of which components have finished
debriefingComponents = [debr_text, debr_key_resp]
for thisComponent in debriefingComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
debriefingClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
frameN = -1

# -------Run Routine "debriefing"-------
while continueRoutine:
    # get current time
    t = debriefingClock.getTime()
    tThisFlip = win.getFutureFlipTime(clock=debriefingClock)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *debr_text* updates
    if debr_text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        debr_text.frameNStart = frameN  # exact frame index
        debr_text.tStart = t  # local t and not account for scr refresh
        debr_text.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(debr_text, 'tStartRefresh')  # time at next scr refresh
        debr_text.setAutoDraw(True)
    
    # *debr_key_resp* updates
    waitOnFlip = False
    if debr_key_resp.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        debr_key_resp.frameNStart = frameN  # exact frame index
        debr_key_resp.tStart = t  # local t and not account for scr refresh
        debr_key_resp.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(debr_key_resp, 'tStartRefresh')  # time at next scr refresh
        debr_key_resp.status = STARTED
        # keyboard checking is just starting
        waitOnFlip = True
        win.callOnFlip(debr_key_resp.clock.reset)  # t=0 on next screen flip
        win.callOnFlip(debr_key_resp.clearEvents, eventType='keyboard')  # clear events on next screen flip
    if debr_key_resp.status == STARTED and not waitOnFlip:
        theseKeys = debr_key_resp.getKeys(keyList=['space'], waitRelease=False)
        _debr_key_resp_allKeys.extend(theseKeys)
        if len(_debr_key_resp_allKeys):
            debr_key_resp.keys = _debr_key_resp_allKeys[-1].name  # just the last key pressed
            debr_key_resp.rt = _debr_key_resp_allKeys[-1].rt
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in debriefingComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "debriefing"-------
for thisComponent in debriefingComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "debriefing" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# Flip one final time so any remaining win.callOnFlip() 
# and win.timeOnFlip() tasks get executed before quitting
win.flip()

# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv', delim='auto')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()
