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

%% Device spectral sensitivities

% The devices are specified w.r.t 3 wavelengths so we can render the
% graphics

% Device A
A = [1 .2; 0 1; 0 0];
for ii=1:2
    A(:,ii) = A(:,ii)/vectorLength(A(:,ii));
end

% Device B
B = [0 0.3; 1 0; .5 .7];
for ii=1:2
    B(:,ii) = B(:,ii)/vectorLength(B(:,ii));
end
% B(:,2) = null(A');

intersection = estimatorNullNull(A,B);

O = [0,0,0];
lStyle = '-'; lWidth1 = 3; lWidth2 = 3;

axLim = 1.2;
% delta = -0.005;
% delta = -0.01;
alpha = .7;

%% Show the plane

ieNewGraphWin;
set(gcf,'Position',[0.0070    0.1292    0.5727    0.7808]);

[x,y,z] = iePlaneFromVectors(A);

% {
fname = fullfile(iefundamentalsRootPath,'fig05VirtualChannel','texture2.png');
J = imread(fname);
W1 = warp(x,y,z,J); W1.FaceAlpha = 0.7;
% S1 = surf(x, y, z, ...
% 'FaceColor', 'texturemap', ...
% 'CData', J);
%}

%{
S1  = surf(x,y,z); hold on;
S2  = surf(x+delta,y+delta,z+delta);
faceColor1 = [1 1 1]* 0.7;
rotate3d on;
S1.FaceAlpha = alpha; S1.FaceColor = faceColor1; S1.EdgeColor = 'none';
S2.FaceAlpha = alpha; S2.FaceColor = faceColor1; S2.EdgeColor = 'none';
%}

set(gca,'zlim',[-axLim axLim],'ylim',[-axLim axLim],'xlim',[-axLim axLim])

%{
lgt1 = light("Style","local","Position",[-1 1 1]*2);
%}
% {
lgt1 = light("Style","Infinite","Position",[-1 1 1]);
lgt1.Position = [-10 -5 5];
lgt1.Color = [1 1 1];
%}
lighting gouraud;

%%
fontSize = 30;
xlabel('\lambda_1','FontSize',fontSize); 
ylabel('\lambda_2','FontSize',fontSize); 
zlabel('\lambda_3','FontSize',fontSize);
set(gca,'FontSize',24);
grid on

%% Show the real channels for the first device
P = -0.85*A';
X = P(:, 1); Y = P(:, 2); Z = P(:, 3);


% Try using arrow3, that I just put into isetcam/utilities/external
for ii=1:2
    hold on;
    %     L = quiver3(O(1), O(2), O(3), X(ii), Y(ii), Z(ii));
    deviceA(ii) = line([O(1),X(ii)],[O(2),Y(ii)],[O(3), Z(ii)]);
    deviceA(ii).LineWidth = lWidth2;
    deviceA(ii).Color = [0.7 0.1 0.2];
    deviceA(ii).LineStyle = lStyle;
end
grid on

%% Show the channels for the second device
P = B';
X = P(:, 1); Y = P(:, 2); Z = P(:, 3);

for ii=1:2
    hold on;
    deviceB(ii)= line([O(1),X(ii)],[O(2),Y(ii)],[O(3), Z(ii)]); %#ok<*SAGROW>
    deviceB(ii).LineWidth = lWidth2;
    deviceB(ii).Color = [0 0.3 0.8];
    deviceB(ii).LineStyle = lStyle;
end
 
axis equal; 
set(gca,'zlim',[-axLim axLim],'ylim',[-axLim axLim],'xlim',[-axLim axLim])

% view(-58,18);
% view(-44,10);
view(-33,12);

%{
exportgraphics(gca,fname,'Resolution','300');
%}

%% The possible channels from device B

[x,y,z] = iePlaneFromVectors(B);

fname = fullfile(iefundamentalsRootPath,'fig05VirtualChannel','texture1.png');
I = imread(fname);
W = warp(x,y,z,I); W.FaceAlpha = .8;
%{
S3  = surf(x,y,z);
S4  = surf(x+delta,y+delta,z+delta);
faceColor2 = [1 1 1]*0.7;

S3.FaceAlpha = alpha; S3.FaceColor = faceColor2 ; S3.EdgeColor = 'none';
S4.FaceAlpha = alpha; S4.FaceColor = faceColor2 ; S4.EdgeColor = 'none';
%}
% view(-44,10);
view(-33,12);

%% Show the intersection, reachable by both cameras

% L = quiver3(O(1), O(2), O(3), intersection(1), intersection(2), intersection(3),'off');
% L = line([O(1),intersection(1)],[ O(2),intersection(2)], [ O(3), intersection(3)]);
INT = line([-intersection(1),intersection(1)],[ -intersection(2),intersection(2)], [ -intersection(3), intersection(3)]);
INT.Color = 'k';
INT.LineWidth = lWidth1;
INT.LineStyle = '--';
fname = fullfile(iefundamentalsRootPath,'fig05VirtualChannel','virtualB.jpg');

deviceA(1).LineWidth = lWidth2; deviceA(2).LineWidth = lWidth2;
deviceB(1).LineWidth = lWidth2; deviceB(2).LineWidth = lWidth2;

view(-33,12);

%{
%%
exportgraphics(gca,fname,'Resolution','300');
%}
%{

%% Now illustrate with images
% scene = sceneCreate('macbeth',32);
% rgb = sceneGet(scene,'srgb');

fname = fullfile(isetRootPath,'data','images','rgb','FruitMCC_6500.tif');
rgb = imread(fname);
rgb = double(rgb);
[rgbXW,row,col] = RGB2XWFormat(rgb);

A1 = rgbXW*A(:,1); A1 = reshape(A1,row,col);
A2 = rgbXW*A(:,2); A2 = reshape(A2,row,col);
B1 = rgbXW*B(:,1); B1 = reshape(B1,row,col);
B2 = rgbXW*B(:,2); B2 = reshape(B2,row,col);

% montage({A1,A2});

%% This is the virtual channel image

% virtual = rgbXW*intersection(:); virtual = reshape(virtual,row,col);
% ieNewGraphWin; colormap(gray); imagesc(virtual); axis image;

% In terms of device A channels it is
wgtsA = pinv(A)*intersection;
virtualA = A1*wgtsA(1) + A2*wgtsA(2);

wgtsB = pinv(B)*intersection;
virtualB = B1*wgtsB(1) + B2*wgtsB(2);

ieNewGraphWin([]);
colormap(gray)
tiledlayout(2,3);
nexttile; imagesc(A1); axis image; set(gca,'xtick',[],'ytick',[]); subtitle('A1')
nexttile; imagesc(A2); axis image; set(gca,'xtick',[],'ytick',[]); subtitle('A2')
nexttile; imagesc(virtualA); axis image; set(gca,'xtick',[],'ytick',[]); subtitle('Virtual A')
nexttile; imagesc(B1); axis image; set(gca,'xtick',[],'ytick',[]); subtitle('B1')
nexttile; imagesc(B2); axis image; set(gca,'xtick',[],'ytick',[]); subtitle('B2')
nexttile; imagesc(virtualB); axis image; set(gca,'xtick',[],'ytick',[]); subtitle('Virtual B')

%{
 intersection, A*wgtsA(:), B*wgtsB(:)
%}

%% Try illuminant variation

wave = 400:10:700; 
fname = fullfile(isetRootPath,'data','images','rgb','FruitMCC_6500.tif');
scene = sceneFromFile(fname,'rgb',[],[],wave);

scene = sceneSet(scene,'name','6500');
sceneWindow(scene);

scene = sceneAdjustIlluminant(scene,blackbody(wave,2700,'energy')');
scene = sceneSet(scene,'name','2700');
sceneWindow(scene);
scene = sceneAdjustIlluminant(scene,blackbody(wave,8500,'energy')');
scene = sceneSet(scene,'name','8500');
sceneWindow(scene);

%% Create a quiver plot
%{
for ii=1:numel(X)
    hold on;
    L = quiver3(O(1), O(2), O(3), X(ii), Y(ii), Z(ii),'off');
    L.Color = [0.2 0.3 0.7];
    L.LineStyle = lStyle;
    L.LineWidth = 0.5;
end

grid on;
% [-axLim axLim]
% [0 axLim]
set(gca,'zlim',[-axLim axLim],'ylim',[-axLim axLim],'xlim',[-axLim axLim])
xlabel('Channel 1'); ylabel('Channel 2'); zlabel('Channel 3'); 
rotate3d on;
%}

%{
ieNewGraphWin;

% Define the origin (O)
O = [0, 0, 0];

nPoints = 90;

[x,y] = ieCirclePoints(2*pi/nPoints);
Aspace = A*[x(:),y(:)]';
P = Aspace';

% Extract x, y, and z coordinates of P
X = P(:, 1); Y = P(:, 2); Z = P(:, 3);
for ii=1:numel(X)
    P(ii,:) = P(ii,:)/vectorLength(P(ii,:));
end

%% Show more of the B space possibilities, including the intersection

Bspace = B*[x(:),y(:)]';
P = Bspace';

% Extract x, y, and z coordinates of P
X = P(:, 1); Y = P(:, 2); Z = P(:, 3);
for ii=1:numel(X)
      P(ii,:)  = P(ii,:)/vectorLength(P(ii,:));
end

% Create a quiver plot
for ii=1:numel(X)
    hold on;
    L = quiver3(O(1), O(2), O(3), X(ii), Y(ii), Z(ii),'off');
    L.Color = [0.7 .3 .2];
    L.LineStyle = lStyle;
    L.LineWidth = 0.5;
end
grid on;
view(-50,15);

set(gca,'zlim',[0 axLim],'ylim',[0 axLim],'xlim',[0 axLim])
%}

%}
%%
