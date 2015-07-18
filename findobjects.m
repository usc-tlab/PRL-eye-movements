function obj = findobjects(txyxy)
% function obj = findobjects(txyxy)
% Build the obj data structure from a time series
% txyxy has three columns [T(:) X(:) Y(:)] if there is only one object.
% Each additional object adds two columns.

% 4/2011 bst wrote it

% startt and endt are inclusive
idx = sum(txyxy(2:end,2:end)~=txyxy(1:end-1,2:end),2)>0; 
idx1 = [1==1; idx];
idx2 = [idx; 1==1];
obj.startt = txyxy(idx1,1)';
obj.endt = txyxy(idx2,1)';
grp = cumsum(idx1);
X = txyxy(idx1,2:2:end)';
Y = txyxy(idx1,3:2:end)';
G = repmat(grp(idx1),[1 size(X,2)])';
obj.rawx = X(:)';
obj.rawy = Y(:)';
obj.rawgrp = G(:)';
