function dat = preprocesssubj(subj)
% function dat = preprocesssubj(subj)
% Reformat and denoise raw data.  Save result to subj_prep.mat.
% Assuming the data files are named <subj>_<blk>.mat

% 2011/4/25 bst wrote it
% 2011/9    bst modify it to add explicit blink artifact removal and
% marking

% Parameters:
medfiltorder = 0.2; % (s) the order of the median filter define in time
%medfiltorder = 50; % (7) order of the 1-D median filter used to clean up raw data
dispctr = [512 384];
% eyerngx = [-1000 1024+1000]; % the permissble range of eye coordinates in pixel units
% eyerngy = [-1000 768+1000];  % these are now in removeartifacts.m
defaultppd = 26.36; % if the PixPerDeg field is missing from expmnt

% Processing:

flist = dir([subj '_*.mat']);
for i=1:numel(flist)
    a = find(flist(i).name=='_',1)+1;
    b = find(flist(i).name=='.',1,'last')-1;
    blk = str2double(flist(i).name(a:b));
    if isempty(blk) || isnan(blk) % not a data file
        continue
    end
    flist(i).name
    s = load(flist(i).name);
    trials = 1:numel(s.expmnt.data);
    if isfield(s.expmnt,'PixPerDeg')
        ppd = s.expmnt.PixPerDeg; % ppd is unlike to change, but just in case
    else
        ppd = defaultppd;
    end
    
    for t = trials
        % Phase 1
        if isfield(s.expmnt.data(1).phase1(1),'gazePupil')
            gazepupil = double(cat(1,s.expmnt.data(t).phase1(:).gazePupil));
        else
            gazepupil = [];
        end
        gazeraw = cat(1,s.expmnt.data(t).phase1(:).gazeTime);
        gazeraw(:,1) = gazeraw(:,2); % use the second column of gazeTime
        gazeraw(:,2:3) = (cat(1,s.expmnt.data(t).phase1(:).gazeSeq)-repmat(dispctr,[size(gazeraw,1) 1]));
        [gaze, artifact] = removeartifacts([gazeraw]);
        gazeraw(:,2:3) = gazeraw(:,2:3)/ppd;
        gazeraw(:,3) = -gazeraw(:,3); % flip the vertical axis (disp had (0,0) at upper left)
        gaze(:,2:3) = gaze(:,2:3)/ppd;
        gaze(:,3) = -gaze(:,3);
        gaze(:,2:3) = medfilt1(gaze(:,2:3),max(3,round(medfiltorder/median(diff(gaze(:,1)))))); %denoising
        obj = [];
        for k = 1:numel(s.expmnt.data(t).phase1)
            pp = s.expmnt.data(t).phase1(k);
            obj = [obj ; double(repmat([pp.targetLoc_x pp.targetLoc_y],[pp.numGazeIter 1]))];
        end
        obj = [gazeraw(:,1) (obj-repmat(dispctr,[size(gazeraw,1) 1]))/ppd];
        obj(:,3) = -obj(:,3);
        dat(t,blk,1).gazeraw = gazeraw;
        if ~isempty(gazepupil)
            dat(t,blk,1).gazepupil = gazepupil;
        else
            dat(t,blk,1).gazepupil = gazeraw(:,1)*0+1000;
        end
        dat(t,blk,1).gaze = gaze;
        dat(t,blk,1).artifact = artifact; % time axis follows that of gaze
        dat(t,blk,1).obj = obj;
        dat(t,blk,1).ppd = ppd;
        dat(t,blk,1).dispctr = dispctr;
        
        %Phase 4
        if ~isfield(s.expmnt.data(t),'phase4')
            continue % some data set don't have phase4
        end
        if isfield(s.expmnt.data(1).phase4(1),'gazePupil')
            gazepupil = double(cat(1,s.expmnt.data(t).phase4(:).gazePupil));
        else
            gazepupil = [];
        end
        gazeraw = cat(1,s.expmnt.data(t).phase4(:).gazeTime);
        gazeraw(:,1) = gazeraw(:,2); % use the second column of gazeTime
        gazeraw(:,2:3) = (cat(1,s.expmnt.data(t).phase4(:).gazeSeq)-repmat(dispctr,[size(gazeraw,1) 1]));
        [gaze, artifact] = removeartifacts([gazeraw]);
        gazeraw(:,2:3) = gazeraw(:,2:3)/ppd;
        gazeraw(:,3) = -gazeraw(:,3); % flip the vertical axis (disp had (0,0) at upper left)
        gaze(:,2:3) = gaze(:,2:3)/ppd;
        gaze(:,3) = -gaze(:,3);
        gaze(:,2:3) = medfilt1(gaze(:,2:3),max(3,round(medfiltorder/median(diff(gaze(:,1)))))); %denoising
        obj = [];
        for k = 1:numel(s.expmnt.data(t).phase4)
            pp = s.expmnt.data(t).phase4(k);
            obj = [obj ; double(repmat([pp.targetLoc_x pp.targetLoc_y],[pp.numGazeIter 1]))];
        end
        obj = [gazeraw(:,1) (obj-repmat(dispctr,[size(gazeraw,1) 1]))/ppd];
        obj(:,3) = -obj(:,3);
        dat(t,blk,4).gazeraw = gazeraw;
        if ~isempty(gazepupil)
            dat(t,blk,4).gazepupil = gazepupil;
        else
            dat(t,blk,4).gazepupil = gazeraw(:,1)*0+1000;
        end
        dat(t,blk,4).gaze = gaze;
        dat(t,blk,4).artifact = artifact; % time axis follows that of gaze
        dat(t,blk,4).obj = obj;
        dat(t,blk,4).dispctr = dispctr;
        
        %Phase 3
        if isfield(s.expmnt.data(1).phase3(1),'gazePupil')
            gazepupil = double(cat(1,s.expmnt.data(t).phase3(:).gazePupil));
        else
            gazepupil = [];
        end
        gazeraw = cat(1,s.expmnt.data(t).phase3(:).gazeTime);
        gazeraw(:,1) = gazeraw(:,2); % use the second column of gazeTime
        gazeraw(:,2:3) = (cat(1,s.expmnt.data(t).phase3(:).gazeSeq)-repmat(dispctr,[size(gazeraw,1) 1]));
        [gaze, artifact] = removeartifacts([gazeraw]);
        gazeraw(:,2:3) = gazeraw(:,2:3)/ppd;
        gazeraw(:,3) = -gazeraw(:,3); % flip the vertical axis (disp had (0,0) at upper left)
        gaze(:,2:3) = gaze(:,2:3)/ppd;
        gaze(:,3) = -gaze(:,3);
        gaze(:,2:3) = medfilt1(gaze(:,2:3),max(3,round(medfiltorder/median(diff(gaze(:,1)))))); %denoising
        obj = [];
        for k = 1:numel(s.expmnt.data(t).phase3)
            pp = s.expmnt.data(t).phase3(k);
            xx = double([pp.objectLoc_x; pp.objectLoc_y]);
            xx = xx(:)';
            obj = [obj ; repmat(xx,[pp.numGazeIter 1])];
        end
        obj = [gazeraw(:,1) (obj-repmat(dispctr,[size(gazeraw,1) size(obj,2)/2]))/ppd]; %format: txyxyxy
        obj(:,3) = -obj(:,3);
        dat(t,blk,3).gazeraw = gazeraw;
        if ~isempty(gazepupil)
            dat(t,blk,3).gazepupil = gazepupil;
        else
            dat(t,blk,3).gazepupil = gazeraw(:,1)*0+1000;
        end
        dat(t,blk,3).gaze = gaze;
        dat(t,blk,3).artifact = artifact; % time axis follows that of gaze
        dat(t,blk,3).obj = obj;
        dat(t,blk,3).ppd = ppd;
        dat(t,blk,3).dispctr = dispctr;
    end
end
save([subj '_prep.mat'],'dat');