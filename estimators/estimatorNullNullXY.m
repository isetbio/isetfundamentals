
function estimates = estimatorNullNullXY(A,B)

    % Get the last right singular vector V to obtain an estimate of
    % the null space;
    [U,S,V]=svd([A B]);
    x=V(:,end);
   
    % x =  null(null(B')*A)
    [U,S,V]=svd([null(B')'*A]);
    xx=V(:,end);
    % y =  null(null(A')*B)
    [U,S,V]=svd([null(A')'*B]);
    yy=V(:,end);
    % Concatenate x and y in one vector
    x=[xx;yy]

    % Generate estimates
    % Normalize: Make the sign of the largest element positive.
    normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));

    estimates(:,1)=ieScale(normalize(A*x(1:2)),1);
    estimates(:,2)=ieScale(normalize(B*x(3:4)),1);
    % By flipping the sign we obtain the average 
    
    
    
    
