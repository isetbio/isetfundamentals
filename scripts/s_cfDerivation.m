%% s_cfDerivation
%
% This is conceptually like wdwEstimates.  It is simpler for the
% Wright, and it adds the Judd summary as a starting point.
%
% Using the conefundamentals function makes it easier to understand.
%
% Trying with both the Wright data and with the Judd summary of the
% Wright data.  The corrected Wright data does well.  The Judd WWK
% does not do well.
%
% See also
%

%% WD Wright data

% We use the corrected Deutan data for this plot.

thisW = 410:650;
load('cmfDeutanC.mat','wave','cmfDeutanC');
cmfDeutan = interp1(wave,cmfDeutanC,thisW');

load('cmfProtan.mat','wave','cmfProtan');
cmfProtan = interp1(wave,cmfProtan,thisW);

load('cmfTritan.mat','obsAverage');
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,thisW);

stockman = ieReadSpectra('stockmanEnergy.mat',thisW);

%% The WD Wright starting point with the corrected Deutan

% Close, but misses the M cones by a fair amount

method = 'nullnull';

ieNewGraphWin([],'wide'); 
nexttile
Scone = conefundamental(cmfProtan,cmfDeutan,'method',method);
plot(thisW,Scone,'b-',thisW,stockman(:,3),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('S-cone (Protan-Deutan)');

nexttile
Mcone = conefundamental(cmfProtan,cmfTritan,'method',method);
plot(thisW,Mcone,'g-',thisW,stockman(:,2),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('M-cone (Protan-Tritan)');

nexttile
Lcone = conefundamental(cmfDeutan,cmfTritan,'method',method);
plot(thisW,Lcone,'r-',thisW,stockman(:,1),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('L-cone (Deutan-Tritan)');

title('WDW Data')

%% This uses the Judd WWK summary of the WD Wright data

% Not very good, IMHO
% Very bad for the L cone fundamental

thisW = 410:650;
load('JuddWWK.mat','wave','WWK');
cmfDeutan = interp1(wave,WWK(:,[1,3]),thisW);
cmfProtan = interp1(wave,WWK(:,[2,3]),thisW);
cmfTritan = interp1(wave,WWK(:,[1,2]),thisW);

stockman = ieReadSpectra('stockmanEnergy.mat',thisW);

%% The Judd starting point does not do well

method = 'nullnull';

ieNewGraphWin([],'wide'); 
nexttile
Scone = conefundamental(cmfProtan,cmfDeutan,'method',method);
plot(thisW,Scone,'b-',thisW,stockman(:,3),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('S-cone (Protan-Deutan)');

nexttile
Mcone = conefundamental(cmfProtan,cmfTritan,'method',method);
plot(thisW,Mcone,'g-',thisW,stockman(:,2),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('M-cone (Protan-Tritan)');

nexttile
Lcone = conefundamental(cmfDeutan,cmfTritan,'method',method);
plot(thisW,Lcone,'r-',thisW,stockman(:,1),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('L-cone (Deutan-Tritan)');

%%