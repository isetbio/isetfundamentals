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
