%% Estimate fundamentals from WDW data

wave = 400:5:650;

deutanC = ieReadSpectra('wdwDeuteranopesC.mat',wave);
protan = ieReadSpectra('wdwProtanopes.mat',wave);
load('wdwTritanopes','obsAverage');
tritan = interp1(obsAverage.wave,obsAverage.CMF,wave,'pchip','extrap');

protan  = ieScale(protan,1);
deutanC = ieScale(deutanC,1);
tritan  = ieScale(tritan,1);

stockman = ieReadSpectra('stockmanEnergy',wave);

%%
LdeutanC = stockman\deutanC;
estDeutanC = stockman*LdeutanC;

ieNewGraphWin;
plot(wave,estDeutanC,'k-',wave,deutanC,'k.')
title('Stockman to Corrected Deutan');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;

%% Load up the stockman conesd
stockman = ieReadSpectra('stockmanEnergy',wave);
ieNewGraphWin;
plot(wave,stockman);
grid on;
xlabel('Wavelength (nm)');



%% Plot the curves together

% Everything is now within a linear transform
ieNewGraphWin;
plot(wave,deutanC,'g-',wave,protan,'r--',wave,tritan,'b-.');
title('Comparing Protan Deutan and Tritan CMFs');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;
legend('deutan','','protan','','tritan','');

%% Run the null space calculation

ieNewGraphWin([],'tall');
tiledlayout(3,1);

% L cone
[U,S,V] = svd([deutanC,tritan],'econ');
x = V(:,4)
nexttile;
Lest = ieScale(deutanC*x(1:2),1);
plot(wave,Lest,'r-',wave,stockman(:,1),'r:','LineWidth',2);

grid on;
xlabel('Wavelength (nm)');
title('Tritan and DeutanC')
legend('Estimate','Stockman');

% M cone
[U,S,V] = svd([protan,tritan],'econ');
x = V(:,4)
nexttile;
Mest = ieScale(protan*x(1:2),1);
plot(wave, Mest,'g-',wave,stockman(:,2),'g:','LineWidth',2);
Mest = ieScale(tritan*x(3:4),1);
%plot(wave, Mest,'g-',wave,stockman(:,2),'g:','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');
title('Tritan and Protan')
legend('Estimate','Stockman');

% S cone
[U,S,V] = svd([deutanC,protan],'econ');
x = V(:,4)
Sest = ieScale(-deutanC*x(1:2),1);
nexttile;
plot(wave,Sest,'b-',wave,stockman(:,3),'b:','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');
title('DeutanC and Protan')
legend('Estimate','Stockman');
