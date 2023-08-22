%% Estimate fundamentals from WDW data
clear;
wave = 400:5:650;

deutan = ieReadSpectra('wdwDeuteranopes.mat',wave);
%deutan = ieReadSpectra('wdwDeuteranopes.mat',wave);
protan = ieReadSpectra('wdwProtanopes.mat',wave);
load('wdwTritanopes','obsAverage');
tritan = interp1(obsAverage.wave,obsAverage.CMF,wave,'pchip','extrap');

protan  = ieScale(protan,1);
deutan = ieScale(deutan,1);
tritan  = ieScale(tritan,1);

stockman = ieReadSpectra('stockmanEnergy',wave);
    0.6929
    0.0917
   -0.0243
   -0.7148

    -0.9913
   -0.1319
   -0.0266
   -0.9996
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
labels_est = {'1','2','nullnull','nullnullXY'} %legend label for each estimate 

ieNewGraphWin([],'upperleftbig');
tiledlayout(3,4);
% Normalize: Make the sign of the largest element positive.
normalize = @(A) A*sign(A(find(max(abs(A))==abs(A),1,'first')))
% L cone - compare three estimators
estimator1=estimatorIntersect(deutan,tritan)
Lest{1,1} = ieScale(estimator1);

estimator2=estimatorLowrank(deutan,tritan)
Lest{2,1} = ieScale(estimator2);

estimator3=estimatorNullNull(deutan,tritan)
Lest{3,1} = ieScale(estimator3);

estimator4=estimatorNullNullXY(deutan,tritan);
Lest{4,1} = ieScale(estimator4);

for i=1:4
    nexttile; hold on
    plot(wave,Lest{i,1},'r',wave,stockman(:,1),'k','LineWidth',2);
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
estimator1=estimatorIntersect(protan,tritan)
estimator2=estimatorLowrank(protan,tritan)
estimator3=estimatorNullNull(protan,tritan)
Lest{1,2} = ieScale(estimator1);
Lest{2,2} = ieScale(estimator2);
Lest{3,2} = ieScale(estimator3);

estimator4=estimatorNullNullXY(protan,tritan);
Lest{4,2} = ieScale(estimator4);
for i=1:4
    nexttile; hold on
    plot(wave,Lest{i,2},'g',wave,stockman(:,2),'k','LineWidth',2);
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

estimator1=estimatorIntersect(deutan,protan)
estimator2=estimatorLowrank(deutan,protan)
estimator3=estimatorNullNull(deutan,protan)
Lest{1,3} = ieScale(estimator1);
Lest{2,3} = ieScale(estimator2);
Lest{3,3} = ieScale(estimator3);

estimator4=estimatorNullNullXY(deutan,protan);
Lest{4,3} = ieScale(estimator4);

for i=1:4
    nexttile; hold on
    plot(wave,Lest{i,3},'b',wave,stockman(:,3),'k','LineWidth',2);
    if(i==3) ,plot(wave,0.5*sum(Lest{4,3},2)), end
    grid on;
    xlabel('Wavelength (nm)');
    title('Deutan and Protan')
    % Add stockman label only on first column
    if(i==1)
        legend(['Estimate ' labels_est{i}],'Estimate 2','Stockman','location','best');
    else
        legend(['Estimate ' labels_est{i}],'location','best');
    end
end
%{
% L cone
[U,S,V] = svd([null(deutanC') ,null(tritan')]','econ');
% x = V(4,:)';
nexttile;
% Lest = ieScale(tritan*x(1:2),1);
Lest = ieScale(abs(V(:,end)))
plot(wave,Lest,'r-',wave,stockman(:,1),'r:','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');
title('Tritan and DeutanC')
legend('Estimate','Stockman');

% M cone
[U,S,V] = svd([null(protan'),null(tritan')]','econ');
% x = V(4,:)';
nexttile;
% Mest = ieScale(protan*x(1:2),1);
Mest = ieScale(abs(V(:,end)))
plot(wave, Mest,'g-',wave,stockman(:,2),'g:','LineWidth',2);
grid on;
xlabel('Wavelength (nm)');
title('Tritan and Protan')
legend('Estimate','Stockman');

% S cone
[U,S,V] = svd([null(deutanC'),null(protan')]','econ');
%x = V(4,:)';
%Sest = ieScale(deutanC*x(1:2),1);
Sest = ieScale(abs(V(:,end)))
%}


