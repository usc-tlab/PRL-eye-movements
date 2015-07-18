function out = mergesfos(sfos)
% function out = mergesfos(sfos)
% Merge a set of sac, fxa, or obj data structures

% 4/2011 bst wrote it

out = sfos(1);
if isfield(sfos(1),'peaki') % a sac structure
    out.peaki = [sfos(:).peaki] ;
    out.starti = [sfos(:).starti];
    out.endi = [sfos(:).endi];
    out.duration = [sfos(:).duration];
    out.peakspeed = [sfos(:).peakspeed];
    out.actuamplitude = [sfos(:).actuamplitude];
    out.meanspeed = [sfos(:).meanspeed];
    out.startt = [sfos(:).startt];
    out.startx = [sfos(:).startx];
    out.starty = [sfos(:).starty];
    out.endt = [sfos(:).endt];
    out.endx = [sfos(:).endx];
    out.endy = [sfos(:).endy];
    return
end

if isfield(sfos(1), 'stdx') % fxa structure
    % rename the rawgrp indices before we merge
    k = 0;
    for i=2:numel(sfos)
        k = k+numel(sfos(i-1).starti);
        sfos(i).rawgrp = sfos(i).rawgrp+k;
    end
    out.rawx=[sfos(:).rawx];
    out.rawy=[sfos(:).rawy];
    out.rawi=[sfos(:).rawi];
    out.rawgrp=[sfos(:).rawgrp];
    out.meanx=[sfos(:).meanx];
    out.meany=[sfos(:).meany];
    out.stdx=[sfos(:).stdx];
    out.stdy=[sfos(:).stdy];
    out.duration=[sfos(:).duration];
    out.startt=[sfos(:).startt];
    out.startx=[sfos(:).startx];
    out.starty=[sfos(:).starty];
    out.endt=[sfos(:).endt];
    out.endx=[sfos(:).endx];
    out.endy=[sfos(:).endy];
    out.starti=[sfos(:).starti];
    out.endi=[sfos(:).endi];
    return
end

% must be obj
out.startt = [sfos(:).startt];
out.endt = [sfos(:).endt];
k = 0;
for i=2:numel(sfos)
    k = k+numel(sfos(i-1).startt);
    sfos(i).rawgrp = sfos(i).rawgrp+k;
end
out.rawx=[sfos(:).rawx];
out.rawy=[sfos(:).rawy];
out.rawgrp=[sfos(:).rawgrp];


