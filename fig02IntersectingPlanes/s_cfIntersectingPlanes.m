%% Figure 02 


% Device A
A = [1 .2; 0 1; 0.3 0];
for ii=1:2
    A(:,ii) = A(:,ii)/vectorLength(A(:,ii));
end

% Device B
B = [0 0.3; 1 0; .5 .7];
for ii=1:2
    B(:,ii) = B(:,ii)/vectorLength(B(:,ii));
end
% B(:,2) = null(A');

% intersection = estimatorNullNull(A,B);

O = [0,0,0];
lStyle = '-'; lWidth1 = 3; lWidth2 = 3;

axLim = 1.2;
% delta = -0.005;
% delta = -0.01;
alpha = .7;

%%
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


%% The possible channels from device B

hold on;

[x,y,z] = iePlaneFromVectors(B);

fname = fullfile(iefundamentalsRootPath,'fig05VirtualChannel','texture1.png');
I = imread(fname);
W = warp(x,y,z,I); W.FaceAlpha = .8;
view(-33,12);

%%
fontSize = 30;
tmp = xlabel('\lambda_1','FontSize',fontSize); 
ylabel('\lambda_2','FontSize',fontSize); 
zlabel('\lambda_3','FontSize',fontSize);
set(gca,'FontSize',24);
grid on

%%