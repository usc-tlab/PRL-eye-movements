function bool = isoverlap(a,b)
%function bool = isoverlap(a,b)
% Returns true if the intervals a and b overlap
% a and b are nx2 matrix, which row defines an inclusive interval
% We assume a,b(:,1)<=a,b(:,2)

% History: 
%   7/05 Bosco Tjan wrote it

bool = a(:,1)<=b(:,2) & b(:,1)<=a(:,2);
