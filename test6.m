% Compute the density of saccade directions from a given set of saccades
% within the given object-stationary period (a demo on how to use
% selelctwrtobj)
% Save the figure as an eps file, which can be edited in Illustrator

load jsa_eymo
load jsa_eymobj


trials = 1:size(eymo.sac,1);
blks = 1:size(eymo.sac,2);
phases = 3;
whichobjectperiods = []; % other possibilities can be [2 3 4] or 1
whichsaccades = [];

sac = eymo.sac(trials,blks,phases);
obj = eymobj.obj(trials,blks,phases);

sac = selectwrtobj(sac,obj,whichsaccades,whichobjectperiods);

xy = saccadedirection(sac);

[bandwidth,density,X,Y] = kde2d(xy);

% calculate mean and dispersion (sqrt(sum of variacne)) and overlay the principal axes
% basic statics
mu = bimean(X,Y,density)
[pv, pd] = bivar(X,Y,density);
dispersion = sqrt(sum(pv))
aspect_ratio = sqrt(pv(1)/pv(2))

param = dispdensity;
param.caxis = [0.001 0.2];
H=dispdensity(X,Y,density,param);

% save figure
print -depsc -tiff -r300 test4
