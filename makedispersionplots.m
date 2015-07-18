% make trend plots for fixation dispersion
clear all
clf

subjs = {'mc','jsa','av','har','hk','ma'};
mfiles ={'mc_fixa_21_1_1.mat','jsa_fixa_30_1_1.mat','av_fixa_25_1_1.mat','har_fixa_6_1_2.mat','hk_fixa_11_1_1.mat','ma_fixa_11_1_1.mat'};
rfiles = {'mc_fixa_3_1_22.mat','jsa_fixa_3_1_86.mat','av_fixa_5_1_46.mat','har_fixa_5_1_46.mat','hk_fixa_5_1_12.mat','ma_fixa_4_1_13.mat'};
cfiles = {'C1_fixa_1_5_1.mat','C2_fixa_1_4_1.mat','C3_fixa_1_3_2.mat','C4_fixa_1_5_1.mat','my_fixa_1_3_1.mat'};

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
meandispersion = nanmean(dispersions([1 2 4:6],:));

bb = bone;
[~,kk] = sort(dispersions(:,1)); save('kk.mat','kk'); % to be used by the other plotting scripts
set(gca,'ColorOrder',bb(round(kk([1 2 4:6])*4+30),:));
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

plot(1:size(dispersions,2),dispersions([1 2 4:6],:), '.-','MarkerSize',24, 'LineWidth', 2);
hold on
plot(1:size(dispersions,2),dispersions(3,:), '.:','MarkerSize',24, 'LineWidth', 2,'Color', bb(round(kk([3])*5+30),:));
plot(1:19,meandispersion(1,1:19), '-','LineWidth', 4, 'Color', [0.7 0 0]);
plot(rcol:rcol+4,meandispersion(1,rcol:rcol+4), '-','LineWidth', 4, 'Color', [0.7 0 0]);

% for i = 1:size(dispersions,1)
%     line([endblk(i) rcol], [dispersions(i,endblk(i)) dispersions(i,rcol)], 'Color',bb(round(kk([i])*5+30),:));
% end
% line([19 rcol], [meandispersion(19) meandispersion(rcol)], 'Color',[0.7 0 0]);
ylabel('Fixation BCEA (deg^2)')
hold off
print('-depsc','-tiff','-r300','fxa_dispersion.eps');
