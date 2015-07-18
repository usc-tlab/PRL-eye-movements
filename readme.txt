May 9, 2011, VSS
Note by BST
Modified on 9/29/2011

This folder contains the code for processing eye tracking data from the 
object-following / visual search experiment by MiYoung.

The typical processing workflow is as follows:

1. Start with raw data (e.g. <subj>_*.mat)
2. Run preprocesssubj to merge raw data, perform median filtering, and generate <subj>_prep.mat
3. Run extracteyemovementssubj to extract eye-movement features in screen coorindates (origin at the center of screen) and generate <subj>_eymo.mat
4. Run rereftoobjsubj to re-reference eye-movement features to the object coordinates and generate <subj>_eymobj.mat
(Use dispeymo(bj)subj to visualize the extracted eye-movement features.)
(2-4 can be done with the script preprocessallsubjs
5. Run the following to get the relevant statistics: allsaccadedirections (*_sacdir_*), allfixations_retinal (*_fixa_*), firstlandings_retinal (*_1stlnd_*)
5b. For generating the plots used in the VSS poster, the script preploting_script replaces (5).
6. Run make*plots to generate the plots for the VSS poster:
    makelandingdispersionplots (first-landing BCEA trend)
    makedispersionplots (fixation BCEA trend)
    makeamplitudeplots (saccade amplitude trend)
(5b and 6 can be done by using the script makeallplots)