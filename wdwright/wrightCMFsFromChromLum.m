% Wright's CMFs come from measurements of photopic luminance
% and match chromaticities.  In addition, the relative contributions
% of R and G primaries to luminance are given

%% Initializing
ieInit;

%% Load data typed in from Wright, 1952
fname = fullfile(iefundamentalsRootPath,'wdwright','wdwTritanopes.mat');
theWrightData = load(fname,'obs','obsAverage');

% Extract fields
observer = 'avg';
switch (observer)
    case 'avg'
        wave = theWrightData.obsAverage.wave;
        RG = theWrightData.obsAverage.CMF;
        rg = theWrightData.obsAverage.rg;
        Vlambda = theWrightData.obsAverage.Vlambda;
        VrOverVg = theWrightData.obsAverage.VrOverVg;
    case 'F'
        ii = 6;
        wave = theWrightData.obs{ii}.wave;
        RG = theWrightData.obs{ii}.CMF;
        rg = theWrightData.obs{ii}.rg;
        Vlambda = theWrightData.obs{ii}.Vlambda;
        VrOverVg = theWrightData.obs{ii}.VrOverVg;
    otherwise
        error('Need to add case for requested observer');
end

% Wright wavelength data
wlR = 650;
wlG = 480;
normWlNominal = 582.5;
wlRIndex = find(wave == wlR);
wlGIndex = find(wave == wlG);
VrOverVgCheck = RG(wlRIndex,1)/RG(wlGIndex,2);
fprintf('\nVr/Vg = %0.3f, checked as %0.3f\n',VrOverVg,VrOverVgCheck);

% The chromaticities are 
%   r = Vr/(Vr + Vg)
%   g = Vg/(Vr + Vg)
% We also beleive
%   Vlambda = Vr + Vg
% This should give
%   Vr = r * Vlambda
%   Vg = g * Vlambda

% Check that Vlambda is as we think from what's given in the paper.
% This agrees with Wright's tabulated values.
derivedVlambda = RG(:,1) + RG(:,2);

% Derive Vr and Vg from Vlambda and chromaticities.
% These have the right shape, but are not scaled
% to each other the way Wright scaled them.  So they
% are in different units than he used.
derivedRRaw = rg(:,1).*Vlambda;
derivedGRaw = rg(:,2).*Vlambda;

% Check that r + g == 1
rgCheck = rg(:,1) + rg(:,2);
fprintf('\nMax abs deviation of r+g from 1: %0.2g\n',max(abs(rgCheck-1)));

% From Wright's paper, we learn that the R and G CMFs should be scaled
% to have the same value at the normalizing wavelength of 582.5, and also
% sum to luminance.  We can choose scaling that satisfies these properties
% exactly at one wavelength.  The code below sets up the 2 by 2 system of
% linear equations to do this, and this works as desired.
interpMethod = 'cubic';
dervivedRRawNormWlNominal = interp1(wave,derivedRRaw,normWlNominal,interpMethod);
dervivedGRawNormWlNominal = interp1(wave,derivedGRaw,normWlNominal,interpMethod);
rhs = [dervivedRRawNormWlNominal + dervivedGRawNormWlNominal ; 0];
M = [dervivedRRawNormWlNominal dervivedGRawNormWlNominal ; dervivedRRawNormWlNominal -dervivedGRawNormWlNominal];
factors = M\rhs;
derivedRNominal = factors(1)*derivedRRaw;
derivedGNominal = factors(2)*derivedGRaw;
derivedVlambdaCheckNominal = derivedRNominal + derivedGNominal;

% Check that derivedR == derivedG at specified normWl,
% and compare with Wright's tabulated rg and RG
% values. 
% 
% This reveals that our method does produce the desired
% normalization, and that Wright's tables do not have
% this property at the wavelength he gives.
rNormWlNominal = interp1(wave,rg(:,1),normWlNominal,interpMethod);
gNormWlNominal = interp1(wave,rg(:,2),normWlNominal,interpMethod);
RNormWlNominal = interp1(wave,RG(:,1),normWlNominal,interpMethod);
GNormWlNominal = interp1(wave,RG(:,2),normWlNominal,interpMethod);
derivedRNormWlNominal = interp1(wave,derivedRNominal,normWlNominal,interpMethod);
derivedGNormWlNominal = interp1(wave,derivedGNominal,normWlNominal,interpMethod);
fprintf('\nTabulated r at %0.1f: %0.3f; g at %0.1f: %0.3f\n',normWlNominal,rNormWlNominal,normWlNominal,gNormWlNominal);
fprintf('Tabulated R at %0.1f: %0.3f; G at %0.1f: %0.3f\n',normWlNominal,RNormWlNominal,normWlNominal,GNormWlNominal);
fprintf('Derived R at %0.1f: %0.3f; G at %0.1f: %0.3f\n',normWlNominal,derivedRNormWlNominal,normWlNominal,derivedGNormWlNominal);

