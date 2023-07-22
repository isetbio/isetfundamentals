%% Compare maxwell cmf with XYZ
%

obsK = load("maxwellCMF_obsK.mat");
wave = obsK.wave;
XYZ = ieReadSpectra('XYZEnergy',wave);
RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];

%%
%{
ieNewGraphWin;
plot(wave,XYZ);
plot(wave,RGB);
%}

%% 
%
% Suppose we fit
%    XYZ ~ RGB*L
%    pinv(RGB)*XYZ = L
% Then
%
%   XYZ_est = RGB*L
L = pinv(RGB)*XYZ;
XYZ_est = RGB*L;

ieNewGraphWin;
plot(wave,XYZ_est); hold on;
plot(wave,XYZ,'LineStyle','--');
% legend('XYZ','','','Maxwell ObsK fit');

%% The other observer

obsK = load("maxwellCMF_obsJ.mat");
wave = obsJ.wave;
XYZ = ieReadSpectra('XYZEnergy',wave);
RGB = [obsJ.R(:),obsJ.G(:),obsJ.B(:)];

% plot(wave,RGB);

L = pinv(RGB)*XYZ;
XYZ_est = RGB*L;

ieNewGraphWin;
plot(wave,XYZ_est); hold on;
plot(wave,XYZ,'LineStyle','--');
xlabel('Wavelength (nm)')
legend('XYZ','Maxwell ObsJ fit');
