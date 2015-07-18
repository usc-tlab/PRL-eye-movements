function out = selectwrtobj(sfo,obj,nths,objperiods,minlatency)
% function out = selectbyobj(sfo,obj,nths,objperiods,minlatency)
% Select a set of n-th's (nths) saccades or fixations (sfo) initiated within 
% each selected stationary periods of objects (objperiods).
%
% nths and objperiods are arrays of positive integers. If there are fewer
% saccades/fixations/object period than specified, the corresponding elements 
% in nths or objperiods will be ignored. [] denotes the full range.  
% 0 in objperiods denotes non-stationary period of objects.
%
% minlatency is the minimum latency in seconds of sfo on/offset after obj on/offset
%
% sfo(i) is processed w.r.t. obj(i)

% 4/2011 bst wrote it
% 9/2011 bst add the option of minlatency

out = sfo;

if ~exist('minlatency','var') || isempty(minlatency)
    minlatency = 0;
end
objperiodswasnull = 0;
if ~exist('objperiods','var') || isempty(objperiods)
    objperiodswasnull = 1;
end
nthswasnull = 0;
if ~exist('nths','var') || isempty(nths)
    nthswasnull = 1;
end

for i = 1:numel(sfo)
    if isempty(sfo(i).startt)
        continue
    end
    [objstartt, idx] = sort(obj(i).startt);
    objendt = obj(i).endt(idx);
    % select the object periods
    if objperiodswasnull
        objperiods = 0:numel(objstartt);
    end
    if nthswasnull
        nths = 1:numel(sfo(i).startt);
    end
    idx = objperiods(ismember(objperiods,1:numel(objstartt)));
    objstartt = objstartt(idx);
    objendt = objendt(idx);
    % select the saccades
    ks = zeros([1 numel(sfo(i).startt)]);
    hs = ks+1;
    objtime = ks+nan;
    for j = 1:numel(objstartt)
        idx = find(sfo(i).startt>=objstartt(j)+minlatency & sfo(i).startt<=objendt(j));
        if ~isempty(idx)
            ks(idx(nths(ismember(nths,1:numel(idx))))) = 1;
            objtime(idx) = objstartt(j);
            hs(idx) = 0;
        end
    end
    if ismember(0,objperiods)
        ks = ks+hs;
    end
    out(i) = subsfo(out(i),find(ks));
    out(i).latency = out(i).startt-objtime(ks~=0);
end