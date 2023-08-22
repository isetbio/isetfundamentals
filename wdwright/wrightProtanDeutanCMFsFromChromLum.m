% Wright protan and deutan CMFs

%% Initializing
ieInit;

% Define wavelengths we'll use
wave = SToWls([400 10 31]);

%% Load data digitized from Wright's book
%
% rWDW
the_rWDWProtanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwChromRedProtan.mat'));
the_rWDWDeutanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwChromRedDeutan.mat'));
rWDW_Protan = interp1(the_rWDWProtanData.wdwProtanChromRed(:,1),the_rWDWProtanData.wdwProtanChromRed(:,2),wave,'spline',NaN);
rWDW_Deutan = interp1(the_rWDWDeutanData.wdwDeutanChromRed(:,1),the_rWDWDeutanData.wdwDeutanChromRed(:,2),wave,'spline',NaN);

% Plot of rWDW data 
rWDWFig = figure;
set(gcf,'Position',[100 100 1200 600]);

subplot(1,3,1); hold on;
plot(the_rWDWProtanData.wdwProtanChromRed(:,1),the_rWDWProtanData.wdwProtanChromRed(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',4);
plot(wave,rWDW_Protan,'r-','LineWidth',2);
title('Protan rWDW');
xlabel('Wavelength (nm)');
ylabel('rWDW');

subplot(1,3,2); hold on;
plot(the_rWDWDeutanData.wdwDeutanChromRed(:,1),the_rWDWDeutanData.wdwDeutanChromRed(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',4);
plot(wave,rWDW_Deutan,'r-','LineWidth',2);
title('Deutan rWDW');
xlabel('Wavelength (nm)');
ylabel('rWDW');

subplot(1,3,3); hold on;
plot(wave,rWDW_Protan,'r-','LineWidth',2);
plot(wave,rWDW_Deutan,'g-','LineWidth',2);
title('Protan and Deutan rWDW');
xlabel('Wavelength (nm)');
ylabel('rWDW');
legend({'Protan' 'Deutan'},'Location','SouthEast');

%% Normalization info
Vr_Protan = 100;
Vb_Protan = 7.1;
VbOverVr_Protan = Vb_Protan/(Vr_Protan);
Vr_Deutan = 100;
Vb_Deutan = 6.2;
VbOverVr_Deutan = Vb_Deutan/(Vr_Deutan);

% Luminance
the_VlambdaProtanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwVlambda_Protan.mat'));
the_VlambdaDeutanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwVlambda_Deutan.mat'));
Vlambda_Protan = interp1(the_VlambdaProtanData.Wright_Protan_Vlambda(:,1),the_VlambdaProtanData.Wright_Protan_Vlambda(:,2),wave,'spline',NaN);
Vlambda_Deutan = interp1(the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,1),the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,2),wave,'spline',NaN);

% Plot of Vlambda data
lumFig = figure;
set(gcf,'Position',[100 100 1200 600]);
subplot(1,3,1); hold on;
plot(the_VlambdaProtanData.Wright_Protan_Vlambda(:,1),the_VlambdaProtanData.Wright_Protan_Vlambda(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',4);
plot(wave,Vlambda_Protan,'r-','LineWidth',2);
plot(wave,1*ones(size(wave)),'k:','LineWidth',1);
title('Protan Vlambda');
xlabel('Wavelength (nm)');
ylabel('Vlambda');

subplot(1,3,2); hold on;
plot(the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,1),the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',4);
plot(wave,Vlambda_Deutan,'r-','LineWidth',2);
plot(wave,1*ones(size(wave)),'k:','LineWidth',1);
title('Deutan Vlambda');
xlabel('Wavelength (nm)');
ylabel('Vlambda');

subplot(1,3,3); hold on;
plot(wave,Vlambda_Protan,'r-','LineWidth',2);
plot(wave,Vlambda_Deutan,'g-','LineWidth',2);
plot(wave,1*ones(size(wave)),'k:','LineWidth',1);
title('Protan and Deutan Vlambda');
ylim([0 1.2]);
xlabel('Wavelength (nm)');
ylabel('Vlambda');
legend({'Protan' 'Deutan'},'Location','SouthEast');

%% Wright primary wavelengths
%
% These are the primaries for the tritanope matches
RPrimaryWl = 650;
BPrimaryWl = 460;
RPrimaryWlIndex = find(wave == RPrimaryWl);
BPrimaryWlIndex = find(wave == BPrimaryWl);
wdwNormWl = 494;

%% Find R and B from rWDW, and Vlambda
%
% The search method was in intermediate step.  I will
% delete once my understanding of all this is a little
% better, or improve if that is what is needed.
flipNorm = false;
knownWDWScaleFactor = true;
if knownWDWScaleFactor
    W1_Protan = 1/VbOverVr_Protan;
    [R_Protan_Derived,B_Protan_Derived] = WDWChromVlambdaToCMFFun(W1_Protan,wave,rWDW_Protan,Vlambda_Protan,flipNorm);  
end
VlambdaFromRplusB_Protan_Derived = R_Protan_Derived + B_Protan_Derived;
if knownWDWScaleFactor
    W1_Deutan = 1/VbOverVr_Deutan;
    [R_Deutan_Derived,B_Deutan_Derived] = WDWChromVlambdaToCMFFun(W1_Deutan,wave,rWDW_Deutan,Vlambda_Deutan,flipNorm);  
end
VlambdaFromRplusB_Deutan_Derived = R_Deutan_Derived + B_Deutan_Derived;

% Load in tabulated CMFs that were digitized from plots.
theR_Protan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','ProtanCMFRed.mat'));
R_Protan_Tabulated = interp1(theR_Protan_Data.ProtanCMFRed(:,1),theR_Protan_Data.ProtanCMFRed(:,2),wave,'spline',NaN);
theB_Protan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','ProtanCMFBluex5.mat'));
B_Protan_Tabulated = interp1(theB_Protan_Data.ProtanCMFBluex5(:,1),theB_Protan_Data.ProtanCMFBluex5(:,2),wave,'spline',NaN)/5;
VlambdaFromRplusB_Protan_Tabulated = R_Protan_Tabulated + B_Protan_Tabulated;

theR_Deutan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','DeutanCMFRed.mat'));
R_Deutan_Tabulated = interp1(theR_Deutan_Data.DeutanCMFRed(:,1),theR_Deutan_Data.DeutanCMFRed(:,2),wave,'spline',NaN);
theB_Deutan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','DeutanCMFBluex5.mat'));
B_Deutan_Tabulated = interp1(theB_Deutan_Data.DeutanCMFBluex5(:,1),theB_Deutan_Data.DeutanCMFBluex5(:,2),wave,'spline',NaN)/5;
VlambdaFromRplusB_Deutan_Tabulated = R_Deutan_Tabulated + B_Deutan_Tabulated;

%% Get Vlambda as sum of R + B and add to plot as a check
figure(lumFig);
subplot(1,3,1);
plot(wave,VlambdaFromRplusB_Protan_Derived,'k-','LineWidth',2);
plot(wave,VlambdaFromRplusB_Protan_Tabulated,'k:','LineWidth',2);
ylim([0 1.2]);
xlabel('Wavelength (nm)');
ylabel('Luminance');
subplot(1,3,2);
plot(wave,VlambdaFromRplusB_Deutan_Derived,'k-','LineWidth',2);
plot(wave,VlambdaFromRplusB_Deutan_Tabulated,'k:','LineWidth',2);
ylim([0 1.2]);
xlabel('Wavelength (nm)');
ylabel('Luminance');

%% Load Stockman-Sharpe cones and fit CMFs with them
theCones = load('T_cones_ss2.mat');
T_cones = SplineCmf(theCones.S_cones_ss2,theCones.T_cones_ss2,wave);

index = ~isnan(R_Protan_Derived);
waveFitProtan = wave(index);
R_Protan_Derived_Fit = (T_cones(:,index)'*(T_cones(:,index)'\R_Protan_Derived(index)))';
B_Protan_Derived_Fit = (T_cones(:,index)'*(T_cones(:,index)'\B_Protan_Derived(index)))';

index = ~isnan(R_Deutan_Derived);
waveFitDeutan = wave(index);
R_Deutan_Derived_Fit = (T_cones(:,index)'*(T_cones(:,index)'\R_Deutan_Derived(index)))';
B_Deutan_Derived_Fit = (T_cones(:,index)'*(T_cones(:,index)'\B_Deutan_Derived(index)))';

