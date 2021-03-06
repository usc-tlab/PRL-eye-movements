% preprocesssubj('har'); % run once only
% extracteyemovementssubj('har'); % run once only

load har_prep  % dat
%load har_eymo  % eymo
load har_eymobj
eymo = eymobj;

blk = 63;
phase = 4;
%blk = 62:63;
%phase = [1,4];

% plot eye movement feature extraction results across all trials 

% read across structures without any for-loops
fxastartt = [eymo.fxa(:,blk,phase).startt];
fxaendt = [eymo.fxa(:,blk,phase).endt];
fxastartx = [eymo.fxa(:,blk,phase).startx];
fxaendx = [eymo.fxa(:,blk,phase).endx];
fxastarty = [eymo.fxa(:,blk,phase).starty];
fxaendy = [eymo.fxa(:,blk,phase).endy];

sacstartt = [eymo.sac(:,blk,phase).startt];
sacendt = [eymo.sac(:,blk,phase).endt];
sacstartx = [eymo.sac(:,blk,phase).startx];
sacendx = [eymo.sac(:,blk,phase).endx];
sacstarty = [eymo.sac(:,blk,phase).starty];
sacendy = [eymo.sac(:,blk,phase).endy];

gaze = cat(1,dat(:,blk,phase).gaze);
obj = cat(1,dat(:,blk,phase).obj);

clf
subplot(2,1,1) % horizontal eye movements
line([fxastartt; fxaendt],[fxastartx; fxaendx],'Color',[0 1 0],'LineWidth',4); % fixations are green
line([sacstartt; sacendt],[sacstartx; sacendx],'Color',[1 0 0],'LineWidth',4); % saccades are red
hold on
plot(gaze(:,1),gaze(:,2)-obj(:,2),'b-');
hold off

subplot(2,1,2) % vertical eye movements
line([fxastartt; fxaendt],[fxastarty; fxaendy],'Color',[0 1 0],'LineWidth',4); % fixations are green
line([sacstartt; sacendt],[sacstarty; sacendy],'Color',[1 0 0],'LineWidth',4); % saccades are red
hold on
plot(gaze(:,1),gaze(:,3)-obj(:,3),'b-');
hold off
