%% Estimate fundamentals from WDW data
clear;
wave = 400:5:650;

deutan = ieReadSpectra('wdwDeuteranopesC.mat',wave);
%deutan = ieReadSpectra('wdwDeuteranopes.mat',wave);
protan = ieReadSpectra('wdwProtanopes.mat',wave);
load('wdwTritanopes','obsAverage');
tritan = interp1(obsAverage.wave,obsAverage.CMF,wave,'pchip','extrap');

protan  = ieScale(protan,1);
deutan = ieScale(deutan,1);
tritan  = ieScale(tritan,1);

stockman = ieReadSpectra('stockmanEnergy',wave);

%%
Ldeutan = stockman\deutan;
estDeutanC = stockman*Ldeutan;

ieNewGraphWin;
plot(wave,estDeutanC,'k-',wave,deutan,'k.')
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
plot(wave,deutan,'g-',wave,protan,'r--',wave,tritan,'b-.');
title('Comparing Protan Deutan and Tritan CMFs');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;
legend('deutan','','protan','','tritan','');

%% Run the null space calculation
Lest = {}
labels_est = {'1','2','nullnull'} %legend label for each estimate 

ieNewGraphWin([],'upperleftbig');
tiledlayout(3,3);
% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')))
% L cone - compare three estimators
%%% Method 1: null[CM1 CM2] - gives two estimates
[U,S,V] = svd([deutan,tritan],'econ');
x = V(:,4);
Lest{1} = ieScale(normalize(deutan*x(1:2)),1);
Lest{2} = ieScale(normalize(tritan*x(3:4)),1);
%%% Method 2: null([null(CM1') null(CM2')]') - gives one estimates
[U,S,V] = svd([null(deutan') , null(tritan')]','econ');
Lest{3} = ieScale(normalize(V(:,end)));

for i=1:3
    nexttile; hold on
    plot(wave,Lest{i},'r',wave,stockman(:,1),'k','LineWidth',2);
    grid on;
    xlabel('Wavelength (nm)');
    title('Tritan and Deutan')
    % Add stockman label only on first column
    if(i==1)
        legend(['Estimate ' labels_est{i}],'Stockman','location','best');
    else
        legend(['Estimate ' labels_est{i}],'location','best');
    end
end


% M cone - compare three estimators
%%% Method 1: null[CM1 CM2] - gives two estimates
[U,S,V] = svd([protan,tritan],'econ');
x = V(:,4);
Lest{1} = ieScale(normalize(protan*x(1:2)),1);
Lest{2} = ieScale(normalize(tritan*x(3:4)),1);
%%% Method 2: null([null(CM1') null(CM2')]') - gives one estimates
[U,S,V] = svd([null(protan') , null(tritan')]','econ');
Lest{3} = ieScale(normalize(V(:,end)));

for i=1:3
    nexttile; hold on
    plot(wave,Lest{i},'g',wave,stockman(:,2),'k','LineWidth',2);
    grid on;
    xlabel('Wavelength (nm)');
    title('Protan and Tritan')
    % Add stockman label only on first column
    if(i==1)
        legend(['Estimate ' labels_est{i}],'Stockman','location','best');
    else
        legend(['Estimate ' labels_est{i}],'location','best');
    end
end



% S cone - compare three estimators
%%% Method 1: null[CM1 CM2] - gives two estimates
[U,S,V] = svd([deutan,protan],'econ');
x = V(:,4);
Lest{1} = ieScale(normalize(deutan*x(1:2)),1);
Lest{2} = ieScale(normalize(protan*x(3:4)),1);
%%% Method 2: null([null(CM1') null(CM2')]') - gives one estimates
[U,S,V] = svd([null(deutan') , null(protan')]','econ');
Lest{3} = ieScale(normalize(V(:,end)));

for i=1:3
    nexttile; hold on
    plot(wave,Lest{i},'b',wave,stockman(:,3),'k','LineWidth',2);
    grid on;
    xlabel('Wavelength (nm)');
    title('Deutan and Protan')
    % Add stockman label only on first column
    if(i==1)
        legend(['Estimate ' labels_est{i}],'Stockman','location','best');
    else
        legend(['Estimate ' labels_est{i}],'location','best');
    end
end


