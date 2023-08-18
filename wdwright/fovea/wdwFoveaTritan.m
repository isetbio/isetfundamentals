%% Read in the Willmer Wright foveal CMFs
%
% Scanned with grabit
% Figure 217 in WD Wright book
%

%
chdir(fullfile(iefundamentalsRootPath,'wdwright','fovea'));
wave = 400:5:700;

%%
load('foveaTritanGreen');
foveaGreen = interp1(foveaTritanGreen(:,1),foveaTritanGreen(:,2),wave,'pchip','extrap');

load('foveaTritanRed');
foveaRed = interp1(foveaTritanRed(:,1),foveaTritanRed(:,2),wave,'pchip','extrap');

foveatritan = [foveaRed(:),foveaGreen(:)];

%%
ieNewGraphWin;
plot(wave,foveatritan);

%%
saveFlag = false;
fname = fullfile(iefundamentalsRootPath,'wdwright','fovea','foveaTritan.mat');
if saveFlag
    ieSaveSpectralFile(wave,foveatritan,'Figure 217 in Wright book. Data with Willmer.',fname);
end

%%
data = ieReadSpectra(fname,wave);
ieNewGraphWin;
plot(wave,data);
load("wdwTritanopes.mat",'obsAverage');

%%
stockman = ieReadSpectra('stockmanEnergy',wave);

% foveatritan = stockman*L
L = stockman\foveatritan;

est = stockman*L;

%%
ieNewGraphWin;
plot(wave,ieScale(foveatritan,1),'rs-',...
    wave,ieScale(est,1),'k-', ...
    obsAverage.wave,ieScale(obsAverage.CMF,1),'bx-');
grid on; xlabel('Wavelength (nm)');
legend('foveal tritan','','stockman fit to fovea','','tritan average','')

