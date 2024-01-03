%% s_compareOptimization
%
% Compares the estimated cone fundamentals using different methods:
% direct solvers and optimizers.
%
%%
clear; close all;

%% Load the corrected WD Wright data
%
%  
thisW = 410:650;
load('cmfDeutanC.mat','wave','cmfDeutanC');
cmfDeutan = interp1(wave,cmfDeutanC,thisW');

load('cmfProtan.mat','wave','cmfProtan');
cmfProtan = interp1(wave,cmfProtan,thisW);

load('cmfTritan.mat','obsAverage');
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,thisW);

% These are the modern cone fundamentals.  We compare with them.
stockman = ieReadSpectra('stockmanEnergy.mat',thisW);



%%

figure;hold on;
tiledlayout(2,3);
sgtitle("Nonnegativity constraint vs Null space method")
nexttile; hold on
estimates=estimatorOptNonnegative(cmfDeutan,cmfTritan)
maxnorm = @(x)x./max(x);
plot(maxnorm(estimates(:,1)),'r')
plot(maxnorm(estimates(:,2)),'b')
plot(maxnorm(stockman(:,1)),'k--')
ylim([0 1])
title("L")
legend("Optimizer sol. 1","Optimizer sol. 2","Stockman")

nexttile; hold on
estimates=estimatorOptNonnegative(cmfTritan,cmfProtan)
maxnorm = @(x)x./max(x);
plot(maxnorm(estimates(:,1)),'r')
plot(maxnorm(estimates(:,2)),'b')
plot(maxnorm(stockman(:,2)),'k--')
ylim([0 1])
title("M")
legend("Optimizer sol. 1","Optimizer sol. 2","Stockman")


nexttile; hold on
estimates=estimatorOptNonnegative(cmfDeutan,cmfProtan)
maxnorm = @(x)x./max(x);
plot(maxnorm(estimates(:,1)),'r')
plot(maxnorm(estimates(:,2)),'b')
plot(maxnorm(stockman(:,3)),'k--')
ylim([0 1])
title("S")
legend("Optimizer sol. 1","Optimizer sol. 2","Stockman")


nexttile; hold on
estimates=estimatorIntersect(cmfDeutan,cmfTritan)
maxnorm = @(x)x./max(x);
plot(maxnorm(estimates(:,1)),'r')
plot(maxnorm(estimates(:,2)),'b')
plot(maxnorm(stockman(:,1)),'k--')
ylim([0 1])
legend("Null sol. 1","Null sol. 2","Stockman")

nexttile; hold on
estimates=estimatorIntersect(cmfTritan,cmfProtan)
maxnorm = @(x)x./max(x);
plot(maxnorm(estimates(:,1)),'r')
plot(maxnorm(estimates(:,2)),'b')
plot(maxnorm(stockman(:,2)),'k--')
ylim([0 1])
legend("Null sol. 1","Null sol. 2","Stockman")

nexttile; hold on
estimates=estimatorIntersect(cmfDeutan,cmfProtan)
maxnorm = @(x)x./max(x);
plot(maxnorm(estimates(:,1)),'r')
plot(maxnorm(estimates(:,2)),'b')
plot(maxnorm(stockman(:,3)),'k--')
ylim([0 1])
legend("Null sol. 1","Null sol. 2","Stockman")





