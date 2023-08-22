%% Calculations with the dichromats and stockman
%
% In progress.


%% Now compare with Stockman

stockman = ieReadSpectra('stockmanEnergy',wave);

%% deutan = stockman*L
ieNewGraphWin([],'wide');
tiledlayout(1,2);

% protan = stockman*L
Lprotan = stockman\protanCMF;
estProtan = stockman*Lprotan;
nexttile;
plot(wave,estProtan,'k-',wave,protanCMF,'k.')
title('Stockman to Protan (Fig 200)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;

nexttile;
Ldeutan = stockman\cmfDeutan;
estDeutan = stockman*Ldeutan;
plot(wave,estDeutan,'k-',wave,cmfDeutan,'k.')
title('Stockman to Deutan (Fig 208)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;


%%
data = ieReadSpectra(fname,wave);
ieNewGraphWin;
plot(wave,data);
load("wdwTritanopes.mat",'obsAverage');

%% Fovea

stockman = ieReadSpectra('stockmanEnergy',wave);


% foveatritan = stockman*L
L = stockman\fovea;

est = stockman*L;

%%
ieNewGraphWin;
plot(wave,ieScale(foveatritan,1),'rs-',...
    wave,ieScale(est,1),'k-', ...
    obsAverage.wave,ieScale(obsAverage.CMF,1),'bx-');
grid on; xlabel('Wavelength (nm)');
legend('foveal tritan','','stockman fit to fovea','','tritan average','')
