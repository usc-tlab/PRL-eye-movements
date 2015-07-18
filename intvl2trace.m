function trac = intvl2trace(intvl,mintracelength)
%function trac = intvl2trace(intvl [,mintracelength])
% Make a trace of incremental counts of non-overlapping 
% intervals.  These counts are indices into the rows of intvl.  
% intvl = [starti, endi] are a list of non-overlapping and inclusive 
% intervals indexed into trace.
%
% The resulting trace has a minimum length of mintracelength.  If not
% supplied, mintracelength is the shortest length required to hold all the
% intervals.
%
% If the intervals overlap, interval of a later row will overwrite the
% overlapping part of the earlier intervals.

% History: 
%   7/05 Bosco Tjan wrote it

if ~exist('mintracelength','var') | ~mintracelength
    mintracelength = max([intvl(:,2);0]);
end

trac = zeros([mintracelength 1]);

if isempty(intvl)
    return
end

for i = 1:size(intvl,1)
    trac(intvl(i,1):intvl(i,2)) = i;
end