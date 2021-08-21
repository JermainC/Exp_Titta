clear gazeX gazeY
% 1. get eye data
%samp    = EThndl.buffer.consumeN('gaze');
% ²É¼¯400¸ögazepoint
samp    = EThndl.buffer.peekN('gaze',400);
%samp    = EThndl.buffer.peekN()
% see if have a sample with both eyes, or of the selected eye if
% running monocular

qSelect = (~useLeft | samp.left.gazePoint.valid) & (~useRight | samp.left.gazePoint.valid);
if ~any(qSelect) && useLeft && useRight
    % in case of using both eyes, if no sample for both eyes, see
    % if we at least have a sample for one of the eyes
    qSelect = samp.left.gazePoint.valid | samp.right.gazePoint.valid;
end
i = find(qSelect,200,'last');

% if have some form of eye position
if ~isempty(i)
    gazeX   = [samp.left.gazePoint.onDisplayArea(1,i) samp.right.gazePoint.onDisplayArea(1,i)];
    gazeY   = [samp.left.gazePoint.onDisplayArea(2,i) samp.right.gazePoint.onDisplayArea(2,i)];
    
    % block out unused eye
    if ~useLeft
        gazeX(1) = nan;
        gazeY(1) = nan;
    end
    if ~useRight
        gazeX(2) = nan;
        gazeY(2) = nan;
    end
    % get average
    gazeX   = mean(gazeX,'omitnan')*width;
    gazeY   = mean(gazeY,'omitnan')*height;
else
    gazeX   = 1;
    gazeY   = 1;
end