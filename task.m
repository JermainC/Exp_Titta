RabbitIndex=Screen('MakeTexture', wpnt, Rabbit);
for Trial=1:4
    gazeX=[];
    gazeY=[];
    keyPressed=0;
    trialEnd = 0;
        % peripheral stim
    LImg=nosocial_pic(Design(Trial,3)).img;
    RImg=nosocial_pic(Design(Trial,4)).img;
    
    LtexIndex=Screen('MakeTexture', wpnt, LImg);
    RtexIndex=Screen('MakeTexture', wpnt, RImg);
    
    %呈现注视点
    %Beeper(500,1,0.5);
    Screen('DrawTexture', wpnt, RabbitIndex);
    Screen('FrameRect', wpnt, [255,0,0],eyeRect,5);
    Screen('Flip',wpnt); 
    EThndl.sendMessage('fix_onset');
    Screen('DrawTexture', wpnt, LtexIndex,[],L_rect);
    Screen('DrawTexture', wpnt, RtexIndex,[],R_rect);
    Arrowtex= Screen('MakeTexture', wpnt, ArrowFile(Design(Trial,2),1).pic);
    Screen('DrawTexture', wpnt, Arrowtex,[],ArrowRect);
    start_once = 0;
    while trialEnd == 0
        
        get_gaze;
        if gazeX>eyeRect(1) && gazeX<eyeRect(3) && gazeY>eyeRect(2) && gazeY<eyeRect(4)
            
            if start_once == 0
                tic;
                start_once = 1;
            end
            if toc >= criteriaTime
                trialEnd = 1;
               
            end
        else
            %out_warning=out_warning+1;  % tolerate your first out-of-region behavior
            %if out_warning > 5  %---look at the data
            start_once = 0;
                %acc = 0;
           
        end
    end
    EThndl.sendMessage('fix_offset');
    
    Screen('Flip', wpnt);
    EThndl.sendMessage('stim_onset');
    trialEnd = 0;
    start_once1 = 0;
    start_once2 = 0;
   
    
    while trialEnd == 0
        get_gaze;
        if (gazeX>L_rect(1) && gazeX<L_rect(3) && gazeY>L_rect(2) && gazeY<L_rect(4))
            start_once2 = 0;
            if start_once1 == 0
                tic;
                start_once1 = 1;
            end
            if toc >=criteriaTime %连续看了了0.03s
                trialEnd = 1;
                eye_pos=1; % 被试眼睛看左边
                
            end
        elseif (gazeX>R_rect(1) && gazeX<R_rect(3) && gazeY>R_rect(2) && gazeY<R_rect(4))
            start_once1 = 0;
            if start_once2 == 0
                tic;
                start_once2 = 1;
            end
            if toc >= criteriaTime
                trialEnd = 1;
                eye_pos=2; % 被试眼睛看右边
            end
        else
            start_once1 = 0;
            start_once2 = 0;
            
        end
    end
    EThndl.sendMessage('stim_offset');
    WaitSecs(0.1);
    
    EThndl.sendMessage('stim2_onset');
    
    
        Screen('DrawTexture', wpnt, LtexIndex,[],L_rect);
        Screen('DrawTexture', wpnt, RtexIndex,[],R_rect);
        Arrowtex= Screen('MakeTexture', wpnt, ArrowFile(Design(Trial,2),1).pic);
        Screen('DrawTexture', wpnt, Arrowtex,[],ArrowRect);  %FaceRect
        Screen('Flip',wpnt);
        %stim_picID(k,1:3)=[Trial,k,tetio_localToRemoteTime(tetio_localTimeNow())] ;
        
            WaitSecs(3.33);
            Screen('Close',Arrowtex);
        
    
    EThndl.sendMessage('stim2_offset');
    
    % 被试选择箭头指向的材料
    DrawFormattedText(wpnt, '', 'center', 'center', 1);
    Screen('Flip',wpnt);
    StartTime=GetSecs;
    while GetSecs-StartTime<((800-500)*rand(1)+500)/1000 %interval：500-800s
    end
    %
    Screen('DrawTexture', wpnt, LtexIndex,[],L_rect);
    Screen('DrawTexture', wpnt, RtexIndex,[],R_rect);
    %Screen('DrawTexture', wpnt, Facetex,[],FaceRect);
    Screen('TextSize',wpnt,fontSize);
    DrawFormattedText(wpnt, '箭头指向了哪个材料？', 'center', 'center', 255);
    Screen('Flip',wpnt);
    EThndl.sendMessage('choose1_onset');
    CurrentTime=GetSecs;
    while 1
        
        [ keyIsDown, Secs, keyCode ] = KbCheck;%check key press
        if keyIsDown
            if keyCode(49) %1
                keyPressed1=1;
                %RT=GetSecs-CurrentTime;
            elseif keyCode(50) %2
                keyPressed1=2;
                %RT=GetSecs-CurrentTime;
            end
            break;
        end
        
    end
    EThndl.sendMessage('choose1_offset');
%     DrawFormattedText(wpnt, '', 'center', 'center', 0);
%     Screen('Flip',wpnt);
%     StartTime=GetSecs;
%     while GetSecs-StartTime<((800-500)*rand(1)+500)/1000 %interval：500-800s
%     end
    
    % 被试选择自己喜欢哪个
%     Screen('DrawTexture', wpnt, LtexIndex,[],L_rect);
%     Screen('DrawTexture', wpnt, RtexIndex,[],R_rect);
%     DrawFormattedText(wpnt, '小朋友\n\n你喜欢哪个', 'center', 'center', 0);
%     Screen('Flip',wpnt);
%     EThndl.sendMessage('choose2_onset');
%     CurrentTime=GetSecs;
%     while 1
%         
%         [ keyIsDown, Secs, keyCode ] = KbCheck;%check key press
%         if keyIsDown
%             if keyCode(97) %1
%                 keyPressed2=1;
%                 %RT=GetSecs-CurrentTime;
%             elseif keyCode(98) %2
%                 keyPressed2=2;
%                 %RT=GetSecs-CurrentTime;
%             end
%             break;
%         end
%         
%     end
    %EThndl.sendMessage('choose2_offset');
    Design(Trial,5)=eye_pos;
    Design(Trial,6)=keyPressed1;
    %Design(Trial,7)=keyPressed2;
%     Design(Trial,8)=RT;
    
     %interval
    DrawFormattedText(wpnt, '', 'center', 'center', 255);
    Screen('Flip',wpnt);
    StartTime=GetSecs;
    while GetSecs-StartTime<((1000-800)*rand(1)+800)/1000 %interval：800-1000s
    end  
    Screen('Close',LtexIndex);
    Screen('Close',RtexIndex);
%     Screen('Close',Arrowtex);
end