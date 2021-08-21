%Screen('Preference', 'SkipSyncTests', 1);
clear all
sca
home = cd;
global rootpath fix_im fix_h
rootpath = [home '\Tobii\Titta-master'];
            %fix_im = imread('D:\wqd\Tobii\Titta-master\fix.jpg');
fix_im = imread(fullfile(rootpath, 'fix.jpg'));
fix_h=size(fix_im,1);

%set(p, 'StopFcn', 'play(p)');

DEBUGlevel              = 1;
fixClrs                 = [0 255];
bgClr                   = 127;
useAnimatedCalibration  = 1;
doBimonocularCalibration= false;
% task parameters
scr                     = max(Screen('Screens'));
scrRect             = Screen('Rect',scr);
fRate               = Screen('NominalFrameRate',scr);
XMIN                = scrRect(1);
YMIN                = scrRect(2);
XMAX                = scrRect(3);
YMAX                = scrRect(4);
width               = XMAX-XMIN;
height              = YMAX-YMIN;

cd (rootpath);
addTittaToPath;
cd(home);


%% Preliminary
Stimuli_dir=[home '/Stimuli'];
Data_dir=[home '/Data'];
ID=input('Your Name:','s');
filename=[ID];

%% para for cal visual angel
criteriaTime=0.06; %持续注视的时间
pw=width;  %screen size
ph=height;
viewDist=60;
ScrWidth=47.6;
ScrHeight=26.1;

widthDeg = round(2*180*atan(ScrWidth/(2*viewDist))/pi);
deg2pix  = round(pw/widthDeg);
V_w=8; %刺激呈现度数
V_h=round(V_w*500/500);
V_w=V_w*deg2pix;
V_h=V_h*deg2pix;
% stim position 需要调整
%L_rect=round([(pw-(14*2+7)*deg2pix)/2,(ph-7*deg2pix)/2,(pw-(14*2+7)*deg2pix)/2+7*deg2pix,(ph-7*deg2pix)/2+7*deg2pix]);
%R_rect=round([pw-7*deg2pix-(pw-(14*2+7)*deg2pix)/2,(ph-7*deg2pix)/2,pw-(pw-(14*2+7)*deg2pix)/2,(ph-7*deg2pix)/2+7*deg2pix]);
%C_rect=round([pw/2-7/2*deg2pix,ph/2-7/2*deg2pix,pw/2+7/2*deg2pix,ph/2+7/2*deg2pix]);
L_rect=[pw/4-V_w/2, ph/2-V_h/2, pw/4+V_w/2, ph/2+ V_h/2];
R_rect=[pw*3/4-V_w/2, ph/2-V_h/2, pw*3/4+V_w/2, ph/2+ V_h/2];

