function estimates = estimatorNullNull(A,B)
%  
%
% See also
%  estimatorIntersect
%
% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));


V = getlastVfromSVD([null(A') null(B')]');
estimates(:,1) = ieScale(normalize(V(:,end)),1);

end



