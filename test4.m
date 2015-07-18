% Compute the density of saccade directions, excluding saccades from the first object interval 
% Save the figure as an eps file, which can be edited in Illustrator

load har_eymo
load har_eymobj

sac = eymo.sac;
obj = eymobj.obj;

trials = 1:30;
blks = 62:63;
phases = 3;
whichobjects = 0:4; % other values of interest: [2 3 4] and 1

sac = selectbyobj(sac,obj,whichobjects,trials,blks,phases);

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
