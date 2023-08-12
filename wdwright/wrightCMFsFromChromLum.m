% Wright's CMFs come from measurements of photopic luminance
% and match chromaticities.  In addition, the relative contributions
% of R and G primaries to luminance are given
%
% Some comments from the Wright article to remember: 
% 
% "no color receptor is required at the short-wave end of the spectrum
% to explain tritanopic color vision, apart from a renewed activity of
% the red receptors below 0.43μ which, as will be seen below, is
% indicated by the color matching data."

%% Initializing
ieInit;

%% Load data typed in from Wright, 1952
%
% These were assembled and stored in wdwtritanopes.m
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

        % Adjusted for the correct value from the table.  I should fix
        % the mat file.
        % VrOverVg = theWrightData.obsAverage.VrOverVg;
        VrOverVg = 1.278;   
    case 'F'
        ii = 6;
        wave = theWrightData.obs{ii}.wave;
        RG = theWrightData.obs{ii}.CMF;
        rg = theWrightData.obs{ii}.rg;
        Vlambda = theWrightData.obs{ii}.Vlambda;
        VrOverVg = theWrightData.obs{ii}.VrOverVg;   % Observer specific
    otherwise
        error('Need to add case for requested observer');
end

%{
% These values are not quite right.  So we really don't understand 
% the rg to RG relationship.  Wright describes the rg values this way
%
% "the dichromatic coefficients rλ and gλ which give the proportions
% of the matching stimuli required to match the colors through the
% spectrum (these coefficients correspond to the chromaticity
% coordinates of the spectral colors in normal trichromatic vision)"

%
idx580 = find(wave == 580);
idx480 = find(wave == 480);
idx650 = find(wave == 650);

% But they do not match.
correct = eye(2,2); % diag([RG(idx650,1),RG(idx480,2)]);
sumRG = sum(RG*correct,2);
derivedrg = [RG(:,1)./sumRG, RG(:,2)./sumRG] * correct;
plot(derivedrg(:),rg(:),'.');
identityLine; grid on;

% Also, notice that the chromaticity curve is a waste of time
ieNewGraphWin;
plot(rg(:,1),1-rg(:,2),'o');
identityLine; grid on;

% Here is a weird thing.  Wright says 
% 
% "The radiations 0.65μ and 0.48μ
% were chosen as the matching stimuli and their units were adjusted to
% be equal in the match on a monochromatic yellow at wavelength
% 0.5825μ." 
% 
% But the intensities of the R and G primaries at 580 nm for the mean
% subject are not equal.  For the mean they are 47.36 anmd 41.77,
% which is 1.1338 ratio.  This is not precisely the Vr/Vg ratio,
% either, which is 1.278.  There is a similar deviation in almost all
% of the tables.
%}
%{
RG(idx580,1)./RG(idx580,2)
VrOverVg

% This curve matches Figure 10 pretty well.  Notice the slightly
% negative values.
ieNewGraphWin;
plot(wave,Vlambda,'k-',wave,RG(:,1),'k--',wave,RG(:,2),'k:');
grid on;
legend({'V_{\lambda}','V_R','V_G'});
%}
%{
%
% Perhaps there is a difference between 580 and 582?
%
%}
%% Wright wavelength assumptions

wlR = 650;  % These are the primaries for the tritanope matches
wlG = 480;

% The primaries were treated as intensity equal at this wavelength. We
% fear this was done inconsistently.  Not sure yet.
normWlNominal = 582.5;   

% This is a check on values provided by Wright.
wlRIndex = find(wave == wlR);
wlGIndex = find(wave == wlG);
VrOverVgCheck = RG(wlRIndex,1)/RG(wlGIndex,2);
fprintf('\nVr/Vg = %0.3f, checked as %0.3f\n',VrOverVg,VrOverVgCheck);

% The current understanding of Wright's parameters
%
% Vr is the luminance of the red primary, and Vg of the green.
%
% Their chromaticities are 
%
%   r = Vr/(Vr + Vg)
%   g = Vg/(Vr + Vg)
%
% We also believe that Wright uses additivity
%
%   Vlambda = Vr + Vg
%
% We think that Wright related the chromaticities to the intensities
% in the CMFs this way.  But this may not be all.
%
%   R = r * Vlambda
%   G = g * Vlambda
%

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

%%
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