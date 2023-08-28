%% s_cfDerivation
%
% This is conceptually like wdwEstimates.
%
% Using the conefundamentals function.
% Trying with both the Wright data and with the Judd summary of the
% Wright data.
%
% See also
%

%% WD Wright data
thisW = 410:650;
load('cmfDeutanC.mat','wave','cmfDeutanC');
cmfDeutan = interp1(wave,cmfDeutanC,thisW');

load('cmfProtan.mat','wave','cmfProtan');
cmfProtan = interp1(wave,cmfProtan,thisW);

load('cmfTritan.mat','obsAverage');
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,thisW);

stockman = ieReadSpectra('stockmanEnergy.mat',thisW);

%%
ieNewGraphWin([],'wide'); 
nexttile
Scone = conefundamental(cmfProtan,cmfDeutan,'method','nullnull');
plot(thisW,Scone,'b-',thisW,stockman(:,3),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

nexttile
Mcone = conefundamental(cmfProtan,cmfTritan,'method','nullnull');
plot(thisW,Mcone,'g-',thisW,stockman(:,2),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

nexttile
Lcone = conefundamental(cmfDeutan,cmfTritan,'method','nullnull');
plot(thisW,Lcone,'r-',thisW,stockman(:,1),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

%% Now try with the Judd WWK summary of the WD Wright

thisW = 410:650;
load('JuddWWK.mat','wave','WWK');
cmfDeutan = interp1(wave,WWK(:,[1,3]),thisW);
cmfProtan = interp1(wave,WWK(:,[2,3]),thisW);
cmfTritan = interp1(wave,WWK(:,[1,2]),thisW);

stockman = ieReadSpectra('stockmanEnergy.mat',thisW);

%%
ieNewGraphWin([],'wide'); 
nexttile
Scone = conefundamental(cmfProtan,cmfDeutan,'method','nullnull');
plot(thisW,Scone,'b-',thisW,stockman(:,3),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

nexttile
Mcone = conefundamental(cmfProtan,cmfTritan,'method','nullnull');
plot(thisW,Mcone,'g-',thisW,stockman(:,2),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

nexttile
Lcone = conefundamental(cmfDeutan,cmfTritan,'method','nullnull');
plot(thisW,Lcone,'r-',thisW,stockman(:,1),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

