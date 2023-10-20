function [v] = getlastVfromSVD(A)
% Last column of the SVD decomposition matrix, V
%
% Brief 
%  Returns the last column of V. (Not V').  This is also the last row
%  of V'.  If A is singular, this is in its null space.
%
% Input
%   A - A matrix (any shape)
%
% Return
%   v - the last column of the SVD decomposition, V
%
% Description
%  This column informs us about the null space of A.  The reasoning is
%  this that the SVD satisfies
%
%     A = U S V'
%
%  The last column of V multiplies into V' (which is orthonormal) to
%  yield the column vector [0,0,0,....1]'.  Multiplying this vector
%  times S produces [0,0,0,....s] where s is the smallest singular
%  value. This multiplies by U to produce the last column of U times s. 
%  U is orthonormal, so this is the shortest vector.  If A is
%  singular, the last singular value will be 0, and therefore v will
%  be in the null space of A.
%
% See also
%   estimatorIntersection

% Example:
%{
  A = rand(30);
  [U,S,V] = svd(A);
  A2 = U*S*V';
  max(abs(A(:) - A2(:)))  
%}

[~,~,V] = svd(A);
v = V(:,end);

end

