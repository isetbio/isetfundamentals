function estimates = estimatorLowrank(A,B)
% A method to estimate the vector at the intersection of A and B based
% on matrix rank
%
% We form the matrix of the dichromatic color matching functions, and
% we find a rank 3 approximation to it.  We return the null vector of
% that approximation.  This returns a single estimate.
%
% This differs a bit from the logic in estimatorIntersect, which
% returns two possible vectors for the intersection.
%
% See also
%   estimatorIntersect

% Form the matrix from the two dichromatic color matching functions
M =[A B];

% Get the last right singular vector V to obtain an estimate of
% the null space;

% Find rank-3 approximation of M
[U,S,V]=svds(M,3);
M_lowrank = U*S*V';
A_lowrank = M_lowrank(:,1:2);


% Because we have a rank-3 approximation, the null space exists
x = null(M_lowrank);

% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));

estimates(:,1)=ieScale(normalize(A_lowrank*x(1:2)),1);
% estimates(:,2)=ieScale(normalize(M_lowrank(:,3:4)*x(3:4)),1);

% No need to generate a second estimate because it would be identical
% due to the lowrank approximation
%
% Check :
% B_lowrank = M_lowrank(:,1:2);
% A_lowrank*x(1:2) == B_lowrank*x(3:4);

end
