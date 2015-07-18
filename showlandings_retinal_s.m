% Compute density map of object retinal position at the end of the n-th
% saccade after a given set of object movements.
% Save the figure as an eps file, which can be edited in Illustrator

subj = 'har';

load([subj '_eymobj']); %eymobj

phases = 1;
trials = 1:size(eymobj.sac,1);
%blks = 1:size(eymobj.sac,2);
blks = 1:round(size(eymobj.sac,2)/2);
whichobjectperiods = [1;4]; % other possibilities can be [2 3 4] or 1
whichsaccades = 1;

sac = eymobj.sac(trials,blks,phases);
obj = eymobj.obj(trials,blks,phases);

sac = selectwrtobj(sac,obj,whichsaccades,whichobjectperiods);

xy = [sac.endx]';
xy(:,2) = [sac.endy]';
xy = -xy;
[bandwidth,density,X,Y] = kde2d(xy);


param = dispdensity;
param.caxis = [0.001 0.5];
param.maxrange = 15;	% deg
param.ringstep = 5;	% deg
dispdensity(X,Y,density);

% compute mean and dispersion (sqrt(sum of variacne)) and overlay the principal axes
% basic statics
mu = bimean(X,Y,density)
[pv, pd] = bivar(X,Y,density);
dispersion = sqrt(sum(pv))
aspect_ratio = sqrt(pv(1)/pv(2))

% principal axes.  Line length == 1.96 SD (95% CI)
pd = pd*diag(sqrt(pv))*1.96; 
pd1 = pd+repmat(mu(:),[1,2]);
pd2 = -pd+repmat(mu(:),[1,2]);
line([pd2(1,1) pd2(1,2); pd1(1,1) pd1(1,2)],[pd2(2,1) pd2(2,2); pd1(2,1) pd1(2,2)], 'Color', [0 0 0], 'LineWidth', 1);

% save figure
print -depsc -tiff -r300 test3
