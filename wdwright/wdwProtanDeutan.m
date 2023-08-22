%% Wright 'spectral coefficients' for deutan and protan subjects
%
% These are from 
%
%    * Figures 200, 208 (CMFs)
%    * Fig 207 (chromaticity), and
%    * Figure 205 (Vlambda) 
%
% in the Color Deficient Observers book by Wright.
%
% Notes
%
%  There are only tiny differences between these two types of
%  dichromats when represented w.r.t. chromaticity.
%
%  For example, in the short-wavelength region, the values are
%  identical. This must be because all that there is down there is the
%  S-cone.  In the long-wavelength region they differ slightly.
%  Because M and L differ slightly.
% 
%  Both types of dichromats are essentially monochromatic above about 600.
%
%  We also have the V_lambda curves for these as well (Figure 205).
%

%%  Grabit data are stored here
chdir(fullfile(iefundamentalsRootPath,'wdwright'));

% We save at this resolution.  We do not have enough tritan data for all
% this, but that's OK.
wave = 400:700;

%% Color Matching Functions: Matches Figure 200
load('ProtanCMFBluex5.mat');
protanBlue = interp1(ProtanCMFBluex5(:,1),ProtanCMFBluex5(:,2),wave,'pchip','extrap');
load('ProtanCMFRed.mat');
protanRed = interp1(ProtanCMFRed(:,1),ProtanCMFRed(:,2),wave,'pchip','extrap');

ieNewGraphWin;
plot(wave,protanBlue,'b-',wave,protanRed,'r-');
grid on;
title("Matches Figure 200")

protanCMF = [protanRed(:), protanBlue(:)];

%% Matches Figure 208
load('DeutanCMFBluex5.mat');
deutanBlue = interp1(DeutanCMFBluex5(:,1),DeutanCMFBluex5(:,2),wave,'pchip','extrap');
load('DeutanCMFRed.mat');
deutanRed = interp1(DeutanCMFRed(:,1),DeutanCMFRed(:,2),wave,'pchip','extrap');
ieNewGraphWin;
plot(wave,deutanBlue,'b-',wave,deutanRed,'r-');
grid on;
title("Matches Figure 208")

deutanCMF = [deutanRed(:), deutanBlue(:)];

%% Now compare with Stockman

stockman = ieReadSpectra('stockmanEnergy',wave);

%% deutan = stockman*L
ieNewGraphWin([],'wide');
tiledlayout(1,2);

% protan = stockman*L
Lprotan = stockman\protanCMF;
estProtan = stockman*Lprotan;
nexttile;
plot(wave,estProtan,'k-',wave,protanCMF,'k.')
title('Stockman to Protan (Fig 200)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;

nexttile;
Ldeutan = stockman\deutanCMF;
estDeutan = stockman*Ldeutan;
plot(wave,estDeutan,'k-',wave,deutanCMF,'k.')
title('Stockman to Deutan (Fig 208)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;

%% Does not normally run.

% The blue curve in the book seems off. We copy the protan blue curve
% into deutan because that one made sense.  We call the corrected
% deutan with the variable deutanC.
deutanC = deutan;
deutanC(:,2) = protan(:,2);

saveFlag = false;
if saveFlag
    ieSaveSpectralFile(wave,deutan,'WDW data from book figures 198-208','wdwDeuteranopes.mat');
    ieSaveSpectralFile(wave,deutanC,'WDW data corrected for blue','wdwDeuteranopesC.mat');
    ieSaveSpectralFile(wave,protan,'WDW data from book figures 198-208','wdwProtanopes.mat');    
end

% Check that we wrote correctly
if saveFlag
    DC = ieReadSpectra('wdwDeuteranopesC.mat',wave);
    D = ieReadSpectra('wdwDeuteranopes.mat',wave);
    P = ieReadSpectra('wdwProtanopes.mat',wave);

    ieNewGraphWin;
    plot(wave,DC,'--',wave,D,':',wave,P,'-.');
end

%% Chromaticities (Figure 207)

load('wdwChromRedProtan.mat');
protanChromRed = interp1(wdwProtanChromRed(:,1),wdwProtanChromRed(:,2),wave,'pchip','extrap');
load('wdwChromRedDeutan.mat');
deutanChromRed = interp1(wdwDeutanChromRed(:,1),wdwDeutanChromRed(:,2),wave,'pchip','extrap');

% Wright calls these spectral coefficient curves
protanChromaticity = [protanChromRed(:),1 - protanChromRed(:)];
deutanChromaticity = [deutanChromRed(:),1 - deutanChromRed(:)];

ieNewGraphWin;
plot(wave,protanChromaticity,'r-',wave,deutanChromaticity,'g--','Linewidth',2);
grid on;
xlabel('Wavelength (nm)'); ylabel('Chromaticity');
legend('Protan','','Deutan','');
title('Spectral coefficients for primaries: 460, 650');

%% Vlambda (Figure 205)

load('wdwVlambda_Protan.mat');
vlambdaProtan = interp1(Wright_Protan_Vlambda(:,1),Wright_Protan_Vlambda(:,2),wave,'pchip','extrap');
load('wdwVlambda_Deutan.mat');
vlambdaDeutan = interp1(Wright_Deutan_Vlambda(:,1),Wright_Deutan_Vlambda(:,2),wave,'pchip','extrap');
load('wdwVlambda_Trichromat.mat');
vlambdaTrichromat = interp1(Wright_Trichromat_Vlambda(:,1),Wright_Trichromat_Vlambda(:,2),wave,'pchip','extrap');

ieNewGraphWin;
plot(wave,vlambdaTrichromat,'k-',wave,vlambdaDeutan,'g-',wave,vlambdaProtan,'r-');
grid on;
xlabel('Wavelength (nm)'); ylabel('Chromaticity');
legend('Trichromat','Deutan','Protan');
title('Vlambda');

%% End