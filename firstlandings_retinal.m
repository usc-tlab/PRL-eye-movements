function stats = firstlandings_retinal(subj, ngrps, grpsz, blkrng)
%function stats = showlandings(subj, ngrps, grpsz[, blkrng])
% Compute density map of object's retinal position at the end of the first
% saccade after each object movement (whichobjectperiods) within the blocks in blkrng.
% ngrps: sample ngrps evenly from first to last block, taking grpsz number
% of consecutive blocks each.
% Save the figure as an eps file, which can be edited in Illustrator

% 4/2011 bst wrote it
% 6/2011 bst added BCEA at 68%, following Bellmann et al.2004
% 9/2011 bst added a minimum latency to object movement onset


% parameters
bceathd = .68;
minlatency = 0.05;
kdetrim = 0.1;
phases = [1 4];
whichobjectperiods = [2:4]; % other possibilities can be [2 3 4] or 1
whichsaccades = 1;

% processing
load([subj '_eymobj']); %eymobj

if ~exist('blkrng','var') || isempty(blkrng)
    blkrng = 1:size(eymobj.sac,2);
end

trials = 1:size(eymobj.fxa,1);
nblks = numel(blkrng);
ngrps = min(ngrps,nblks-grpsz+1);
step = floor((nblks-grpsz+1-1)/(ngrps-1));
if step <= 0
    stats = [];
    return
elseif ~isfinite(step)
    step = 1;
end

h=0;
for i = 1:ngrps
    clf
    b0 = (i-1)*step+1;
    blks = b0:b0+grpsz-1;
    sac = eymobj.sac(trials,blkrng(blks),phases);
    obj = eymobj.obj(trials,blkrng(blks),phases);
    
    sac = selectwrtobj(sac,obj,whichsaccades,whichobjectperiods,minlatency);
    
    xy = [sac.endx]';
    if isempty(xy)
        continue
    end
    xy(:,2) = [sac.endy]';
    xy = -xy;
    [bandwidth,density,X,Y] = kde2d_trimmed(kdetrim,xy,64,[-20 -20], [20 20]);
    
    % plot the scotoma
    drawrelocatedscotoma([0 0]);

    % plot the density
    param = dispdensity;
    param.caxis = [0.01 0.2];
    param.maxrange = 15;	% deg
    param.ringstep = 5;	% deg
    dispdensity(X,Y,density,param);
    
    % compute mean and dispersion (sqrt(mean of variacne)), BCEA and overlay the principal axes
    % basic statics
    mu = bimean(X,Y,density);
    [pv, pd] = bivar(X,Y,density);
    dispersion = sqrt(mean(pv));
    bcea = pi*chi2inv(bceathd,2)*sqrt(prod(pv)); %post VSS
    aspect_ratio = sqrt(pv(1)/pv(2));
    
    % principal axes.  Line length == 1 SD
    pd = pd*diag(sqrt(pv))*1;
    pd1 = pd+repmat(mu(:),[1,2]);
    pd2 = -pd+repmat(mu(:),[1,2]);
    line([pd2(1,1) pd2(1,2); pd1(1,1) pd1(1,2)],[pd2(2,1) pd2(2,2); pd1(2,1) pd1(2,2)], 'Color', [0 0 0], 'LineWidth', 1);
    % find and plot mode
    [~,pk] = max(density(:));
    mo = [X(pk);Y(pk)];
    hold on; plot(mo(1),mo(2),'r.','MarkerSize', 20);
    
    % variances along the radial and tangential direction
    r = mu/norm(mu);
    t = [0 -1; 1 0]*r;
    radv = abs(r'*pd(:,1)*pv(1)+r'*pd(:,2)*pv(2));
    tanv = abs(t'*pd(:,1)*pv(1)+t'*pd(:,2)*pv(2));
    
    % median latency
    medlatency = median([sac.latency]);

    % store the data
    h=h+1;
    stats(h).block = blkrng(floor(b0+(grpsz-1)/2))+mod(grpsz-1,2)/2; % block number at the center of the group, which is fractional if grpsz is even
    stats(h).mean = mu';
    stats(h).mode = mo';
    stats(h).var = pv';
    stats(h).principaldirections = pd';
    stats(h).dispersion = dispersion;
    stats(h).bcea = bcea;
    stats(h).aspectratio = aspect_ratio;
    stats(h).rdtgvar = [radv tanv];
    stats(h).medlatency = medlatency;
    
    % save a figure
    fname = sprintf('%s_1stlnd_%d_%d_%d_%d',subj,ngrps,grpsz,blkrng(1),i);
    print('-depsc','-tiff','-r300',fname);
end
fname = sprintf('%s_1stlnd_%d_%d_%d.mat',subj,ngrps,grpsz,blkrng(1));
if exist('stats','var')
    save(fname,'stats');
end
