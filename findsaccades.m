function sac = findsaccades(txy,param)
%function sac = findsaccades(txy,[param])
% Find all saccades in txy = [time-sec, x-deg, y-deg]
% Sampling interval in txy may be irregular.
% Sample may contain NaN's to mark invalid or missing measurements
% Default values of param will be used if ommitted.
%
%   Based on
%   Fischer, B., Biscaldi, M., and Otto, P.1993.  Saccadic eye movements of
%   dyslexic adults.  Neuropsychologia, Vol. 31, No 9, pp. 887-906.
%   and modified from the implementation in ILAB by Roger Ray, Darren
%   Gitelman.
%
% sac contains the following fields: starti (row index of txy where a
% saccade started), peaki, endi, peak_speed, mean_speed, duration, actuamplitude
% (xy(endi)-xy(starti))
%
% Call findsaccades without arguments will return the default parameters
% for saccade detection

% History:
%   7/05 Bosco Tjan wrote it
%   4/11 bst modified it for MiYoung's experiment(de-referenced txy, reorient outputs, and
%   changed parameters); fixed a few bugs
%   9/2011 bst modified it to make use of artifact marking (avoid
%   starting/ending a saccade during artifacts, unless the artifact is an
%   isolated reading)

if ~exist('param','var')
    param.minspeed = [];    % (deg/s) min peak eye velocity during saccade (30)
    param.minspeedprctile = 75; %  min peak eye velocity during saccade in percentile (90)
                            % actual min speed is the max of the two, one
                            % of which can be []
    param.mindur = .03;     % (s) min duration of a saccade
    param.minamp = 0.2;     % (deg) min saccade amplitude (0.2)
    param.maxmeasgap = 0.8; % fraction of time during a saccade with missing measurements (defined as any sampling interval > median sampling interval)
    param.cutoff = .15;     % fraction of the peak speed used to define the begin and end of a saccade (0.2)
    param.cutoff2 = 20;     % percentitle of all speed to define the begin and end of a saccade (2)
                            % the actual cutoff is the max of the two
end

if ~exist('txy','var')
    sac = param;
    return
end

if size(txy,2)==3
    txy(:,4) = 0;
end

% remove singleton artifacts
singletons = diff([0; txy(:,4)])>0 & diff([txy(:,4); 0])<0;
txy(singletons,4) = 0;

% excludes artifact regions from consideration
txy(txy(:,4)~=0,2) = nan;
txy(txy(:,4)~=0,3) = nan;

sampintvl = median(diff(txy(:,1)));

% calculate speed
dt = gradient(txy(:,1));
dxdt = gradient(txy(:,2))./dt;
dydt = gradient(txy(:,3))./dt;
speed = sqrt(dydt.^2+dxdt.^2);
cutoff2 = prctile(speed,param.cutoff2);

% get peaks and valleys
peaks = findpeaks(speed); % findpeaks take care of NaNs correctly
peaks(isnan(peaks)) = 0;

% get rid of the NaN and keep the index for reverse mapping
txy0 = txy;
ii = find(~isnan(txy(:,2)) & ~isnan(speed))';
txy = txy(ii,:);
speed = speed(ii);
if ~isempty(speed)
    speed([1, end]) = 0;
end
peaks = peaks(ii);
minspeed = max([param.minspeed prctile(speed,param.minspeedprctile)]);
pi = find(peaks == 1 & speed>=minspeed & speed>=cutoff2);

% process each peak
cutoff = max(speed(pi)*param.cutoff,param.cutoff2);
k = 0;
interval = [0 0];
maxspeed = 0;
for j = 1:length(pi)
    qi = pi(j);
    cf = cutoff(j);
    starti = find(speed(1:qi-1)<=cf, 1, 'last' );
    endi = find(speed(qi+1:end)<=cf, 1 )+qi;
    if isoverlap(interval,[starti endi])
        interval = [min([interval(1) starti]) max([interval(2) endi])]; % merge the intervals
        sac.starti(k) = interval(1);
        sac.endi(k) = interval(2);
        if speed(qi)>maxspeed
            maxspeed = speed(qi);
            sac.peaki(k) = qi;
        end
    else % no overlap with current interval, hence a new saccade
        interval = [starti endi];
        k = k+1;
        maxspeed = speed(qi);
        sac.peaki(k) = qi;
        sac.starti(k) = starti;
        sac.endi(k) = endi;
    end
end
try % it is possible that we don't have any saccade
    % estimate measurement gaps
    k = (sac.endi(:)-sac.starti(:)+1)*sampintvl./(txy(sac.endi,1)-txy(sac.starti,1)+sampintvl)>=1-param.maxmeasgap;
    % saccade duration
    duration = (txy(sac.endi,1) - txy(sac.starti,1)+sampintvl);
    % saccade amplitude
    actuamplitude = sqrt(sum((txy(sac.starti,[2 3])-txy(sac.endi,[2 3])).^2,2));
    % duration, amplitude and measurement gap criteria
    i = find(duration>=param.mindur & actuamplitude>=param.minamp & k);
    sac.peaki = sac.peaki(i);
catch
    sac = [];
    return
end
if isempty(sac.peaki)
    sac = [];
    return
end
sac.starti = sac.starti(i);
sac.endi = sac.endi(i);
sac.duration = duration(i)';
sac.peakspeed = speed(sac.peaki)';
sac.actuamplitude = sqrt(sum((txy(sac.starti,[2 3])-txy(sac.endi,[2 3])).^2,2))'; % distance between start and end pts
% mean amplitude = duration*meanspeed
for i = 1:length(sac.starti)
    sac.meanspeed(i) = mean(speed(sac.starti(i):sac.endi(i)));
end

% remap the indices back to the input txy
sac.peaki = ii(sac.peaki);
sac.starti = ii(sac.starti);
sac.endi = ii(sac.endi);

% de-reference (in case we lose the txy data)
sac.startt = txy0(sac.starti,1)';
sac.startx = txy0(sac.starti,2)';
sac.starty = txy0(sac.starti,3)';
sac.endt = txy0(sac.endi,1)';
sac.endx = txy0(sac.endi,2)';
sac.endy = txy0(sac.endi,3)';