%% Plot derived CMFs
cmfFig = figure;
set(gcf,'Position',[100 100 1200 600]);

subplot(1,3,1); hold on;
plot(wave,R_Protan_Derived,'r-','LineWidth',5);
plot(waveFitProtan,R_Protan_Derived_Fit,'y-','LineWidth',3);
plot(wave,R_Protan_Tabulated,'k-','LineWidth',1);
plot(wave,5*B_Protan_Derived,'b-','LineWidth',5);
plot(waveFitProtan,5*B_Protan_Derived_Fit,'y-','LineWidth',3);
plot(wave,5*B_Protan_Tabulated,'k-','LineWidth',1);
xlabel('Wavelength (nm)');
ylabel('CMF');
title('Protan CMFs');
subplot(1,3,2); hold on;
plot(wave,R_Deutan_Derived,'r-','LineWidth',5);
plot(waveFitDeutan,R_Deutan_Derived_Fit,'y-','LineWidth',3);
plot(wave,R_Deutan_Tabulated,'k-','LineWidth',1);
plot(wave,5*B_Deutan_Derived,'b-','LineWidth',5);
plot(waveFitDeutan,5*B_Deutan_Derived_Fit,'y-','LineWidth',3);
plot(wave,5*B_Deutan_Tabulated,'k-','LineWidth',1);
xlabel('Wavelength (nm)');
ylabel('CMF');
title('Deutan CMFs');

