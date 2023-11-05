%% Estimate fundamentals from WDW data
%
% Original, and now scratch or maybe even deprecated.  Replaced by
% s_cfDerivation script.  That one is simpler.  This has various scribbles
% and notes.  It does more explicit comparisons with Deutan and DeutanC
% (corrected).
%
% Both this script and s_cfDerviation now use the conefundamental function
% to calculate the fundamentals from the WDW dichromatic color matching
% data.  The alternative solution method in wdwEstimates_thomas can be
% replaced by specifying different methods in the conefundamental function.
%
% TODO:  Noise.

%%
wave = 400:5:650;
stockman = ieReadSpectra('stockmanEnergy',wave);

%% Read in the WDW data
% {
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
%}
%% Wyszecki and Stiles data

% Needs checking and work.
%{

protan  = ieReadSpectra('wsProtan.mat',wave);
deutan  = ieReadSpectra('wsDeutan.mat',wave);
tritan  = ieReadSpectra('wsTritan.mat',wave);
deutanC  = deutan;
deutanC(:,1) = protan(:,1);

thisDeutan = deutan;

%}


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

%%  Estimated using the nullnull method

ieNewGraphWin([],'wide');
tiledlayout(1,3);

% L cone
nexttile;
Lest = conefundamental(thisDeutan,tritan,'method','nullnull');
Lest = ieScale(Lest,1);
plot(wave,Lest,'r-',wave,stockman(:,1),'kx','LineWidth',2);
grid on;
xlabel('Wavelength (nm)'); ylabel('Normalized sensitivity');
title('L')

% M cone
nexttile;
Mest = conefundamental(protan,tritan);
Mest = ieScale(Mest,1);
plot(wave,Mest,'g-',wave,stockman(:,2),'kx','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');ylabel('Normalized sensitivity');
title('M')

% S cone
nexttile;
Sest = conefundamental(thisDeutan,protan,'method','nullnull');
Sest = ieScale(Sest,1);
plot(wave,Sest,'b-',wave,stockman(:,3),'kx','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');ylabel('Normalized sensitivity');
title('S')

%% Run the null space calculation by hand using the SVD

ieNewGraphWin([],'wide');
tiledlayout(1,3);

% L cone
[U,S,V] = svd([thisDeutan,tritan],'econ');
x = V(:,4);
s = diag(S); fprintf('L cone solution ratio: %f\n',s(1)/s(4));
nexttile;
Lest = ieScale(abs(thisDeutan*x(1:2)),1);
Lave = Lest/2;
plot(wave,Lest,'r:',wave,stockman(:,1),'kx','LineWidth',2);
Lest = ieScale(abs(tritan*x(3:4)),1);
Lave = Lave + Lest/2;
hold on; plot(wave,Lest,'r--','LineWidth',2); % wave,Lave,'kx',
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
plot(wave, Mest,'g:',wave,stockman(:,2),'kx','LineWidth',2);
Mave = Mest/2;
Mest = ieScale(abs(tritan*x(3:4)),1);
Mave = Mave + Mest/2;
hold on; plot(wave, Mest,'g--','LineWidth',2); % wave,Mave,'kx',
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
Save = Sest/2;
plot(wave,Sest,'b:',wave,stockman(:,3),'kx','LineWidth',2);
Sest = ieScale(abs(protan*x(3:4)),1);
Save = Save + Sest/2;
hold on; plot(wave,Sest,'b--','LineWidth',2); % wave,Save,'kx',
grid on;
xlabel('Wavelength (nm)');
title('DeutanC and Protan')
legend('Estimate1','Stockman','Estimate2');

%% END