rect_w=4*deg2pix;    %设置成4°的矩形
eyeRect=round([(pw-rect_w)/2,(ph-rect_w)/2,(pw-rect_w)/2+rect_w,(ph-rect_w)/2+rect_w]); %中央注视区，设置成°的矩形
rect_w=10*deg2pix;    %设置成6°的矩形
ArrowRect=round([(pw-rect_w)/2,(ph-rect_w)/2,(pw-rect_w)/2+rect_w,(ph-rect_w)/2+rect_w]); %中央面孔区
%% read image
ArrrowFolder(2).fol = [];
ArrowFile(2,1).pic = [];
for i = 1:2  %3 expressions pos, neg, neu
    ArrrowFolder(i).fol = [Stimuli_dir '\arrow\' num2str(i)];
    temfile = dir([ArrrowFolder(i).fol '\*.jpg']);
    
        ArrowFile(i,1).pic = imread([ArrrowFolder(i).fol '\' temfile(1).name]);
   
    
end

nosocial_pic(40).img=[]; 
currentFolder=[Stimuli_dir '\veg'];
currentFiles=dir([currentFolder '/*.jpg']); 
for j=1:(length(currentFiles))
    nosocial_pic(j).img=imread([currentFolder '/' currentFiles(j).name]);
   
end

Rabbit=imread([home '/Rabbit.bmp']);

%% design
D_cond=[repmat(1,10,1); repmat(2,10,1)];
D_trial=[1:20]'; %#ok<NBRAK>
D_cond(1:size(D_cond,1),:)=D_cond(randperm(size(D_cond,1))',:);
% % 下面保证连续三个以上相同类型的刺激不在同一边
% N=30-1; %差分后个数减一
% over=1;
% while over ==1
%     D_cond(1:size(D_cond,1),:)=D_cond(randperm(size(D_cond,1))',:);
%     x=abs(diff(D_cond(:,1)));
%     for i=1:N-2
%         
%         if sum(x(i:i+2)==0)
%             over=1;
%             break
%             
%         else
%             over =0;
%         end
%     end
% end

ranyArr=randperm(40);
D_L_picID=ranyArr(1:20)'; %#ok<NBRAK> %左边图片
D_R_picID=ranyArr(21:40)'; %#ok<NBRAK> %右边图片
D_other=zeros(20,3); %被试看的方向1=左边，2=右边；箭头朝向，1=左边，2=右边；被试选择
Design=[D_trial,D_cond,D_L_picID, D_R_picID, D_other];

%%
try
    tracker_setting;
    Screen('Preference', 'SyncTestSettings', 0.002);    % the systems are a little noisy, give the test a little more leeway
    %将PTB窗口设为1792*1008，便于debug和录屏，若全屏录制则导致synchronization failure，使实验程序无法运行
    [wpnt,winRect] = PsychImaging('OpenWindow', scr, bgClr, [128, 72, 1792, 1008], [], [], [], 4);
    hz=Screen('NominalFrameRate', wpnt);
    Priority(1);
    Screen('BlendFunction', wpnt, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('Preference', 'TextAlphaBlending', 1);
    Screen('Preference', 'TextAntiAliasing', 2);
    % This preference setting selects the high quality text renderer on
    % each operating system: It is not really needed, as the high quality
    % renderer is the default on all operating systems, so this is more of
    % a "better safe than sorry" setting.
    Screen('Preference', 'TextRenderer', 1);
    HideCursor;
    white=100;%background grayscale level can be changed to match the face2 images 背景颜色也可以调一下
    fontSize = 50; 
    KbName('UnifyKeyNames');    % for correct operation of the setup/calibration interface, calling this is required
    instruction;
    calibration;
    
     % find out which eye(s) to use, start acquiring samples
    %eye     = calInfo.attempt{calInfo.selectedCal}.eye;
    useLeft =1;% ismember(eye,{'left','both'});
    useRight= 1; %ismember(eye,{'right','both'});
    % strat recording:
    EThndl.buffer.start('gaze');
    WaitSecs(.8);   % wait for eye tracker to start and gaze to be picked up
    
    % send message into ET data file
    EThndl.sendMessage('recording_start');
    task;
 
    EThndl.buffer.stop('gaze');
    DrawFormattedText(wpnt, 'Task finished\n\nThank you!', 'center', 'center', 0);
    Screen('Flip',wpnt);
    
    % save data to mat file, adding info about the experiment
    dat = EThndl.collectSessionData();
    dat.expt.winRect = winRect;
    %dat.expt.stimDir = stimDir;
    dat.expt.Design=Design;
    save([Data_dir '/' ID],'-struct','dat');
    
    % NB: if you don't want to add anything to the saved data, you can use
    % EThndl.saveData directly
    
    % shut down
    EThndl.deInit();
    
    while 1
        [ keyIsDown, Secs, keyCode ] = KbCheck;%check key press
        if keyIsDown
            if keyCode(32) %Space bar keycode 44 on mac, check the keycode for windows
                while KbCheck; end %wait till release key press, only one key press is recognized
                break;
            end
        end
    end
    Screen('CloseAll');
%     clear;
    ShowCursor;
catch me
    sca
    ListenChar(0);
    rethrow(me)
end
sca
