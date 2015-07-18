function bln = findblinks(tpu,param)
% function bln = findblinks(tpu[,param])
% Finds blinks given a time course of pupil sizes
% 
% bln has the following fields: starti, endi, duration

% History: 
%   7/05 Bosco Tjan wrote it
%   9/11 BST modified it to work the Eyelink data set

% time parameters are lowerbounds when sampling time were irregular
if ~exist('param','var')
    param.startwin = [0.05, 0.75]; % [x(sec), y] -- beginning of a blink is when the eye closes for y fraction of time during an x second window
    param.endwin = [0.075, 0.95];  % [x(sec), y] -- ending of a blick is when the eye opens for y fraction of time during an x second window
    param.baselinewin = 0.6;    % size of the median filter for computing the local baseline value of pupil size
    param.blinkthd = 99; % (%) --  percentile difference between measured and baseline pupil size that signals a blink
end

if ~exist('tpu','var') || isempty(tpu)
    bln = param;
    return;
end

sampintvl = median(diff(tpu(:,1)));
nsampst = round(param.startwin(1)/sampintvl);
nsampen = round(param.endwin(1)/sampintvl);
nsampbw = round(param.baselinewin(1)/sampintvl);

ii = find(~isnan(tpu(:,2)));
tpu = tpu(ii,:);
tpu(:,1) = tpu(:,1)-tpu(1,1);

bw = medfilt1(tpu(:,2),nsampbw);
minpu = prctile(bw-tpu(:,2),param.blinkthd);
dt = diff([0;tpu(:,1)]);
eyeclose = bw-tpu(:,2)>minpu;
closetm = cumsum(dt.*eyeclose);
opentm = cumsum(dt.*(~eyeclose));

sdurtm = tpu(nsampst+1:end,1)-tpu(1:end-nsampst,1);
sdurclose = closetm(nsampst+1:end)-closetm(1:end-nsampst,1);

edurtm = tpu(nsampen+1:end,1)-tpu(1:end-nsampen,1);
eduropen = opentm(nsampen+1:end)-opentm(1:end-nsampen,1);

si = find(sdurclose./sdurtm>=param.startwin(2) & eyeclose(1:length(sdurclose(:))));
ei = find(eduropen./edurtm>=param.endwin(2));

if isempty(si)
    bln = [];
    return
end

k = 1;
while ~isempty(si)
    starti(k) = si(1);
    i = min(find(ei>si(1)+nsampst));
    if i
    endi(k) = ei(i)-1;
    ei = ei(i+1:end);
    else
        endi(k) = length(tpu(:,1));
        ei = [];
    end
    j = min(find(si>endi(k)));
    if j
    si = si(j:end);
    else
        si = [];
    end
    k = k+1;
end

bln.duration = tpu(endi,1)-tpu(starti,1)+sampintvl;
bln.starti = ii(starti(:));
bln.endi = ii(endi(:));
