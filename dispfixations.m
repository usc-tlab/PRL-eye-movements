function H = dispfixations(sac)
% function H = dispfixations(sac)
% Plot fixations with green line segments

% 4/2011 bst wrote it

sacstartt = [sac(:).startt];
sacendt = [sac(:).endt];
sacstartx = [sac(:).startx];
sacendx = [sac(:).endx];
sacstarty = [sac(:).starty];
sacendy = [sac(:).endy];

line([sacstartt; sacendt],[sacstartx; sacendx],'Color',[0 1 0],'LineWidth',4); % fixations are green
line([sacstartt; sacendt],[sacstarty; sacendy],'Color',[0 1 0],'LineWidth',4); % fixations are green


