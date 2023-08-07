%
%

fname = fullfile(iefundamentalsRootPath,'wdwright','wdwTritanopes.mat');
load(fname,'obs','obsAverage');

wave = 410:10:650;
% stockman = ieReadSpectra('stockmanEnergy',wave);
XYZ = ieReadSpectra('XYZEnergy',wave);

% CMF = Stockman*L;
%
% So, 
%  L = Stockman\CMF;   % L is a 3 x 2
%  EstimatedCMF = Stockman * L

% L = inv(stockman'*stockman)*stockman'*cmf;

cmf = obsAverage.CMF;
% L = stockman\cmf;
L = XYZ\cmf;


% estCMF = stockman*L;
estCMF = XYZ*L;

ieNewGraphWin;
plot(obs{1}.wave,cmf,'k-');
hold on;
plot(obs{1}.wave,estCMF,'r--');
xlabel('Wavelength (nm)');
ylabel('Primary intensity');
title('Observer Average Tritan Fit By CIE')
legend({'Tritan CMFs', 'Fit With XYZ'});
grid on;
