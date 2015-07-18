% distance between PRL across block
clear all
clf

subjs = {'mc','jsa','av','har','hk','ma'};
mfiles ={'mc_fixa_21_1_1.mat','jsa_fixa_30_1_1.mat','av_fixa_25_1_1.mat','har_fixa_6_1_2.mat','hk_fixa_11_1_1.mat','ma_fixa_11_1_1.mat'};
rfiles = {'mc_fixa_3_1_22.mat','jsa_fixa_3_1_86.mat','av_fixa_5_1_46.mat','har_fixa_5_1_46.mat','hk_fixa_5_1_12.mat','ma_fixa_4_1_13.mat'};

gap = 4;


% practice
for i=1:numel(mfiles)
    load(mfiles{i}); % stats
    mm = cat(1,stats(:).mode)';
    prlx(i,1:size(mm,2)) = mm(1,:);
    prly(i,1:size(mm,2)) = mm(2,:);
    endblk(i) = size(mm,2);
end

% retention
mx = size(prlx,2);
rcol = size(prlx,2)+gap;
for i=1:numel(mfiles)
    load(rfiles{i}); % stats
    mm = cat(1,stats(:).mode)';
    prlx(i,(1:size(mm,2))+rcol-1) = mm(1,:);
    prly(i,(1:size(mm,2))+rcol-1) = mm(2,:);
end

prlx(prlx==0) = nan;
prly(prly==0) = nan;

%put things together, align at end block
for i=1:numel(mfiles)
    prlx(i,:) = prlx(i,:) - prlx(i,endblk(i));
    x = prlx(i,:);
    prly(i,:) = prly(i,:) - prly(i,endblk(i));
    y = prly(i,:);
    prlx(i,1:mx) = nan;
    prly(i,1:mx) = nan;
    prlx(i,(1:endblk(i))+(mx-endblk(i))) = x(1:endblk(i));
    prly(i,(1:endblk(i))+(mx-endblk(i))) = y(1:endblk(i));
end

%keyboard
dist = sqrt(prlx.^2+prly.^2);
meandist = nanmean(dist([1 2 4:6],:));

bb = bone;
load kk.mat
set(gca,'ColorOrder',bb(round(kk([1 2 4:6])*4+30),:));
set(gca,'NextPlot', 'replacechildren')

% % control box
% cfiles = {'C1_fixa_1_5_1.mat','C2_fixa_1_4_1.mat','C3_fixa_1_3_2.mat','C4_fixa_1_5_1.mat'};
% 
% for i=1:numel(cfiles)
%     load(cfiles{i}); %stats
%     dd = [stats(:).dispersion];
%     cdispersions(i,1:numel(dd)) = dd;
% end
% cmean = mean(cdispersions);
% csd = std(cdispersions);
% h=patch([0 0 40 40 0], [cmean-csd cmean+csd cmean+csd cmean-csd cmean-csd], [0.9 0.9 0.9]);
% 
% hold on 

plot(1:size(dist,2),dist([1 2 4:6],:), '.-','MarkerSize',24, 'LineWidth', 2);
hold on
%plot(1:size(dist,2),dist(3,:), '.:','MarkerSize',24, 'LineWidth', 2,'Color', bb(round(kk([3])*5+30),:));
plot(1:mx,meandist(1,1:mx), '-','LineWidth', 4, 'Color', [0.7 0 0]);
plot(rcol:rcol+4,meandist(1,rcol:rcol+4), '-','LineWidth', 4, 'Color', [0.7 0 0]);

% for i = 1:size(dispersions,1)
%     line([endblk(i) rcol], [dispersions(i,endblk(i)) dispersions(i,rcol)], 'Color',bb(round(kk([i])*5+30),:));
% end
% line([19 rcol], [meandispersion(19) meandispersion(rcol)], 'Color',[0.7 0 0]);
ylabel('Distance from end-of-practice PRL (deg)')
hold off
print('-depsc','-tiff','-r300','fxa_dist.eps');
