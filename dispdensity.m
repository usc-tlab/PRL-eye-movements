function H = dispdensity(X,Y,density,param)
% function H = dispdensity(X,Y,density[,param])
% Make a contour plot of a density map, with nice trimmings

% 4/2011 bst wrote it

onhold = ishold;

if ~exist('param','var')
    % a few parameters that define the range
    param.toosmall = 0.0001; % density p is too low to be displayed if for x<p, sum(x)/sum(density(:)) is less than toosmall
    param.maxrange = 20;	% deg
    param.ringstep = 5;	% deg
    param.textgap = 0.15;	% proportion of ringstep
    param.textsize = 10;
    param.caxis = [0.01 0.2]; % color range
end

if ~exist('X','var')
    H = param; % return the plotting parameter for easy editing
    return
end

% set the axis
caxis(param.caxis);
xlim([-param.maxrange param.maxrange]);
ylim([-param.maxrange param.maxrange]);
axis equal
hold on

% plot the grid
lim = floor(param.maxrange/param.ringstep);
gap = param.ringstep*param.textgap;
text(gap,gap, '0','FontSize',param.textsize);
for i=1:lim
    mycircle([0 0],i*param.ringstep);
    text(0+gap,i*param.ringstep+gap, num2str(i*param.ringstep),'FontSize',param.textsize);
end
line([-lim*param.ringstep lim*param.ringstep], [0 0], 'color', [0 0 0]);
line([0 0], [-lim*param.ringstep lim*param.ringstep], 'color', [0 0 0]);

% finally the density
xx = sort(density(:));
xxs = cumsum(xx);
xxs = xxs/xxs(end);
i = find(xxs<param.toosmall,1,'last');
dmin = xx(i);
density(density<dmin) = 0;
density(X.^2+Y.^2>param.maxrange^2) = nan;
contour(X,Y,density)
axis off

if ~onhold
    hold off
end
H = gcf;