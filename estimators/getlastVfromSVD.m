function [v] = getlastVfromSVD(A)
    [U,S,V]=svd(A);
    v = V(:,end);
end

