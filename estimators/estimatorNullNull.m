function estimates = estimatorNullNull(A,B)
    M =[null(A') null(B')];
    [U,S,V]=svd(M');

     % Normalize: Make the sign of the largest element positive.
    normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')));
    
    estimates(:,1)=ieScale(normalize(V(:,end)),1);

 
    

    
