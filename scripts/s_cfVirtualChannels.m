%% Virtual channel conceptual
%
% The virtual channel concept differs from the conventional method of
% finding a linear transformation.  This script experiments with ways to
% demonstrate how they differ.
%
% In words, when we find a linear transform from A to B, we always find a
% channel that is within the space of A to match a channel in B. If B is
% outside of the space spanned by A, we will find the 'closets' channel in
% A to a channel in B.
%
% With the virtual channel approach, we ask whether there exists a weighted
% sum of the A channels (virtual-A) that is close to a weighted sum of B
% channels (vitual-B).  Neither of these virtual channels exists in the
% device itself.  But the two virtual channels are created as weighted sums
% of the real channels.
%
% A graphic to illustrate this, might be this: 
% 
% Suppose device A has two channels.  Create a 3D visualization of unit
% length vectors that span the color channels for device A, with the
% channels themselves labeled.  Then show two vectors that represent the
% channels in a second device, B.  These should be outside of the plane for
% device A.
%
% We indicate the linear transform solution of how we approximate device B
% channels with device A data.  These are weighted sums of the channels in
% A, and thus they are in the plane.
% 
% Then we show the intersecting virtual channel that can be reached by both
% a weighted sum of the channels of A and the weighted sum of the channels
% in B.
%

%% Devices

% Device A
A = [1 0; 0.5 0.3; 0 0];
for ii=1:2
    A(:,ii) = A(:,ii)/vectorLength(A(:,ii));
end

% Device B
B = [0 0; 1 .3; .2 1];
for ii=1:2
    B(:,ii) = B(:,ii)/vectorLength(B(:,ii));
end

%% Graph many virtual channels for A

ieNewGraphWin;

% Define the origin (O)
O = [0, 0, 0];
[x,y] = ieCirclePoints;
Aspace = A*[x(:),y(:)]';
P = Aspace';


% Extract x, y, and z coordinates of P
X = P(:, 1);
Y = P(:, 2);
Z = P(:, 3);

% Create a quiver plot
for ii=1:numel(X)
    hold on;
    quiver3(O(1), O(2), O(3), X(ii), Y(ii), Z(ii),'off','b');
end
grid on;


%% Add the channels for the first device
P = A';
X = P(:, 1);
Y = P(:, 2);
Z = P(:, 3);

for ii=1:2
    hold on;
    L = quiver3(O(1), O(2), O(3), X(ii), Y(ii), Z(ii),'off','b');
    L.LineWidth = 2; 
end

%% Add the channels for the second device
P = B';
X = P(:, 1);
Y = P(:, 2);
Z = P(:, 3);

for ii=1:2
    hold on;
    L = quiver3(O(1), O(2), O(3), X(ii), Y(ii), Z(ii),'off','r');
    L.LineWidth = 2;
end
 
set(gca,'zlim',[-1 1])
view(145,22);
[az el] = view
%% Show more of the B space possibilities, including the intersection

Bspace = B*[x(:),y(:)]';
P = Bspace';

% Extract x, y, and z coordinates of P
X = P(:, 1);
Y = P(:, 2);
Z = P(:, 3);

% Create a quiver plot
for ii=1:numel(X)
    hold on;
    quiver3(O(1), O(2), O(3), X(ii), Y(ii), Z(ii),'off','r');
end
grid on;
