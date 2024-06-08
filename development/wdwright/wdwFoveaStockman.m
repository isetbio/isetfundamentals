%% wdwFoveaStockman  - Probably should move to a separate file.
%
% The foveal data from the WD Wright project with Wilmer does not match
% cleanly with the Stockman data.  We illustrate the challenge here.
%

%% These are the cmf in the fovea (tritanopic)

fname = fullfile(iefundamentalsRootPath,'data','wdw','cmfFovea.mat');
load(fname,'wave','cmfFovea');
stockman = ieReadSpectra('stockmanEnergy',wave);

% cmfFovea = stockman*L
L = stockman\cmfFovea;
estFovea = stockman*L;

%%
ieNewGraphWin;
plot(wave,estFovea,'k-',wave,cmfFovea,'k--')
title('Stockman to Willmer Wright Fovea (Fig 208)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;
legend('Stockman fit','','WW Data','');

%% Plot again, but scaling to a common peak of 1

% Notice that the green primary in the tritan data is narrower than the
% best stockman fit.  The width in the red primary is OK, but it misses in
% that strange way near the peak.

ieNewGraphWin;
plot(wave,ieScale(cmfFovea,1),'r.',...
    wave,ieScale(estFovea,1),'k-');

% The obsAverage is loaded in wdwStockman.  But not clear enough to use
% here, about what it means. So commenting out.
%{
 plot(wave,ieScale(cmfFovea,1),'rs-',...
     wave,ieScale(estFovea,1),'k-', ...
     obsAverage.wave,ieScale(obsAverage.CMF,1),'bx-');
%}

grid on; xlabel('Wavelength (nm)');
legend('foveal tritan','','stockman fit to fovea','','tritan average','')

%}