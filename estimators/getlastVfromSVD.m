function [v,s] = getlastVfromSVD(A)
% Last column of the SVD decomposition matrix, V  (Change the name)
%
% Synopsis
%  [v,s] = getlastVfromSVD(A)
%
% Brief 
%  Returns the last column of V. (Not V').  This is also the last row
%  of V'.  If A is singular, this vector is in its null space.
%
% Input
%   A - Any shape matrix
%
% Return
%   v - the last column of V in the SVD decomposition (A = U S V')
%   s - the smallest singular value from S
%
% Description
%  This column informs us about the null space of A.  
% 
%  The reasoning is that the SVD satisfies
%
%     A = U S V'
%
%  U and V are orthonormal.
%  
%  The last column of V multiplies into V' and creates the column vector
%  [0,0,0,....1]'.  
% 
%  Multiplying this vector times S produces [0,0,0,....s] where s is the
%  smallest singular value.
% 
%  This vector multiplies by U to produce the last column of U times s. U
%  is orthonormal, so this is the shortest vector.  
% 
%  If A is singular, the last singular value will be 0, and therefore v
%  will be in the null space of A.  If the last singular value is a little
%  bigger than 0, this will be the vector that is most nearly in the null
%  space of A.
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

[~,S,V] = svd(A);

% The vector
v = V(:,end);

% The last singular value
s = S(end);

end