% Give that Wright's tables don't yield equal rg values at the
% specified normalizing wavelength, we can instead find the
% wavelength where this holds.  
normWlCandidates = linspace(580,590,1000);
rInterp = interp1(wave,rg(:,1),normWlCandidates);
gInterp = interp1(wave,rg(:,2),normWlCandidates);
[~,index] = min(abs(rInterp-gInterp));
normWl = normWlCandidates(index);

% Then repeat derivation 
dervivedRRawNormWl = interp1(wave,derivedRRaw,normWl,interpMethod);
dervivedGRawNormWl = interp1(wave,derivedGRaw,normWl,interpMethod);
rhs = [dervivedRRawNormWl + dervivedGRawNormWl ; 0];
M = [dervivedRRawNormWl dervivedGRawNormWl ; dervivedRRawNormWl -dervivedGRawNormWl];
factors = M\rhs;
derivedR = factors(1)*derivedRRaw;
derivedG = factors(2)*derivedGRaw;
derivedVlambdaCheck = derivedR + derivedG;

rNormWl = interp1(wave,rg(:,1),normWl,interpMethod);
gNormWl = interp1(wave,rg(:,2),normWl,interpMethod);
RNormWl = interp1(wave,RG(:,1),normWl,interpMethod);
GNormWl = interp1(wave,RG(:,2),normWl,interpMethod);
derivedRNormWl = interp1(wave,derivedR,normWl,interpMethod);
derivedGNormWl = interp1(wave,derivedG,normWl,interpMethod);
fprintf('\nTabulated r at %0.1f: %0.3f; g at %0.1f: %0.3f\n',normWl,rNormWl,normWl,gNormWl);
fprintf('Tabulated R at %0.1f: %0.3f; G at %0.1f: %0.3f\n',normWl,RNormWl,normWl,GNormWl);
fprintf('Derived R at %0.1f: %0.3f; G at %0.1f: %0.3f\n',normWl,derivedRNormWl,normWl,derivedGNormWl);

% Plot to check that it works as set up.
ieNewGraphWin; 
subplot(1,3,1); hold on
plot(wave,Vlambda,'r-','LineWidth',5);
plot(wave,derivedVlambda,'b-','LineWidth',3);
plot(wave,derivedVlambdaCheck,'y:','LineWidth',2);
set(gca,'FontName','Helvetica','FontSize',16);
xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
title('Derived and Tabulated Wright Lums','FontName','Helvetica','FontSize',18);
legend({'Tabulated CMFs', 'Derived Lum 1', 'Derived Lum 2'},'FontName','Helvetica','FontSize',14);
grid on;

subplot(1,3,2); hold on;
plot(wave,RG(:,1),'r-','LineWidth',5);
plot(wave,derivedR,'b-','LineWidth',3);
plot(wave,RG(:,2),'r-','LineWidth',5);
plot(wave,derivedG,'b-','LineWidth',3);
set(gca,'FontName','Helvetica','FontSize',16);
xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
title('Derived and Tabulated Wright CMFs','FontName','Helvetica','FontSize',18);
legend({'Tabulated CMFs', 'Derived CMFs'},'FontName','Helvetica','FontSize',14);
grid on;

subplot(1,3,3); hold on;
plot(wave,rg(:,1),'r-','LineWidth',5);
plot(wave,derivedR./(derivedR + derivedG),'b-','LineWidth',3);
plot(wave,rg(:,2),'r-','LineWidth',5);
plot(wave,derivedG./(derivedR + derivedG),'b-','LineWidth',3);
set(gca,'FontName','Helvetica','FontSize',16);
xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
title('Derived and Tabulated Wright rg','FontName','Helvetica','FontSize',18);
legend({'Tabulated rg', 'Derived rg'},'FontName','Helvetica','FontSize',14);
grid on;