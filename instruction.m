%% experiment
Screen('TextSize',wpnt,fontSize);
DrawFormattedText(wpnt, 'Task starts\n\nPress space to continue', 'center', 'center', 0);
Screen('Flip',wpnt);
 while 1
    [ keyIsDown, Secs, keyCode ] = KbCheck;%check key press
     if keyIsDown
                if keyCode(32) %Space bar keycode 44 on mac, check the keycode for windows.32
                    while KbCheck; end %wait till release key press, only one key press is recognized
                    break;
                end
     end
 end
 
Screen('FillRect', wpnt, white);
Screen('Flip',wpnt);