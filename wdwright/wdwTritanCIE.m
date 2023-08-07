% Fit Wright tritan CMFs with XYZ, Stockman-Sharpe

% Initialize
clear; close all;

% Load data typed in from Wright, 1952
fname = fullfile(iefundamentalsRootPath,'wdwright','wdwTritanopes.mat');
theWrightData = load(fname,'obs','obsAverage');

% Get Stockman-Sharpe and XYZ at the requisite wavelengths
wave = theWrightData.obsAverage.wave;
stockman = ieReadSpectra('stockmanEnergy',wave);
XYZ = ieReadSpectra('XYZEnergy',wave);

% CMF = Stockman*L;
%
% So, 
%  L = Stockman\CMF;   % L is a 3 x 2
%  EstimatedCMF = Stockman * L

% L = inv(stockman'*stockman)*stockman'*cmf;

% Wright tritan fit with XYZ
wrightTritanCMFs = theWrightData.obsAverage.CMF;
L = XYZ\wrightTritanCMFs;
estWrightTriantCMFs = XYZ*L;

ieNewGraphWin; hold on;
set(gca,'FontName','Helvetica','FontSize',16);
plot(wave,wrightTritanCMFs(:,1),'k-','LineWidth',3);
plot(wave,estWrightTriantCMFs(:,1),'r--','LineWidth',3);
plot(wave,wrightTritanCMFs(:,2),'k-','LineWidth',3);
plot(wave,estWrightTriantCMFs(:,2),'r--','LineWidth',3);
xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
title('Observer Average Tritan Fit By CIE','FontName','Helvetica','FontSize',18);
legend({'Tritan CMFs', 'Fit With XYZ'},'FontName','Helvetica','FontSize',14);
grid on;

% Wright tritan fit with Stockman-Sharpe
L = stockman\wrightTritanCMFs;
estWrightTriantCMFs = stockman*L;

ieNewGraphWin; hold on;
set(gca,'FontName','Helvetica','FontSize',16);
plot(wave,wrightTritanCMFs(:,1),'k-','LineWidth',3);
plot(wave,estWrightTriantCMFs(:,1),'r--','LineWidth',3);
plot(wave,wrightTritanCMFs(:,2),'k-','LineWidth',3);
plot(wave,estWrightTriantCMFs(:,2),'r--','LineWidth',3);
xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
title('Observer Average Tritan Fit By Stockman-Sharpe','FontName','Helvetica','FontSize',18);
legend({'Tritan CMFs', 'Fit With Stockman-Sharpe'},'FontName','Helvetica','FontSize',14);
grid on;

