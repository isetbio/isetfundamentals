function [estimate] = estimatorNullNull(A,B)
% An estimation of the intersection between A and B spaces
%
% Synopsis
%   [estimate] = estimatorNullNull(A,B)
%
% Brief
%  Calculates the null space of the matrix created by joining the null
%  spaces of A' and B'.  Thomas thought this was a good idea because it
%  yields a single estimate. The idea is described in the paper's appendix,
%  Section C.1 (Null-Null Method).
%
% See also
%  estimatorIntersect, getlastVfromSVD
%

% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));

% See Appendix C in the paper for a description of the method.
V = getlastVfromSVD([null(A') null(B')]');

% One estimate is returned
estimate(:,1) = ieScale(normalize(V(:,end)),1);

end
