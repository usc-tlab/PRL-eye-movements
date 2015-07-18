function H = drawrelocatedscotoma(xy)
% function H = drawrelocatedscotoma(xy)
% Draw the the scotoma centered at xy.  The scotoma is defined in
% scotoma_R_data.mat

% 5/2011 bst repacked MYK's script.

onhold = ishold;

load scotoma_R_data  % load scotoma data of a real patient (1x12) to SCOTOMA_R
SCOTOMA_TH = linspace(0,2*pi,numel(SCOTOMA_R)+1);
SCOTOMA_R(end+1) = SCOTOMA_R(1);

[SCOTOMA_X,SCOTOMA_Y] = pol2cart(SCOTOMA_TH,SCOTOMA_R);
shifX = (abs(max(SCOTOMA_X)) - abs(min(SCOTOMA_X)))/2; %this was used to center the scotoma in the experiment
shifY = (abs(max(SCOTOMA_Y)) - abs(min(SCOTOMA_Y)))/2;

SCOTOMA_X = SCOTOMA_X-shifX;
SCOTOMA_Y = SCOTOMA_Y-shifY;

hold on
H=patch(SCOTOMA_X+xy(1),SCOTOMA_Y+xy(2), [0.75 0.75 0.75], 'EdgeColor', [0.75 0.75 0.75]);
if ~onhold
    hold off
end