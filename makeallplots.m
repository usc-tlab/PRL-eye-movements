% make all of the plot for the poster, and some ...
close all
preploting_script
figure
makecontourplots % contour plots for fixations and saccades at the beginning and end of training, and retention
makelandingdispersionplots % first landing as a function of blocks
makelatencyplots % latency as a function of blocks
makedispersionplots % fixation dispersions as a function of blocks
makedistanceplots % distance from end-of-training PRL 
makeamplitudeplots % saccade amplitudes during search as a function of blocks