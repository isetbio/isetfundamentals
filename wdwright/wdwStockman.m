%% Calculations with the dichromats and stockman
%
% Comparing whether the WDW CMFs are within a linear transform of the
% Stockman cone fundamentals.
%
% This is partly a test of reduction dichromacy. It also tests whether
% these data, collected about 70 years ago, can be directly compared
% with modern standards.
%
% The data are stored at different wavelength samples, so we keep
% reading in the Stockman in order to match the data sampling.
%
% See also
%   wdwData*


%% Protanope CMF

ieNewGraphWin([],'big');
pColor = [0.7 0.7 0.7];
tiledlayout(2,2);

% Protan
fname = fullfile(iefundamentalsRootPath,'wdwright','cmfProtan.mat');
load(fname,'wave','cmfProtan');
stockman = ieReadSpectra('stockmanEnergy',wave);

% protan = stockman*L
% Fig 200
Lprotan = stockman\cmfProtan;
estProtan = stockman*Lprotan;
nexttile;
plot(wave,estProtan,'k-','Linewidth',3);
hold on; plot(wave,cmfProtan,'.','Color',pColor,'Linewidth',1);
title('Protan');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

% Deutan
fname = fullfile(iefundamentalsRootPath,'wdwright','cmfDeutan.mat');
load(fname,'wave','cmfDeutan');
stockman = ieReadSpectra('stockmanEnergy',wave);

nexttile;
Ldeutan = stockman\cmfDeutan;
estDeutan = stockman*Ldeutan;
plot(wave,estDeutan,'k-','Linewidth',3);
hold on;
plot(wave,cmfDeutan,'.','Color',pColor,'Linewidth',1)
title('Deutan (Original)');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

% Tritan
fname = fullfile(iefundamentalsRootPath,'wdwright','cmfTritan.mat');
load(fname,'obsAverage');
% cmfTritan = obsAverage.CMF;
wave = min(obsAverage.wave):max(obsAverage.wave);
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,wave);
stockman = ieReadSpectra('stockmanEnergy',wave);

nexttile;
Ltritan = stockman\cmfTritan;
estTritan = stockman*Ltritan;
plot(wave,estTritan,'k-', 'LineWidth',3);
hold on; plot(wave,cmfTritan,'.','Color',pColor,'Linewidth',1)
title('Tritan');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

% DeutanC
fname = fullfile(iefundamentalsRootPath,'wdwright','cmfDeutanC.mat');
load(fname,'wave','cmfDeutanC');
stockman = ieReadSpectra('stockmanEnergy',wave);

nexttile;
LdeutanC = stockman\cmfDeutanC;
estDeutanC = stockman*LdeutanC;
plot(wave,estDeutanC,'k-','Linewidth',3);
hold on;
plot(wave,cmfDeutanC,'.','Color',pColor,'Linewidth',1)
title('Deutan (Corrected)');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

%% Fovea

fname = fullfile(iefundamentalsRootPath,'wdwright','cmfFovea.mat');
load(fname,'wave','cmfFovea');
stockman = ieReadSpectra('stockmanEnergy',wave);

% foveatritan = stockman*L
L = stockman\fovea;
estFovea = stockman*L;

ieNewGraphWin;
plot(wave,estFovea,'k-',wave,cmfFovea,'k--')
title('Stockman to Willmer Wright Fovea (Fig 208)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;
legend('Est','','WW Data','');

%%
ieNewGraphWin;
plot(wave,ieScale(cmfFovea,1),'rs-',...
    wave,ieScale(est,1),'k-', ...
    obsAverage.wave,ieScale(obsAverage.CMF,1),'bx-');
grid on; xlabel('Wavelength (nm)');
legend('foveal tritan','','stockman fit to fovea','','tritan average','')
