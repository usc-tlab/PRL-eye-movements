% Compute the retinal position of object at fixation of a given set of fixations
% within a given set of object-stationary periods (a demo on how to use
% selelctwrtobj)
% Save the figure as an eps file, which can be edited in Illustrator

subj = 'av';

load([subj '_eymobj']); %eymobj


trials = 1:size(eymobj.fxa,1);
blks = round(size(eymobj.fxa,2)/2):size(eymobj.fxa,2);
phases = 4;
whichobjectperiods = []; % other possibilities can be [2 3 4] or 1
whichfixations = [];

fxa = eymobj.fxa(trials,blks,phases);
obj = eymobj.obj(trials,blks,phases);

fxa = selectwrtobj(fxa,obj,whichfixations,whichobjectperiods);

xy = [fxa.rawx]';
xy(:,2) = [fxa.rawy]';
xy = -xy;
[bandwidth,density,X,Y] = kde2d(xy);

% calculate mean and dispersion (sqrt(sum of variacne)) and overlay the principal axes
% basic statics
mu = bimean(X,Y,density)
[pv, pd] = bivar(X,Y,density);
dispersion = sqrt(sum(pv))
aspect_ratio = sqrt(pv(1)/pv(2))

param = dispdensity;
param.caxis = [0.001 0.5];
param.maxrange = 15;	% deg
param.ringstep = 5;	% deg
H=dispdensity(X,Y,density,param);

% principal axes.  Line length == 1.96 SD (95% CI)
pd = pd*diag(sqrt(pv))*1.96; 
pd1 = pd+repmat(mu(:),[1,2]);
pd2 = -pd+repmat(mu(:),[1,2]);
line([pd2(1,1) pd2(1,2); pd1(1,1) pd1(1,2)],[pd2(2,1) pd2(2,2); pd1(2,1) pd1(2,2)], 'Color', [0 0 0], 'LineWidth', 1);

% save figure
print('-depsc', '-tiff', '-r300', [subj '_' mfilename]);
