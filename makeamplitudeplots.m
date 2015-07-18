% make saccade amplitude trend
clear all
clf

subjs = {'mc','jsa','av','har','hk','ma'};
mfiles ={'mc_sacdir_21_1_1.mat','jsa_sacdir_30_1_1.mat','av_sacdir_25_1_1.mat','har_sacdir_6_1_2.mat','hk_sacdir_11_1_1.mat','ma_sacdir_11_1_1.mat'};
rfiles = {'mc_sacdir_3_1_22.mat','jsa_sacdir_3_1_86.mat','av_sacdir_5_1_46.mat','har_sacdir_5_1_46.mat','hk_sacdir_5_1_12.mat','ma_sacdir_4_1_13.mat'};
cfiles = {'C1_sacdir_1_5_1.mat','C2_sacdir_1_4_1.mat','C3_sacdir_1_3_2.mat','C4_sacdir_1_5_1.mat','my_sacdir_1_3_1.mat'};

gap = 4;


% practice
for i=1:numel(mfiles)
    load(mfiles{i}); % stats
    dd = [stats(:).bcea];
    dispersions(i,1:numel(dd)) = dd;
    endblk(i) = length(dd);
end

% retention
rcol = size(dispersions,2)+gap;
for i=1:numel(mfiles)
    load(rfiles{i}); % stats
    dd = [stats(:).bcea];
    dispersions(i,(1:numel(dd))+rcol-1) = dd;
end

dispersions(dispersions==0) = nan;
meandispersion = nanmean(dispersions);

bb = bone;
%[~,kk] = sort(dispersions(:,1)); 
load kk.mat %kk
set(gca,'ColorOrder',bb(round(kk([1:6])*4+30),:));
set(gca,'NextPlot', 'replacechildren')

% control box

for i=1:numel(cfiles)
    load(cfiles{i}); %stats
    dd = [stats(:).bcea];
    cdispersions(i,1:numel(dd)) = dd;
end
cmean = mean(cdispersions);
csd = std(cdispersions);
h=patch([0 0 40 40 0], [cmean-csd cmean+csd cmean+csd cmean-csd cmean-csd], [0.9 0.9 0.9]);
hold on 
plot([0 40],[cmean cmean],'--');

plot(1:size(dispersions,2),dispersions(1:6,:), '.-','MarkerSize',24, 'LineWidth', 2);
hold on
plot(1:19,meandispersion(1,1:19), '-','LineWidth', 4, 'Color', [0.7 0 0]);
plot(rcol:rcol+4,meandispersion(1,rcol:rcol+4), '-','LineWidth', 4, 'Color', [0.7 0 0]);

% for i = 1:size(dispersions,1)
%     line([endblk(i) rcol], [dispersions(i,endblk(i)) dispersions(i,rcol)], 'Color',bb(round(kk([i])*5+30),:));
% end
% line([19 rcol], [meandispersion(19) meandispersion(rcol)], 'Color',[0.7 0 0]);
ylabel('Saccade BCEA (deg^2)')
hold off
ylabel('BCEA (deg^2)')
print('-depsc','-tiff','-r300','sacdir__dispersion.eps');
