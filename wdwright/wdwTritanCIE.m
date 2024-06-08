% Fit Wright tritan CMFs with XYZ, Stockman-Sharpe

%% Initializing
ieInit;

%% Load data typed in from Wright, 1952
fname = fullfile(iefundamentalsRootPath,'data','grabit','wdwTritanopes.mat');
theWrightData = load(fname,'obs','obsAverage');

% Get Stockman-Sharpe and XYZ at the requisite wavelengths
wave = theWrightData.obsAverage.wave;
stockman = ieReadSpectra('stockmanEnergy',wave);
XYZ = ieReadSpectra('XYZEnergy',wave);

%% Fit the average
%
% CMF = Stockman*L;
%
% So (e.g.)
%    L = Stockman\CMF;             
%    EstimatedCMF = Stockman * L
% L here is a 3 x 2
%
% Also in more detail through standard regression formulae
%    L = inv(stockman'*stockman)*stockman'*cmf;

% Wright tritan fit with XYZ
wrightTritanCMFs = theWrightData.obsAverage.CMF;
L = XYZ\wrightTritanCMFs;
estCMF = XYZ*L;

ieNewGraphWin; hold on;
plot(wave,wrightTritanCMFs(:,1),'k-','LineWidth',3);
plot(wave,estCMF(:,1),'r--','LineWidth',3);
plot(wave,wrightTritanCMFs(:,2),'k-','LineWidth',3);
plot(wave,estCMF(:,2),'r--','LineWidth',3);

set(gca,'FontName','Helvetica','FontSize',16);
xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
title('Observer Average Tritan Fit By CIE','FontName','Helvetica','FontSize',18);
legend({'Tritan CMFs', 'Fit With XYZ'},'FontName','Helvetica','FontSize',14);
grid on;

%% Wright tritan fit with Stockman-Sharpe
L = stockman\wrightTritanCMFs;
estCMF = stockman*L;

ieNewGraphWin; hold on;
plot(wave,wrightTritanCMFs(:,1),'k-','LineWidth',3);
plot(wave,estCMF(:,1),'r--','LineWidth',3);
plot(wave,wrightTritanCMFs(:,2),'k-','LineWidth',3);
plot(wave,estCMF(:,2),'r--','LineWidth',3);

set(gca,'FontName','Helvetica','FontSize',16);
xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
title('Observer Average Tritan Fit By Stockman-Sharpe','FontName','Helvetica','FontSize',18);
legend({'Tritan CMFs', 'Fit With Stockman-Sharpe'},'FontName','Helvetica','FontSize',14);
grid on;

%%  Now loop through the individuals
ieNewGraphWin([],'big');
tiledlayout(2,3);
for ii=1:numel(obs)
    nexttile;
    if ii == 1, title('Stockman fits to tritanopes'); end

    L = stockman\obs{ii}.CMF;
    estCMF = stockman*L;

    hold on
    plot(wave,obs{ii}.CMF(:,1),'k-','LineWidth',3);
    plot(wave,estCMF(:,1),'r--','LineWidth',3);
    plot(wave,obs{ii}.CMF(:,2),'k-','LineWidth',3);
    plot(wave,estCMF(:,2),'r--','LineWidth',3);

    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
    grid on;
    legend('obs R','est R','obs G','est G');
end

