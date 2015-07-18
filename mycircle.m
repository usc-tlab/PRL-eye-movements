function H=mycircle(ctr,rad)
%
% Draw a circle using MATLAB's rectangle function
% Usage: H=circle(ctr,rad)
%

H = rectangle('Position',[ctr(1)-rad ctr(2)-rad 2*rad 2*rad],'Curvature',[1 1]);
