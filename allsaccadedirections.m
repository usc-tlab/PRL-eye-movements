function stats = allsaccadedirections(subj, ngrps, grpsz, blkrng)
%function stats = allsaccadedirections(subj, ngrps, grpsz[, blkrng])
% Compute density map of saccade directions of the selected
% saccade (whichsaccades) after each object movement (whichobjectperiods) 
% within the blocks in blkrng.
% ngrps: sample ngrps evenly from first to last block, taking grpsz number
% of blocks each.
% Save the figure as an eps file, which can be edited in Illustrator

% 4/2011 bst wrote it
% 9/2011 bst add BCEA at 68%, following Bellman et al.
% 2004.  Also added a minimum latency requirement after object movement
% onset.


% parameters
bceathd = .9;
minlatency = 0.1;
kdetrim = 0.1; % trim 10%
phases = [1 3 4];
%phases = [3];
whichobjectperiods = []; % other possibilities can be [2 3 4] or 1
whichsaccades = [];

% processing
load([subj '_eymo']); %eymo
load([subj '_eymobj']); %eymobj

if ~exist('blkrng','var') || isempty(blkrng)
    blkrng = 1:size(eymo.sac,2);
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
    b0 = (i-1)*step+1;
    blks = b0:b0+grpsz-1;
    sac = eymo.sac(trials,blkrng(blks),phases);
    obj = eymobj.obj(trials,blkrng(blks),phases);
    
    sac = selectwrtobj(sac,obj,whichsaccades,whichobjectperiods);
    if isempty([sac.peaki])
        continue
    end
    xy = saccadedirection(sac);
    numsaccades = size(xy,1);
    [bandwidth,density,X,Y] = kde2d_trimmed(kdetrim,xy,64,[-20 -20], [20 20]);
    % wait till later to plot density
    
    
    % compute mean and dispersion (sqrt(mean of variacne)), BCEA and overlay the principal axes
    % basic statics
    mu = bimean(X,Y,density);
    [pv, pd] = bivar(X,Y,density);
    dispersion = sqrt(mean(pv));
    bcea = pi*chi2inv(bceathd,2)*sqrt(prod(pv)); %post VSS
    aspect_ratio = sqrt(pv(1)/pv(2));
    
    %     % principal axes.  Line length == 1 SD
    %     pd = pd*diag(sqrt(pv))*1;
    %     pd1 = pd+repmat(mu(:),[1,2]);
    %     pd2 = -pd+repmat(mu(:),[1,2]);
    %     line([pd2(1,1) pd2(1,2); pd1(1,1) pd1(1,2)],[pd2(2,1) pd2(2,2); pd1(2,1) pd1(2,2)], 'Color', [0 0 0], 'LineWidth', 1);
    %     drawnow; pause(0.1)
    
    % variances along the radial and tangential direction
    r = mu/norm(mu);
    t = [0 -1; 1 0]*r;
    radv = abs(r'*pd(:,1)*pv(1)+r'*pd(:,2)*pv(2));
    tanv = abs(t'*pd(:,1)*pv(1)+t'*pd(:,2)*pv(2));
    
    % mean saccade amplitude from density
    amp = sqrt(X.^2+Y.^2).*density;
    amp = sum(amp(:))/sum(density(:));
    
    % store the data
    h=h+1;
    stats(h).numsaccades = numsaccades;
    stats(h).block = blkrng(floor(b0+(grpsz-1)/2))+mod(grpsz-1,2)/2; % block number at the center of the group, which is fractional if grpsz is even
    stats(h).mean = mu';
    stats(h).var = pv';
    stats(h).principaldirections = pd';
    stats(h).dispersion = dispersion;
    stats(h).bcea = bcea;
    stats(h).meanamp = amp;
    stats(h).aspectratio = aspect_ratio;
    stats(h).rdtgvar = [radv, tanv];
    
    % compute PRL based on the mode of fixation, and if exists, plot the scotoma
    % plot the saccade density
    fxa = eymobj.fxa(trials,blkrng(blks),[1 4]);
    obj = eymobj.obj(trials,blkrng(blks),[1 4]);
    fxa = selectwrtobj(fxa,obj,[],2:4);
    xy = [fxa.rawx]';
    if ~isempty(xy)
        xy(:,2) = [fxa.rawy]';
        [~,densityf,Xf,Yf] = kde2d(xy,64,[-20 -20], [20 20]);
        [~,pk] = max(densityf(:));
        mo = [Xf(pk);Yf(pk)];
        clf
        drawrelocatedscotoma(mo);
        param = dispdensity;
        param.caxis = [0.002 0.02];
        param.maxrange = 15;	% deg
        param.ringstep = 5;	% deg
        dispdensity(X,Y,density,param);
    end
    
    fname = sprintf('%s_sacdir_%d_%d_%d_%d',subj,ngrps,grpsz,blkrng(1),i);
    print('-depsc','-tiff','-r300',fname);
end
if exist('stats','var')
    fname = sprintf('%s_sacdir_%d_%d_%d.mat',subj,ngrps,grpsz,blkrng(1));
    save(fname,'stats');
end

