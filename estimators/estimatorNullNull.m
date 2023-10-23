function estimates = estimatorNullNull(A,B)
% Needs some comments.
%
%
% See also
%  estimatorIntersect
%

% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));

% We could use a comment here
V = getlastVfromSVD([null(A') null(B')]');
estimates(:,1) = ieScale(normalize(V(:,end)),1);

end



