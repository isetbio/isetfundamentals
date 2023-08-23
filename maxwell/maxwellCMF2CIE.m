%% Compare Maxwell CMFS with XYZ and Stockman
%
% The analysis here shows an excellent agreement between the CMFs
% reported by Maxwell in Tables VI and IX and the Stockman
% fundamentals.  This repeats an analysis performed by Judd, but with
% the XYZ curves.
%
% The script maxwellMatch has a new analysis. It computes directly
% from the matches in Table IV to the CMFs and shows a good match, as
% well.
%
% In both cases, we do a bit better by adjusting the Judd wavelength
% estimates by about 10 or 12 nm.
%
% See also
%  maxwellDataCMF, maxwellMatch, maxwellJuddWave.m

%% The Maxwell observers CMFs

obsJ = load("maxwellCMF_obsJ.mat");
obsK = load('maxwellCMF_obsK');
juddAdjust = 10;

%% Read Observer K CMF 

% Adjust the wavelengths
waveK = obsK.wave - juddAdjust;
XYZK = ieReadSpectra('XYZEnergy',waveK);
RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];


% Find the linear transform from the CMF to the XYZ
%
% The fit
%    XYZ ~ RGB*L
%    pinv(RGB)*XYZ = L
%
%   XYZ_est = RGB*L
L = pinv(RGB)*XYZK;
XYZ_estK = RGB*L;

%% 
ieNewGraphWin([],'big');
tiledlayout(2,2);

nexttile;
plot(waveK,XYZ_estK); hold on;
plot(waveK,XYZK,'LineStyle','--');
xlabel('Wavelength (nm)')
legend('XYZ','','','Maxwell ObsK fit');

%% Now for Observer J.

waveJ = obsJ.wave - juddAdjust;
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

wave = obsK.wave - juddAdjust;
SS = ieReadSpectra('StockmanEnergy',wave);
RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];

% plot(wave,RGB);

L = pinv(RGB)*SS;
SS_est = RGB*L;

nexttile;
plot(wave,SS_est); hold on;
plot(wave,SS,'LineStyle','--');
xlabel('Wavelength (nm)')
legend('Stockman','Maxwell ObsJ fit');

%% Observer J
wave = obsJ.wave - juddAdjust;
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

%% Make a slightly different figure styled for David Brainard

SSK = ieReadSpectra('StockmanEnergy',waveK);
L = pinv(SSK)*XYZK;
XYZK_SSest = SSK*L;

ieNewGraphWin([],'big'); clf; hold on;
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
xaxisLine;

%%