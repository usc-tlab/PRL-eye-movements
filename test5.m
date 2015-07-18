% display a density map the object position during fixations

load har_eymobj
load har_eymo

fxa = eymo.fxa; % fixations relative to objects
sac = eymo.sac;
obj = eymobj.obj;

trials = 1;
blks = 62;
phases = 3;


% x = [fxa(trials,blks,phases).rawx];
% y = [fxa(trials,blks,phases).rawy];
x = [fxa(trials,blks,phases).meanx];
y = [fxa(trials,blks,phases).meany];
ox = [obj(trials,blks,phases).rawx];
oy = [obj(trials,blks,phases).rawy];

xy = -[x', y'];
[bandwidth,density,X,Y] = kde2d(xy,512,[-20,-20],[20 20]);

% calculate mean and dispersion (sqrt(sum of variacne)) and overlay the principal axes
% basic statics
mu = bimean(X,Y,density)
[pv, pd] = bivar(X,Y,density);
dispersion = sqrt(sum(pv))
aspect_ratio = sqrt(pv(1)/pv(2))

param = dispdensity;
param.caxis = [0.01 0.5];
H=dispdensity(X,Y,density,param);

hold on;
plot(ox(:),oy(:),'k*');
plot(x(:),y(:),'r.');
hold off

% save figure
print -depsc -tiff -r300 test5
