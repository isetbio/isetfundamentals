function estimates = estimatorIntersect(A,B)
% Estimate the intersection of the plane defined by matrices A and B
%
% See also
%   getlastVfromSVD

assert(size(A,2) == 2);
assert(size(B,2) == 2);

% Get the last right singular vector V to obtain an estimate of
% the null space;
x = getlastVfromSVD([A -B]);

% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));
estimates(:,1)=ieScale(normalize(A*x(1:2)),1);
estimates(:,2)=ieScale(normalize(B*x(3:4)),1);

end





