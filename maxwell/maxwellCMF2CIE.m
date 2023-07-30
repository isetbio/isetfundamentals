%% Compare maxwell cmf with XYZ and then with StockmanEnergy
%
% Questions:
%    If we adjust the lens or macular pigment densities, could we
% make the fits a little bit better?
%    Should we focus on Stockman, XYZ, or both?
%
% See also
%  juddMaxwellWave.m, cfMaxwell.m

%% The Maxwell observers CMFs

obsJ = load("maxwellCMF_obsJ.mat");
obsK = load('maxwellCMF_obsK');

%% Read Observer K CMF and read XYZ corresponding wavelengths
juddAdjust = 12;

waveK = obsK.wave-juddAdjust;
XYZK = ieReadSpectra('XYZEnergy',waveK);
RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];

ieNewGraphWin;
tiledlayout(2,2);
%%
%{
ieNewGraphWin;
plot(waveK,XYZK);
plot(waveK,RGB);
%}

%% Find the linear transform from the CMF to the XYZ
%
% The fit
%    XYZ ~ RGB*L
%    pinv(RGB)*XYZ = L
%
%   XYZ_est = RGB*L
L = pinv(RGB)*XYZK;
XYZ_estK = RGB*L;

nexttile;
plot(waveK,XYZ_estK); hold on;
plot(waveK,XYZK,'LineStyle','--');
% legend('XYZ','','','Maxwell ObsK fit');

%% Now for Observer J.
waveJ = obsJ.wave-juddAdjust;
XYZJ = ieReadSpectra('XYZEnergy',waveJ);
RGB = [obsJ.R(:),obsJ.G(:),obsJ.B(:)];
L = pinv(RGB)*XYZJ;
XYZ_estJ = RGB*L;

nexttile;
plot(waveJ,XYZ_estJ); hold on;
plot(waveJ,XYZJ,'LineStyle','--');
xlabel('Wavelength (nm)')
legend('XYZ','Maxwell ObsJ fit');

%%  Now the StockmanEnergy functions - observer K
wave = obsK.wave;
SS = ieReadSpectra('StockmanEnergy',wave);
RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];

% plot(wave,RGB);

L = pinv(RGB)*SS;
SS_est = RGB*L;

nexttile;
plot(wave,SS_est); hold on;
plot(wave,SS,'LineStyle','--');
xlabel('Wavelength (nm)')
legend('SS','Maxwell ObsJ fit');

%% Observer J
wave = obsJ.wave;
SS = ieReadSpectra('StockmanEnergy',wave);
RGB = [obsJ.R(:),obsJ.G(:),obsJ.B(:)];

% plot(wave,RGB);

L = pinv(RGB)*SS;
SS_est = RGB*L;

nexttile;
plot(wave,SS_est); hold on;
plot(wave,SS,'LineStyle','--');
xlabel('Wavelength (nm)')
legend('SS','Maxwell ObsJ fit');

% Make a slightly different figure for David
SSK = ieReadSpectra('StockmanEnergy',waveK);
L = pinv(SSK)*XYZK;
XYZK_SSest = SSK*L;

figure; clf; hold on;
set(gca,'FontName','Helvetica','FontSize',26);
plot(waveK,XYZK(:,1),'-','Color','r','LineWidth',4);
plot(waveK,XYZK_SSest(:,1),':','Color','r','LineWidth',4);
set(gca,'FontName','Helvetica','FontSize',14);
plot(waveK,XYZ_estK(:,1),'o','Color','r','MarkerFaceColor','r','MarkerSize',12);
plot(waveJ,XYZ_estJ(:,1),'s','Color','r','MarkerFaceColor','r','MarkerSize',12);

plot(waveK,XYZK(:,2),'-','Color','g','LineWidth',4);
plot(waveK,XYZK_SSest(:,2),':','Color','g','LineWidth',4);
plot(waveK,XYZ_estK(:,2),'o','Color','g','MarkerFaceColor','g','MarkerSize',12);
plot(waveJ,XYZ_estJ(:,2),'s','Color','g','MarkerFaceColor','g','MarkerSize',12);

plot(waveK,XYZK(:,3),'-','Color','b','LineWidth',4);
plot(waveK,XYZK_SSest(:,3),':','Color','b','LineWidth',4);
plot(waveK,XYZ_estK(:,3),'o','Color','b','MarkerFaceColor','b','MarkerSize',12);
plot(waveJ,XYZ_estJ(:,3),'s','Color','b','MarkerFaceColor','b','MarkerSize',12);

xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',22);
ylabel('Tristimulus Value','FontName','Helvetica','FontSize',22);
legend({'CIE 1931 XYZ', 'Stockman-Sharpe expressed in XYZ', 'Maxwell 1860 Obs K expressed in XYZ', 'Maxwell 1860 Obs J expressed in XYZ'},'FontName','Helvetica','FontSize',18);
title('Color Matching Over 150 Years','FontName','Helvetica','FontSize',30);