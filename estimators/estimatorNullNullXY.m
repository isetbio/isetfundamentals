function estimates = estimatorNullNullXY(A,B)

% x =  null(null(B')*A)
xx=getlastVfromSVD(null(B')'*A);

% y =  null(null(A')*B)
yy=getlastVfromSVD(null(A')'*B);

% Generate estimates
% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));
estimates(:,1)=ieScale(normalize(A*xx),1);
estimates(:,2)=ieScale(normalize(B*yy),1);

end
