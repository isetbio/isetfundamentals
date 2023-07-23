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

wave = obsK.wave;
XYZ = ieReadSpectra('XYZEnergy',wave);
RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];

ieNewGraphWin;
tiledlayout(2,2);
%%
%{
ieNewGraphWin;
plot(wave,XYZ);
plot(wave,RGB);
%}

%% Find the linear transform from the CMF to the XYZ
%
% The fit
%    XYZ ~ RGB*L
%    pinv(RGB)*XYZ = L
%
%   XYZ_est = RGB*L
L = pinv(RGB)*XYZ;
XYZ_est = RGB*L;

nexttile;
plot(wave,XYZ_est); hold on;
plot(wave,XYZ,'LineStyle','--');
% legend('XYZ','','','Maxwell ObsK fit');

%% Now for Observer J.

wave = obsJ.wave;
XYZ = ieReadSpectra('XYZEnergy',wave);
RGB = [obsJ.R(:),obsJ.G(:),obsJ.B(:)];
L = pinv(RGB)*XYZ;
XYZ_est = RGB*L;

nexttile;
plot(wave,XYZ_est); hold on;
plot(wave,XYZ,'LineStyle','--');
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

%%