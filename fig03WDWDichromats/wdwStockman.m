%% Figure 03
%
% Comparing whether the WDW CMFs are within a linear transform of the
% Stockman cone fundamentals.
%
% This is partly a test of reduction dichromacy. It also tests whether
% these data, collected about 70 years ago, can be directly compared
% with modern standards.
%
% The data are stored at different wavelength samples, so we keep
% reading in the Stockman in order to match the wavelength sampling.
%
% See also
%   wdwData*

%% Protanope CMF

% Protan
fname = fullfile(iefundamentalsRootPath,'data','wdw','cmfProtan.mat');
load(fname,'wave','cmfProtan');
stockman = ieReadSpectra('stockmanEnergy',wave);

% protan = stockman*L
% Fig 200
Lprotan = stockman\cmfProtan;
estProtan = stockman*Lprotan;

% Deutan
fname = fullfile(iefundamentalsRootPath,'data','wdw','cmfDeutan.mat');
load(fname,'wave','cmfDeutan');

% The wave is the same.  So no need to reread.
% stockman = ieReadSpectra('stockmanEnergy',wave);

ieNewGraphWin([],'big');
pColor = [1 1 1]*0;
tiledlayout(2,2);

nexttile;
plot(wave(1:2:end),estProtan(1:2:end,:),'ko','Linewidth',1,'MarkerSize',2);
hold on; plot(wave,cmfProtan,'-','Color',pColor,'Linewidth',2);
title('Protan');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

nexttile;
Ldeutan = stockman\cmfDeutan;
estDeutan = stockman*Ldeutan;
plot(wave(1:2:end),estDeutan(1:2:end,:),'ko','Linewidth',1,'MarkerSize',2);
hold on;
plot(wave,cmfDeutan,'-','Color',pColor,'Linewidth',2)
title('Deutan (Original)');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

% Tritan - the wavelength is different
fname = fullfile(iefundamentalsRootPath,'data','wdw','cmfTritan.mat');
load(fname,'obsAverage');
% cmfTritan = obsAverage.CMF;
wave = min(obsAverage.wave):max(obsAverage.wave);
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,wave);
stockman = ieReadSpectra('stockmanEnergy',wave);

nexttile;
Ltritan = stockman\cmfTritan;
estTritan = stockman*Ltritan;
plot(wave(1:2:end),estTritan(1:2:end,:),'ko', 'LineWidth',1,'MarkerSize',2);
hold on; plot(wave,cmfTritan,'-','Color',pColor,'Linewidth',2)
title('Tritan');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

% DeutanC - back to original wave
fname = fullfile(iefundamentalsRootPath,'data','wdw','cmfDeutanC.mat');
load(fname,'wave','cmfDeutanC');
stockman = ieReadSpectra('stockmanEnergy',wave);

nexttile;
LdeutanC = stockman\cmfDeutanC;
estDeutanC = stockman*LdeutanC;
plot(wave(1:2:end),estDeutanC(1:2:end,:),'ko','Linewidth',1,'MarkerSize',2);
hold on;
plot(wave,cmfDeutanC,'-','Color',pColor,'Linewidth',2)
title('Deutan (Corrected)');
xlabel('Wavelength (nm)');
ylabel('Primary intensity (a.u.)'); grid on;

%% END