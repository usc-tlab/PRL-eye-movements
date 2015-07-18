function peaks = findpeaks(M)
% function peaks = findpeaks(M)
% Returns the peaks along the first non-singleton dimension of m
% -1 at minimum, +1 at maximum, 0 elsewhere

[m n] = shiftdim(M);
p = -sign(diff(sign(diff(m))));

% pad and reshape
nd = ndims(m);
sz = prod(size(p))/size(p,1);
q = shiftdim(p,1);
r = reshape(q,[sz,size(p,1)]);
s(:,2:size(r,2)+1) = r;
s(:,1) = zeros(size(s(:,1)));
s(:,end+1) = zeros(size(s(:,1)));
p = shiftdim(s,nd-1);
peaks = shiftdim(p,-n);
