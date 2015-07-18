% Compute density map of object retinal position at the end of the first
% saccade after an object had moved.
% Save the figure as an eps file, which can be edited in Illustrator

load har_eymobj

sac = eymobj.sac;
obj = eymobj.obj;

trials = 1:30;
blks = 62:63;
phases = [1 4];

xy = -firstlanding(sac,obj,trials,blks,phases);

[bandwidth,density,X,Y] = kde2d(xy,512,[-10,-10],[10 10]);
dispdensity(X,Y,density);

% compute mean and dispersion (sqrt(sum of variacne)) and overlay the principal axes
% basic statics
mu = bimean(X,Y,density)
[pv, pd] = bivar(X,Y,density);
dispersion = sqrt(sum(pv))
aspect_ratio = sqrt(pv(1)/pv(2))

% principal axes.  Line length == 3 SD
pd = pd*diag(sqrt(pv))*3; pd = pd+repmat(mu(:),[1,2]);
line([mu(1) mu(1); pd(1,1) pd(1,2)],[mu(2) mu(2); pd(2,1) pd(2,2)], 'Color', [0 0 0], 'LineWidth', 2);

% save figure
print -depsc -tiff -r300 test3
