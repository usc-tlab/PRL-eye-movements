function out = rerefcoords(s,ref)
% function out = rerefcoords(s,ref)
% Re-reference all coordinates in the fxa or sac data structure (s) to ref.
% ref = [X(:) Y(:)] are the new origins.  The indices stored in s refers
% to the rows of ref.

% 4/2011 bst wrote it
% 9/2011 bst corrected it to use only the new origins at the start of a fxa
% or sac

out = s;
if isempty(out.startx)
    return
end
out.startx = out.startx-ref(out.starti,1)';
out.starty = out.starty-ref(out.starti,2)';
out.endx = out.endx-ref(out.starti,1)';
out.endy = out.endy-ref(out.starti,2)';

if isfield(out, 'rawgrp') % this is a fxa structure
    [~,~,jj]=unique(out.rawgrp);
    r = ref(out.starti(jj),:);
    out.rawx = out.rawx-r(:,1)';
    out.rawy = out.rawy-r(:,2)';
    % recompute meanx/y stdx/y
    [out.meanx, out.stdx] =  grpstats(out.rawx(:),out.rawgrp(:));
    [out.meany, out.stdy] =  grpstats(out.rawy(:),out.rawgrp(:));
    out.meanx = out.meanx';
    out.meany = out.meany';
    out.stdx = out.stdx';
    out.stdy = out.stdy';
end
