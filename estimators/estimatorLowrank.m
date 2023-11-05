function estimate = estimatorLowrank(A,B)
% Estimate the vector at the intersection of A and B based on matrix rank
%
% Synopsis
%   estimate = estimatorLowrank(A,B)
%
% Inputs
%   A, B  - Two matrices with equal number of columns.
%
% Return
%   estimate - Column vector at the intersection of A and B subspaces
%
% Description
%   We create a matrix that combines [A,B]. If A and B each have n columns,
%   we use svd to find a rank 2n-1 approximation to the combination. We
%   return a vector in the null space of that low rank approximation.
%
%   This differs a bit from the logic in estimatorIntersect, which returns
%   two possible vectors for the intersection.
%
%   It also differs a bit from the logic in estimatorNullNull, which
%   returns one estimate but based on orthogonality to the adjoint spaces
%   of A and B.
%
% See also
%   estimatorIntersect, estimatorNullNull, conefundamentals


%% Checks and preliminary

% Normalize: A function to make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));

%% Calculation

% Form the matrix from the two dichromatic color matching functions
M =[A B];

nCols = size(A,2);
rank = size(M,2) - 1;

% Find the approximation of M
[U,S,V]=svds(M,rank);

M_lowrank = U*S*V';

% Because we have an 2N-1 to the 2N columns, approximation, there is a true
% null space.  Here is a vector in the null space.
x = null(M_lowrank);

% Forces a column vector
estimate(:,1)= ieScale(normalize(M_lowrank(:,1:nCols)*x(1:nCols)),1);

% No need to generate a second estimate because it would be identical
% due to the lowrank approximation
%
% Check :
% B_lowrank = M_lowrank(:,1:2);
% A_lowrank*x(1:2) == B_lowrank*x(3:4);

end
