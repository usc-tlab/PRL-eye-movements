% make trend plot for 1-saccade landing dispersion (BCEA)
clear all
clf

subjs = {'mc','jsa','av','har','hk','ma'};
mfiles ={'mc_1stlnd_21_1_1.mat','jsa_1stlnd_30_1_1.mat','av_1stlnd_25_1_1.mat','har_1stlnd_6_1_2.mat','hk_1stlnd_11_1_1.mat','ma_1stlnd_11_1_1.mat'};
rfiles = {'mc_1stlnd_3_1_22.mat','jsa_1stlnd_3_1_86.mat','av_1stlnd_5_1_46.mat','har_1stlnd_5_1_46.mat','hk_1stlnd_5_1_12.mat','ma_1stlnd_4_1_13.mat'};
cfiles = {'C1_1stlnd_1_5_1.mat','C2_1stlnd_1_4_1.mat','C3_1stlnd_1_3_2.mat','C4_1stlnd_1_5_1.mat','my_1stlnd_1_3_1.mat'};


gap = 4;


% practice
for i=1:numel(mfiles)
    load(mfiles{i}); % stats
    dd = [stats(:).medlatency];
    latencies(i,1:numel(dd)) = dd;
    endblk(i) = length(dd);
end

% retention
rcol = size(latencies,2)+gap;
for i=1:numel(mfiles)
    load(rfiles{i}); % stats
    dd = [stats(:).medlatency];
    latencies(i,(1:numel(dd))+rcol-1) = dd;
end

latencies(latencies==0) = nan;
meanlatencies = nanmean(latencies([1 2 4:6],:));

bb = bone;
%[~,kk] = sort(dispersions(:,1)); 
load kk.mat %kk
set(gca,'ColorOrder',bb(round(kk([1 2 4:6])*4+30),:));
set(gca,'NextPlot', 'replacechildren')

% control box
for i=1:numel(cfiles)
    load(cfiles{i}); %stats
    dd = [stats(:).medlatency];
    clatencies(i,1:numel(dd)) = dd;
end
cmean = mean(clatencies);
csd = std(clatencies);
h=patch([0 0 40 40 0], [cmean-csd cmean+csd cmean+csd cmean-csd cmean-csd], [0.9 0.9 0.9]);
hold on 
plot([0 40],[cmean cmean],'--');

plot(1:size(latencies,2),latencies([1 2 4:6],:), '.-','MarkerSize',24, 'LineWidth', 2);
hold on
plot(1:size(latencies,2),latencies(3,:), '.:','MarkerSize',24, 'LineWidth', 2,'Color', bb(round(kk([3])*5+30),:));
plot(1:19,meanlatencies(1,1:19), '-','LineWidth', 4, 'Color', [0.7 0 0]);
plot(rcol:rcol+4,meanlatencies(1,rcol:rcol+4), '-','LineWidth', 4, 'Color', [0.7 0 0]);

% for i = 1:size(dispersions,1)
%     line([endblk(i) rcol], [dispersions(i,endblk(i)) dispersions(i,rcol)], 'Color',bb(round(kk([i])*5+30),:));
% end
% line([19 rcol], [meandispersion(19) meandispersion(rcol)], 'Color',[0.7 0 0]);

hold off
ylabel('Saccade Latency (s)')
print('-depsc','-tiff','-r300','saccade_latency.eps');
