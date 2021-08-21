% do calibration

%% 防止被试按键干扰程序
try
    ListenChar(-1);
catch ME
    % old PTBs don't have mode -1, use 2 instead which also supresses
    % keypresses from leaking through to matlab
    ListenChar(2);
end
%% 眼动校准
if doBimonocularCalibration
    % do sequential monocular calibrations for the two eyes
    % 获得默认设置
    settings                = EThndl.getOptions();
    settings.calibrateEye   = 'left';
    settings.UI.button.setup.cal.string = 'calibrate left eye (<i>spacebar<i>)';
    str = settings.UI.button.val.continue.string;
    settings.UI.button.val.continue.string = 'calibrate other eye (<i>spacebar<i>)';
    % 获得更改设置权限
    EThndl.setOptions(settings);
    tobii.calVal{1}         = EThndl.calibrate(wpnt,1);
    if ~tobii.calVal{1}.wasSkipped
        settings.calibrateEye   = 'right';
        settings.UI.button.setup.cal.string = 'calibrate right eye (<i>spacebar<i>)';
        settings.UI.button.val.continue.string = str;
        EThndl.setOptions(settings);
        tobii.calVal{2}         = EThndl.calibrate(wpnt,2);
    end
else
    % do binocular calibration
    tobii.calVal{1}         = EThndl.calibrate(wpnt);
    %tobii.calVal{1} = EThndl.calibrateManual(wpnt);
    %set(p,'StopFcn','');
end
ListenChar(0);