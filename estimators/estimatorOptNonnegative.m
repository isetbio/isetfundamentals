function [estimates,wgts] = estimatorOptNonnegative(A,B)
% Solve optimization problem to estimate the intersection of the plane defined by matrices A and B and
% enforce a nonnegativivty constrainst
%  min (Ax-By)
% st Ax > 0 , By>0
%
%
% Synopsis
%  [estimates,wgts] = estimatorOptNonnegative(A,B)
%
% Brief
%   Applies to the dichromatic color matching functions.  Find the
%   intersection using the method described in the main text.
%
% Input
%  A,B are each (wave x 2) matrices
%
% Return
%  estimates - Estimated intersection (wave) vectors
%  wgts - The four weights, two for the A and two for B
%
% See also
%   getlastVfromSVD, estimatorIntersect


% Get initial estimate
J = [A -B] ;
H= J'*J;
x0 =getlastVfromSVD(J);

% Define the linear equality constraints
%Aeq = [1, 1, 1 1];       % Coefficients for equality constraint
%beq = 1;                 % Right-hand side for equality constraint
Aeq=[]; beq=[];

% Inequality cosntraints
Aineq = -[A zeros(size(B));
         zeros(size(A)) B];
bineq =zeros(size(B,1),2)

% Solve the quadratic programming problem
options = optimoptions('quadprog', 'Display', 'iter');  % Display iteration information
x = quadprog(H, [], Aineq, bineq, Aeq, beq, [], [], x0, options);

estimates(:,1)=A*x(1:2);
estimates(:,2)=B*x(3:4);
end

