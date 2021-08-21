% get setup struct (can edit that of course):
settings = Titta.getDefaults('Tobii Pro Spectrum');
% request some debug output to command window, can skip for normal use
settings.debugMode      = true;
% customize colors of setup and calibration interface (colors of
% everything can be set, so there is a lot here).
% 1. setup screen
settings.UI.setup.bgColor       = bgClr;
settings.UI.setup.instruct.color= fixClrs(1);
settings.UI.setup.fixBackColor  = fixClrs(1);
settings.UI.setup.fixFrontColor = fixClrs(2);
% 2. validation result screen
settings.UI.val.bgColor                 = bgClr;
settings.UI.val.avg.text.color          = fixClrs(1);
settings.UI.val.fixBackColor            = fixClrs(1);
settings.UI.val.fixFrontColor           = fixClrs(2);
settings.UI.val.onlineGaze.fixBackColor = fixClrs(1);
settings.UI.val.onlineGaze.fixFrontColor= fixClrs(2);
% calibration display
if useAnimatedCalibration
    % custom calibration drawer
    calViz                      = AnimatedCalibrationDisplay();
    settings.cal.drawFunction   = @calViz.doDraw;
    calViz.bgColor              = bgClr;
    calViz.fixBackColor         = fixClrs(1);
    calViz.fixFrontColor        = fixClrs(2);
else
    % set color of built-in fixation points
    settings.cal.bgColor        = bgClr;
    settings.cal.fixBackColor   = fixClrs(1);
    settings.cal.fixFrontColor  = fixClrs(2);
end
% callback function for completion of each calibration point
settings.cal.pointNotifyFunction = @demoCalCompletionFun;

% init
EThndl          = Titta(settings);
%EThndl          = EThndl.setDummyMode();    % just for internal testing, enabling dummy mode for this readme makes little sense as a demo
EThndl.init();

if DEBUGlevel>1
    % make screen partially transparent on OSX and windows vista or
    % higher, so we can debug.
    PsychDebugWindowConfiguration;
end
if DEBUGlevel
    % Be pretty verbose about information and hints to optimize your code and system.
    Screen('Preference', 'Verbosity', 4);
else
    % Only output critical errors and warnings.
    Screen('Preference', 'Verbosity', 2);
end