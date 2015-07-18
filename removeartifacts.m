function [txy, artifact] = removeartifacts(txy,param)
% function [txy, artifact] = removeartifacts(txy,param)
% Detect and remove blink artifacts.  Removal is done by interpolation.
% Calling without txy will reture the default parameters

% 2011/9 bst wrote it

% txy(isnan(sum(txy(:,2:3),2)),2:3) = -1000;
% artifact = txy(:,1)*0;
% return
% 
if ~exist('param','var')
    param.eyemin = [-1000 -1000]; % (x,y) in screen coordinate the permissble range of eye coordinates in pixel units
    param.eyemax = [1024+1000 768+1000];
%     param.blinkstart = 0.03; %(s) start time of a blink before the first invalid eye coordinates if pupil data does not exist
%     param.blinkend = 0.05; %(s) end time of a blink after the last eye coordinates if pupil data does not exist
    param.blinkstart = 0; %(s) start time of a blink before the first invalid eye coordinates if pupil data does not exist
    param.blinkend = 0; %(s) end time of a blink after the last eye coordinates if pupil data does not exist
end

if ~exist('txy','var') || isempty(txy)
    txy = param; % return the param
    artifact = [];
    return
end

dxy = [txy(1,2:3)-1; diff(txy(:,2:3))]; % detect the "fake" eye positions (ones that are identical to previous time point)
m = sum(txy(:,2:3)<repmat(param.eyemin,[size(txy,1) 1]),2)>0 | ...
    sum(txy(:,2:3)>repmat(param.eyemax,[size(txy,1) 1]),2)>0 | ...
    sum(abs(dxy),2)==0 | isnan(txy(:,2)) | isnan(txy(:,3));

if size(txy,2)==4 % pupil data exist
    bln = findblinks(txy(:,[1 4]));
    if ~isempty(bln)
        for i = 1:size(bln.starti)
            m(bln.starti(i):bln.endi(i)) = 1;
        end
    end
    if sum(m) == 0
        artifact = m;
        return
    else
        m2 = m;
    end
else % extend the invalid range
    if sum(m) == 0
        artifact = m;
        return
    else
        dm = diff([0; m]);
        m2 = m;
        for i = find(dm(:)'==1)
            if i==1
                continue; % can't do match if the first point is invalid
            end
            t = txy(i,1);
            k1 = find(txy(1:i-1,1)<t-param.blinkstart,1,'last');
            if isempty(k1)
                k1 = 1;
            else
                k1 = min(k1+1,size(m,1));
            end
            j = find(dm(i+1:end)==-1,1);
            if isempty(j)
                k2 = size(m,1);
            else
                t = txy(j+i-1,1);
                k2 = find(txy(j+i:end,1)>t+param.blinkend,1,'first');
                if isempty(k2)
                    k2 = size(m,1);
                else
                    k2 = k2+j+i-2;
                end
            end
            m2(k1:k2) = 1;
        end
    end
end

% interpolate
txy(m,2) = nan; % fill nan to take care of border conditions
txy(m,3) = nan;
dm = diff([0; m2]);
for i = find(dm(:)'==1)
    if i==1
        continue; % can't do match if the first point is invalid
    end
    prev = txy(i-1,:);
    j = find(dm(i+1:end)==-1,1);
    if isempty(j)
        j = size(txy,1);
        next = prev;
    else
        j = i+j-1;
        next = txy(j+1,:);
    end
    % interpolate (to avoid blinks bring misclassified as saccades)
    txy(i:j,2) = (next(2)-prev(2))/(next(1)-prev(1)).*(txy(i:j,1)-prev(1))+prev(2);
    txy(i:j,3) = (next(3)-prev(3))/(next(1)-prev(1)).*(txy(i:j,1)-prev(1))+prev(3);
end
artifact = m2;
