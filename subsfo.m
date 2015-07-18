function out = subsfo(sfo,selection)
% function out = subsfo(sfo,selection)
% Select a subset of entries from a sac, fxa, or obj data structure
% selection is an array of indices

% 4/2011 bst wrote it

out = sfo;

selection = selection(selection<=numel(sfo.startt));
if isfield(sfo,'latency')
    out.latency = sfo.latency(selection(selection<=numel(sfo.latency)));
end
if isfield(sfo,'peaki') % a sac structure
    out.peaki = sfo.peaki(selection);
    out.starti = sfo.starti(selection);
    out.endi = sfo.endi(selection);
    out.duration = sfo.duration(selection);
    out.peakspeed = sfo.peakspeed(selection);
    out.actuamplitude = sfo.actuamplitude(selection);
    out.meanspeed = sfo.meanspeed(selection);
    out.startt = sfo.startt(selection);
    out.startx = sfo.startx(selection);
    out.starty = sfo.starty(selection);
    out.endt = sfo.endt(selection);
    out.endx = sfo.endx(selection);
    out.endy = sfo.endy(selection);
    return
end

if isfield(sfo, 'stdx') % fxa structure
    idx = ismember(sfo.rawgrp,selection);
    if idx == 0
        idx = [];
    end
    out.rawx=sfo.rawx(idx);
    out.rawy=sfo.rawy(idx);
    out.rawi=sfo.rawi(idx);
    out.rawgrp=sfo.rawgrp(idx);
    out.meanx=sfo.meanx(selection);
    out.meany=sfo.meany(selection);
    out.stdx=sfo.stdx(selection);
    out.stdy=sfo.stdy(selection);
    out.duration=sfo.duration(selection);
    out.startt=sfo.startt(selection);
    out.startx=sfo.startx(selection);
    out.starty=sfo.starty(selection);
    out.endt=sfo.endt(selection);
    out.endx=sfo.endx(selection);
    out.endy=sfo.endy(selection);
    out.starti=sfo.starti(selection);
    out.endi=sfo.endi(selection);
    return
end

% must be an obj structure
out.startt = sfo.startt(selection);
out.endt = sfo.endt(selection);
idx = ismember(sfo.rawgrp,selection);
if idx == 0
    idx = [];
end
out.rawx=sfo.rawx(idx);
out.rawy=sfo.rawy(idx);
out.rawgrp=sfo.rawgrp(idx);
