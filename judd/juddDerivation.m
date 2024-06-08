%% Can we use the Judd dichromatic CMFs and Wright Tritan to derive?
%

thisW = 420:5:650;
fname = fullfile(iefundamentalsRootPath,'judd','juddWWK.mat');
load(fname,'wave','WWK');

fname = fullfile(iefundamentalsRootPath,'data','wdw','cmfTritan.mat');
load(fname,'obsAverage');

% Judd's estimates of protan and deutan
cmfProtan = interp1(wave,WWK(:,[1,3]),thisW,'pchip','extrap');
cmfDeutan = interp1(wave,WWK(:,[2,3]),thisW,'pchip','extrap');
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,thisW,'pchip','extrap');


ieNewGraphWin([],'wide');
tiledlayout(1,3);

nexttile
plot(thisW,cmfProtan);
xlabel('Wavelength (nm)')
nexttile
plot(thisW,cmfDeutan);
xlabel('Wavelength (nm)')

nexttile
plot(thisW,cmfTritan);
xlabel('Wavelength (nm)')

%%  Write a function that takes in 2 dichromats and returns the intersection

coneL = conefundamental(cmfDeutan,cmfTritan);
coneM = conefundamental(cmfProtan,cmfTritan);
coneS = conefundamental(cmfProtan,cmfDeutan);

% function coneF = conefundamental(cmfProtan,cmfTritan)
% %
% 
% %
% 
% end