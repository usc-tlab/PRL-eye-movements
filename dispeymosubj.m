function h = dispeymosubj(subj,blks,trials,phases)
% function h = dispeymosubj(subj,blks,trials,phases)
% display the results of the feature extraction for eye movement data
%

% 4/2011 BST wrote it
% 9/2011 BST change the order of the parameters to be consistent with warning
% messages elsewhere

load([subj '_prep.mat']);  % dat
load([subj '_eymo.mat']);  % eymo

if ~exist('trials','var') || isempty(trials)
    trials = 1:size(eymo.sac,1);
end
if ~exist('blks','var') || isempty(blks)
    blks = 1:size(eymo.sac,2);
end
if ~exist('phases','var') || isempty(phases)
    phases = 1:size(eymo.sac,3);
end

% plot eye movement feature extraction results across all trials

% shift the dimensions so that things are in temporal other
fxa = shiftdim(eymo.fxa(trials,blks,phases),2);
sac = shiftdim(eymo.sac(trials,blks,phases),2);
dat = shiftdim(dat(trials,blks,phases),2);

% read across structures
fxastartt = [fxa.startt];
fxaendt = [fxa.endt];
fxastartx = [fxa.startx];
fxaendx = [fxa.endx];
fxastarty = [fxa.starty];
fxaendy = [fxa.endy];

sacstartt = [sac.startt];
sacendt = [sac.endt];
sacstartx = [sac.startx];
sacendx = [sac.endx];
sacstarty = [sac.starty];
sacendy = [sac.endy];

gaze = cat(1,dat.gaze);
gazeraw = cat(1,dat.gazeraw);
if isfield(dat,'artifact')
    artifact = cat(1,dat.artifact);
end
if isfield(dat,'gazepupil')
    gazepupil = cat(1,dat.gazepupil);
end
obj = [];
for i=1:numel(dat)
    if ~isempty(dat(i).obj)
        obj = cat(1,obj,dat(i).obj(:,1:3));
    end
end

t0 = min([fxastartt(:); sacstartt(:); obj(:,1)]);  % try to zero out the first time point

clf
line([fxastartt; fxaendt]-t0,[fxastartx; fxaendx],'Color',[0 1 0],'LineWidth',4); % fixations are green
line([sacstartt; sacendt]-t0,[sacstartx; sacendx],'Color',[1 0 0],'LineWidth',4); % saccades are red
hold on
plot(gazeraw(:,1)-t0,gazeraw(:,2),'b-');
plot(obj(:,1)-t0,obj(:,2),'k-');
plot(gaze(:,1)-t0,gaze(:,2),'m-');
if isfield(dat,'gazepupil')
    plot(gazeraw(:,1)-t0,gazepupil/200,'c-');
end
if isfield(dat,'artifact')
    plot(gaze(:,1)-t0,artifact*10,'y-');
end

line([fxastartt; fxaendt]-t0,[fxastarty; fxaendy],'Color',[0 1 0],'LineWidth',4); % fixations are green
line([sacstartt; sacendt]-t0,[sacstarty; sacendy],'Color',[1 0 0],'LineWidth',4); % saccades are red
hold on
plot(gazeraw(:,1)-t0,gazeraw(:,3),'b-');
plot(gaze(:,1)-t0,gaze(:,3),'m-');
plot(obj(:,1)-t0,obj(:,3),'k-');
ylim([-25 25]);
hold off
