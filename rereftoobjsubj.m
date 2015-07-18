function eymobj = rereftoobjsubj(subj)
% function eymobj = rereftoobjsubj(subj, whichobj)
% Re-reference eye movement coordiatenates to center the object.
% Save the results to <subj>_eymobj.mat
%
% <subj>_prep.mat and <subj>_eymo.mat must exist

% 4/2011 bst wrote it

s = load([subj '_prep.mat']);
m = load([subj '_eymo.mat']);

dat = s.dat;
eymo = m.eymo;
for p = 1:size(dat,3)
    for b = 1:size(dat,2)
        for t = 1:size(dat,1)
            if isempty(dat(t,b,p).gaze)
                continue
            end
            obj = dat(t,b,p).obj;
            eymobj.sac(t,b,p) = rerefcoords(eymo.sac(t,b,p),obj(:,2:3)); % relative to the first object if there are more than one
            eymobj.fxa(t,b,p) = rerefcoords(eymo.fxa(t,b,p),obj(:,2:3));
            eymobj.obj(t,b,p) = findobjects(obj);
        end
    end
end
save([subj '_eymobj.mat'], 'eymobj');