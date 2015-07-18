function xy = saccadedirection(sac,trials,blks,phases)
% function [xy] = saccadedirection(sac,trials,blks,phases)
% Calculate the directions of saccades: xy=[deltaX(:) deltaY(:)]

% 4/2011 bst wrote it

if ~exist('trials','var') || isempty(trials)
    trials = 1:size(sac,1);
end
if ~exist('blks','var') || isempty(blks)
    blks = 1:size(sac,2);
end
if ~exist('phases','var') || isempty(phases)
    phases = 1:size(sac,3);
end

startt = [sac(trials,blks,phases).startt];
endt = [sac(trials,blks,phases).endt];

startx = [sac(trials,blks,phases).startx];
starty = [sac(trials,blks,phases).starty];
endx = [sac(trials,blks,phases).endx];
endy = [sac(trials,blks,phases).endy];

xy(:,1) = (endx-startx)';
xy(:,2) = (endy-starty)';