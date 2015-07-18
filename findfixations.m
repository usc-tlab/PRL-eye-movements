function fxa = findfixations(txy,param)
%function sac = findfixations(txy,sac,[param])
% Find all fixations in txy = [time-sec, x-deg, y-deg] or [time-sec, x-deg,
% y-deg, isSaccade]
% Sampling interval in txy may be irregular.
% Sample may contain NaN's to mark blinks, invalid or missing measurements
% Default values of param will be used if ommitted.
%
%   Based on the moving window alogrithm used in ASL's eyenal
%
% If txy has a fourth column (isSaccade), it is use to refine the fixation
% detection alogrithm.
%
% fxa contains the following fields: starti (row index of txy where a
% saccade started), endi, meanxy, stdxy, duration
%
% Call findfixations without arguments will return the default parameters
% for detecting fixations

% History:
%   7/05 Bosco Tjan wrote it
%   4/11 bst modified it for MiYoung's experiment (de-referenced txy, reorient outputs, and changed parameters)
%   4/11 bst: fixed incorrect handling of minsample, also added the use of
%   saccades that have already been detected

if ~exist('param','var')
    param.minsample = 0.05;     % (s) time interval for finding initial fixation candidate (0.1)
    param.maxcount = 6;         % consecutive number of outliner to close a fixation
    param.maxblink = 0.5;       % (s) max time interval for losing the eye before closing a fixation
    param.c1 = .5;              % (deg) Criterion 1, max std for starting a fixation
    param.c2 = 1.0;             % (deg) Criterion 2, max diff from mean for continuing a fixation
    param.c3 = 1.5;             % (deg) Criterion 3, max diff from mean for excluding sample for calculating fixation stats
    %param.c1 = 5;          % (eye pixel) Criterion 1, for starting a fixation
    %param.c2 = 10;         % (eye pixel) Criterion 2, for continuing a fixation
    %param.c3 = 15;         % (eye pixel) Criterion 3, for excluding sample for calculating fixation stats
end

if ~exist('txy','var')
    fxa = param;
    return
end

if size(txy,2) == 3
    txy(:,4) = zeros([size(txy,1) 1]);
end

fxa = [];
% get rid of the NaN and keep the index for reverse mapping
minsample = floor(param.minsample/median(diff(txy(:,1))))+1; % we always need this many samples within param.minsample s
ii = find(~isnan(txy(:,2)));
txy = txy(ii,:);
dxy = txy(:,[2 3]);
i = 1;
k = 0;
while i <= size(txy,1)-minsample+1
    %     if txy(i-1+minsample,1)-txy(i,1) <= param.minsample || ...
    if std(txy(i-1+(1:minsample),2)) > param.c1 || std(txy(i-1+(1:minsample),3)) > param.c1 || ...
            sum(txy(i-1+(1:minsample),4)) > 0
        i = i+1;
    else % we are at the beginning of a fixation
        starti = i;
        meanxy = mean(txy(i-1+(1:minsample),[2 3]),1);
        dxy(i:end,:) = abs(txy(i:end,[2 3]) - repmat(meanxy,[length(txy(i:end,1)) 1]));
        cnt = 0;
        i = i+minsample;
        h = i-1;
        % search for the end
        while i<= size(txy,1) && txy(i,1)-txy(h,1) <= param.maxblink && cnt<=param.maxcount && ~txy(i,4)
            if dxy(i,1)>param.c2 || dxy(i,2)>param.c2
                cnt = cnt + 1;
            else
                h = i;
                cnt = 0;
            end
            i = i+1;
        end
        i = i-1;
        if cnt>0
            mcxy = mean(txy(i-cnt+1:i,[2 3]),1);
            if sum(abs(mcxy-meanxy)>[param.c2 param.c2])
                i = i-cnt;
            end
        end
        xy = txy(starti:i,[2 3]);
        idx = find(abs(xy(:,1)-meanxy(1))<=param.c3 & abs(xy(:,2)-meanxy(2))<=param.c3);
        if isempty(idx)
            i = i+1;
            continue
        end
        % we found the end point of a fixation
        k = k+1;
        if k==1
            fxa.rawx = [];
            fxa.rawy = [];
            fxa.rawi = [];
            fxa.rawgrp = [];
        end
        % store the admissible fixation coordinates
        xy = xy(idx,:);
        n = size(xy,1);
        fxa.rawgrp(end+(1:n)) = k;
        fxa.rawx(end+(1:n)) = xy(:,1)';
        fxa.rawy(end+(1:n)) = xy(:,2)';
        rng = starti:i;
        fxa.rawi(end+(1:n)) = ii(rng(idx));
        % compute statistics
        fxa.meanx(k) = mean(xy(:,1));
        fxa.meany(k) = mean(xy(:,2));
        fxa.stdx(k) = std(xy(:,1));
        fxa.stdy(k) = std(xy(:,2));
        fxa.duration(k) = txy(i,1)-txy(starti,1);
        % de-reference txy
        fxa.startt(k) = txy(starti,1);
        fxa.startx(k) = txy(starti,2);
        fxa.starty(k) = txy(starti,3);
        fxa.endt(k) = txy(i,1);
        fxa.endx(k) = txy(i,2);
        fxa.endy(k) = txy(i,3);
        % set starti/endi to index the original txy
        fxa.starti(k) = ii(starti);
        fxa.endi(k) = ii(i);
        i = i+1;
    end
end

