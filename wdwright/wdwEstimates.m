%% Estimate fundamentals from WDW data
%
%
%
% See also
%   wdwEstimates_thomas - for another solution method
%


%% Read in the WDW data
wave = 400:5:650;

deutan  = ieReadSpectra('wdwDeuteranopes.mat',wave);
deutanC = ieReadSpectra('wdwDeuteranopesC.mat',wave);
protan  = ieReadSpectra('wdwProtanopes.mat',wave);

load('wdwTritanopes','obsAverage');
tritan = interp1(obsAverage.wave,obsAverage.CMF,wave,'pchip','extrap');

protan  = ieScale(protan,1);
deutanC = ieScale(deutanC,1);
tritan  = ieScale(tritan,1);
deutanC = ieScale(deutanC,1);

% thisDeutan = deutan;
thisDeutan = deutanC;

%% Read in the Wyszecki and Stiles data

protan  = ieReadSpectra('wsProtan.mat',wave);
deutan  = ieReadSpectra('wsDeutan.mat',wave);
tritan  = ieReadSpectra('wsTritan.mat',wave);
thisDeutan = deutan;

%%s

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
[U,S,V] = svd([thisDeutan,tritan],'econ');
x = V(:,4);
s = diag(S); fprintf('L cone solution ratio: %f\n',s(1)/s(4));
nexttile;
Lest = ieScale(abs(thisDeutan*x(1:2)),1);
plot(wave,Lest,'r:',wave,stockman(:,1),'r-','LineWidth',2);
Lest = ieScale(abs(tritan*x(3:4)),1);
hold on; plot(wave,Lest,'r--','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');
title('Tritan and DeutanC')
legend('Estimate1','Stockman','Estimate2');

% M cone
[U,S,V] = svd([protan,tritan],'econ');
x = V(:,4);
s = diag(S); fprintf('M cone solution ratio: %f\n',s(1)/s(4));
nexttile;
Mest = ieScale(abs(protan*x(1:2)),1);
plot(wave, Mest,'g:',wave,stockman(:,2),'g-','LineWidth',2);
Mest = ieScale(abs(tritan*x(3:4)),1);
hold on; plot(wave, Mest,'g--','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');
title('Tritan and Protan')
legend('Estimate1','Stockman','Estimate2');

% S cone
[U,S,V] = svd([thisDeutan,protan],'econ');
x = V(:,4);
s = diag(S); fprintf('S cone solution ratio: %f\n',s(1)/s(4));
nexttile;
Sest = ieScale(abs(thisDeutan*x(1:2)),1);
plot(wave,Sest,'b:',wave,stockman(:,3),'b-','LineWidth',2);
Sest = ieScale(abs(protan*x(3:4)),1);
hold on; plot(wave,Sest,'b--','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');
title('DeutanC and Protan')
legend('Estimate1','Stockman','Estimate2');