save(fullfile(iefundamentalsRootPath,'wdwright','Wright_ProtanDeutanDerivedCMFs'), ...
    'wave', ...
    'R_Protan_Derived','B_Protan_Derived','R_Deutan_Derived','B_Deutan_Derived', ...
    'R_Protan_Tabulated','B_Protan_Tabulated','R_Deutan_Tabulated','B_Deutan_Tabulated');

    

function [R,B] = WDWChromVlambdaToCMFFun(W1,wls,rWDW,Vlambda,flipNorm)
% Given W1, find R and B from rWDW and Vlambda.
%
% Input W1 is the scalar used to normalize R into line with B for the WDW
% coordinates, via RWDW = R/W1.
%
% Inputs wls, rWDW and Vlambda should be column vectors, with the latter
% two providing the values at the wavelengths in the former.
%
% We know:
%   R_WDW = (R/W1)
%   B_WDW = B
%   R + B = Vlamda
%   r_WDW = R_WDW/(R_WDW + B_WDW) = (R/W1)/(R/W1 + B) = (R/W1)/(R/W1 + Vlambda - R)
%
% At each wavelength, solve for R given r_WDW, Vlamda, and W1. 
%
% If either rWDW or Vlambda is NaN at a wavelength, NaN is returned for
% that wavelength.

% Use fsolve to find R and G at each wavelength, given W1, r_WDW and
% Vlambda at each wavelength.close all
options = optimoptions('fsolve','Display','none');
if (~flipNorm)
    for ww = 1:length(wls)
        if (~isnan(rWDW(ww)) & ~isnan(Vlambda(ww)))
            R(ww) = fsolve(@(Rdummy)(rWDW(ww)-(Rdummy/W1)/(Rdummy/W1 + Vlambda(ww) - Rdummy)),Vlambda(ww)/2,options);
        else
            R(ww) = NaN;
        end
    end
    R = R';
    B = Vlambda - R;
else
    for ww = 1:length(wls)
        if (~isnan(rWDW(ww)) & ~isnan(Vlambda(ww)))
            B(ww) = fsolve(@(Bdummy)((1-rWDW(ww))-(Bdummy*W1)/(Bdummy*W1 + Vlambda(ww) - Bdummy)),Vlambda(ww)/2,options);
        else
            B(ww) = NaN;
        end
    end
    B = B';
    R = Vlambda - B;
end

end