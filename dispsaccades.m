function H = dispsaccades(sac)
% function H = dispsaccades(sac)
% Plot saccades with red line segments

% 4/2011 bst wrote it

sacstartt = [sac(:).startt];
sacendt = [sac(:).endt];
sacstartx = [sac(:).startx];
sacendx = [sac(:).endx];
sacstarty = [sac(:).starty];
sacendy = [sac(:).endy];

line([sacstartt; sacendt],[sacstartx; sacendx],'Color',[1 0 0],'LineWidth',4); % saccades are red
line([sacstartt; sacendt],[sacstarty; sacendy],'Color',[1 0 0],'LineWidth',4); % saccades are red


