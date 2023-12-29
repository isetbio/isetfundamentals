%% s_cfDerivation
%
% This replaces the wdwEstimates function.  It is simpler for the Wright.
%
% Using the conefundamentals function in this script makes it easier to
% understand.
%
% The corrected Wright Deutan data does reasonably.  
% 
% A commented out part compares with the Judd summary of WDW, which fairs
% badly. 
%
% See also
%   wdwEstimates

%% Load the corrected WD Wright data

% We use the corrected Deutan data for this plot.

thisW = 410:650;
load('cmfDeutanC.mat','wave','cmfDeutanC');
cmfDeutan = interp1(wave,cmfDeutanC,thisW');

load('cmfProtan.mat','wave','cmfProtan');
cmfProtan = interp1(wave,cmfProtan,thisW);

load('cmfTritan.mat','obsAverage');
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,thisW);

% These are the modern cone fundamentals.  We compare with them.
stockman = ieReadSpectra('stockmanEnergy.mat',thisW);



%% plot first/best fit

ieNewGraphWin([],'wide');
x = getlastVfromSVD([cmfDeutan -cmfTritan]);
nexttile;
Lest = ieScale(abs(cmfDeutan*x(1:2)),1);
plot(thisW,Lest,'r-','LineWidth',2); hold on;

% Lest = ieScale(abs(cmfTritan*x(3:4)),1);
% plot(thisW,Lest,'r--','LineWidth',2); hold on;

plot(thisW,stockman(:,1),'k.','LineWidth',2);
grid on; set(gca,'ylim',[1e-2 1])

x = getlastVfromSVD([cmfProtan -cmfTritan]);
nexttile;
Mest = ieScale(abs(cmfProtan*x(1:2)),1);
plot(thisW,Mest,'g-','LineWidth',2); hold on;

% Mest = ieScale(abs(cmfTritan*x(3:4)),1);
% plot(thisW,Mest,'g--','LineWidth',2); hold on;

plot(thisW,stockman(:,2),'k.','LineWidth',2);
grid on; set(gca,'ylim',[1e-2 1])

x = getlastVfromSVD([cmfProtan -cmfDeutan]);
nexttile;
Sest = ieScale(abs(cmfProtan*x(1:2)),1);
plot(thisW,Sest,'b-','LineWidth',2); hold on;

% Sest = ieScale(abs(cmfDeutan*x(3:4)),1); hold on;
% plot(thisW,Sest,'b--','LineWidth',2); hold on;

plot(thisW,stockman(:,3),'k.','LineWidth',2);
grid on; set(gca,'ylim',[1e-2 1])

%% Make the Stockman log10 difference plots

crit = log10(0.1);   % Stockman ration from peak (1)

ieNewGraphWin([],'wide');
tiledlayout(1,3);

nexttile
Lcone = max(Lest,0);  % No negative values
idx = log10(stockman(:,1)) > crit;  % Only plot down to 1 percent
plot(wave(idx),log10(Lcone(idx)) - log10(stockman(idx,1)),'ro','LineWidth',2);
grid on; set(gca,'ylim',[-0.3 0.2],'xlim',[400 700],'ytick',[-0.3:0.1:0.2],'xtick',[400:50:700]);
xaxisLine;

nexttile
Mcone = max(Mest,0);
idx = log10(stockman(:,2)) > crit;
plot(wave(idx),log10(Mcone(idx)) - log10(stockman(idx,2)),'go','LineWidth',2);
grid on; set(gca,'ylim',[-0.3 0.2],'xlim',[400 700],'ytick',[-0.3:0.1:0.2],'xtick',[400:50:700]);
xaxisLine;

nexttile
Scone = max(Sest,0);
idx = log10(stockman(:,3)) > crit;
plot(wave(idx),log10(Scone(idx)) - log10(stockman(idx,3)),'bo','LineWidth',2);
grid on; set(gca,'ylim',[-0.3 0.2],'xlim',[400 700],'ytick',[-0.3:0.1:0.2],'xtick',[400:50:700]);
xaxisLine;

%% The WD Wright starting point with the corrected Deutan

% Close, but misses the M cones by a fair amount

method = 'nullnull';
% method = 'two';

ieNewGraphWin([],'wide'); 
nexttile
Lcone = conefundamental(cmfDeutan,cmfTritan,'method',method);
semilogy(thisW,Lcone,'r-',thisW,stockman(:,1),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('L-cone (Deutan-Tritan)');
grid on; set(gca,'ylim',[1e-2 1])

nexttile
Mcone = conefundamental(cmfProtan,cmfTritan,'method',method);
semilogy(thisW,Mcone,'g-',thisW,stockman(:,2),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('M-cone (Protan-Tritan)');
grid on; set(gca,'ylim',[1e-2 1])

nexttile
Scone = conefundamental(cmfProtan,cmfDeutan,'method',method);
semilogy(thisW,Scone,'b-',thisW,stockman(:,3),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
title('S-cone (Protan-Deutan)');
grid on; set(gca,'ylim',[1e-2 1])


%% semilogy both

%[U,S,V] = svd([cmfProtan,cmfDeutan],'econ');
% x = V(:,4);
% s = diag(S); fprintf('L cone solution ratio: %f\n',s(1)/s(4));

ieNewGraphWin([],'wide');
x = getlastVfromSVD([cmfDeutan -cmfTritan]);
nexttile;
Lest = ieScale(abs(cmfDeutan*x(1:2)),1);
semilogy(thisW,Lest,'r-','LineWidth',2); hold on;

Lest = ieScale(abs(cmfTritan*x(3:4)),1);
semilogy(thisW,Lest,'r--','LineWidth',2); hold on;

semilogy(thisW,stockman(:,1),'k.','LineWidth',2);
grid on; set(gca,'ylim',[1e-2 1])

x = getlastVfromSVD([cmfProtan -cmfTritan]);
nexttile;
Mest = ieScale(abs(cmfProtan*x(1:2)),1);
semilogy(thisW,Mest,'g-','LineWidth',2); hold on;

Mest = ieScale(abs(cmfTritan*x(3:4)),1);
semilogy(thisW,Mest,'g--','LineWidth',2); hold on;

semilogy(thisW,stockman(:,2),'k.','LineWidth',2);
grid on; set(gca,'ylim',[1e-2 1])

x = getlastVfromSVD([cmfProtan -cmfDeutan]);
nexttile;
Sest = ieScale(abs(cmfProtan*x(1:2)),1);
semilogy(thisW,Sest,'b-','LineWidth',2); hold on;

Sest = ieScale(abs(cmfDeutan*x(3:4)),1); hold on;
semilogy(thisW,Sest,'b--','LineWidth',2); hold on;

semilogy(thisW,stockman(:,3),'k.','LineWidth',2);
grid on; set(gca,'ylim',[1e-2 1])

%% This uses the Judd WWK summary of the WD Wright data
%{
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
%}
%%