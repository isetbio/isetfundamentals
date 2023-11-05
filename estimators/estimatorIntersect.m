function [estimates,x] = estimatorIntersect(A,B)
% Estimate the intersection of the plane defined by matrices A and B
%
% Synopsis
%  [estimates,wgts] = estimatorIntersect(A,B)
%
% Brief
%   Applies to the dichromatic color matching functions.  Find the
%   intersection using the method described in the main text.
%
% Input
%  A,B are each (wave x 2) matrices
%
% Return
%  estimates - Estimated intersection (wave) vectors
%  wgts - The four weights, two for the A and two for B
%
% See also
%   getlastVfromSVD, estimatorNullNull

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





