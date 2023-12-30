%% Wright deutan and protan subjects
%
% These data are derived from the Color Deficient Observers book by Wright.
%
%    * CMFS:  Figures 200, 208
%    * Chromaticity matches (spectral coefficients): Fig 207
%    * Vlambda:  Figure 205
%
% The output files are cmfProtan, cmfDeutan, cmfDeutanC, and vlambda
% 
% The files contain the cmf and the chromaticities and the vlambda for
% each of the dichromat types.  We save the vlambda file too because,
% well, why not.  It has the same vlambda data as the others.
%
% Notes
%
%  Both types of dichromats are essentially monochromatic above about 600.
%
%  There are only tiny differences between these two types of
%  dichromats when represented w.r.t. chromaticity.
%
%  In the short-wavelength region, the values are identical. This must
%  be because all that there is down there is the S-cone.  In the
%  long-wavelength region they differ slightly. Because M and L differ
%  slightly.
% 
% See also
%

%%  Grabit data are stored here
chdir(fullfile(iefundamentalsRootPath,'data','grabit'));

% We save at this resolution.  We do not have enough tritan data for all
% this, but that's OK.
wave = 400:700;

%% Color Matching Functions: Matches Figure 200
load('ProtanCMFBluex5.mat');
protanBlue = interp1(ProtanCMFBluex5(:,1),ProtanCMFBluex5(:,2),wave,'pchip','extrap');
load('ProtanCMFRed.mat');
protanRed = interp1(ProtanCMFRed(:,1),ProtanCMFRed(:,2),wave,'pchip','extrap');

%{
ieNewGraphWin;
plot(wave,protanBlue,'b-',wave,protanRed,'r-');
grid on;
title("Matches Figure 200")
%}

cmfProtan = [protanRed(:), protanBlue(:)];

%% Matches Figure 208
load('DeutanCMFBluex5.mat');
deutanBlue = interp1(DeutanCMFBluex5(:,1),DeutanCMFBluex5(:,2),wave,'pchip','extrap');
load('DeutanCMFRed.mat');
deutanRed = interp1(DeutanCMFRed(:,1),DeutanCMFRed(:,2),wave,'pchip','extrap');

%{
ieNewGraphWin;
plot(wave,deutanBlue,'b-',wave,deutanRed,'r-');
grid on;
title("Matches Figure 208")
%}

cmfDeutan = [deutanRed(:), deutanBlue(:)];

%% BW is very suspicious of the blue primary in the Deutan data

% The curve does not fit with the Stockman fundamentals (see
% wdwStockman) but the protan does.  Also it is very different from
% the protan.  This should not happen because both have the same S-cones
% according to Reduction Dichromacy.  So we create this fake cmfDeutan in
% which we copy the cmfProtan(:,2) into it. This has consequences for any
% of the cone fundamental calculations.
cmfDeutanC = cmfDeutan;
cmfDeutanC(:,2) = cmfProtan(:,2);

%{
ieNewGraphWin;
plot(wave,cmfDeutanC(:,1),'r-',wave,cmfDeutanC(:,2),'b-');
grid on;
title("Corrected CMF for Deutan")
%}

%% Chromaticities (Figure 207)

load('wdwChromRedProtan.mat');
protanChromRed = interp1(wdwProtanChromRed(:,1),wdwProtanChromRed(:,2),wave,'pchip','extrap');

load('wdwChromRedDeutan.mat');
deutanChromRed = interp1(wdwDeutanChromRed(:,1),wdwDeutanChromRed(:,2),wave,'pchip','extrap');

% Wright calls these spectral coefficient curves
chromaticityProtan = [protanChromRed(:),1 - protanChromRed(:)];
chromaticityDeutan = [deutanChromRed(:),1 - deutanChromRed(:)];

%{
ieNewGraphWin;
plot(wave,chromaticityProtan,'r-',wave,chromaticityDeutan,'g--','Linewidth',2);
grid on;
xlabel('Wavelength (nm)'); ylabel('Chromaticity');
legend('Protan','','Deutan','');
title('Spectral coefficients for primaries: 460, 650');
%}

%% Vlambda (Figure 205)

load('wdwVlambda_Protan.mat');
vlambdaProtan = interp1(Wright_Protan_Vlambda(:,1),Wright_Protan_Vlambda(:,2),wave,'pchip','extrap');
load('wdwVlambda_Deutan.mat');
vlambdaDeutan = interp1(Wright_Deutan_Vlambda(:,1),Wright_Deutan_Vlambda(:,2),wave,'pchip','extrap');
load('wdwVlambda_Trichromat.mat');
vlambdaTrichromat = interp1(Wright_Trichromat_Vlambda(:,1),Wright_Trichromat_Vlambda(:,2),wave,'pchip','extrap');

%{
ieNewGraphWin([],'wide');
tiledlayout(1,3);
nexttile;
plot(wave,vlambdaProtan,'k-',Wright_Protan_Vlambda(:,1),Wright_Protan_Vlambda(:,2),'ro');
title('Protan');

nexttile;
plot(wave,vlambdaDeutan,'k-',Wright_Deutan_Vlambda(:,1),Wright_Deutan_Vlambda(:,2),'go');
title('Deutan')

nexttile;
plot(wave,vlambdaTrichromat,'k-',Wright_Trichromat_Vlambda(:,1),Wright_Trichromat_Vlambda(:,2),'ko'); title('Trichromat');
grid on; xlabel('Wavelength (nm)'); ylabel('Chromaticity');

%}

%% Save the CMFs

disp('Uncomment below here to save. But at your own peril!')
%{
fname = fullfile(iefundamentalsRootPath,'wdwright','cmfProtan.mat');
save(fname,'wave','cmfProtan','chromaticityProtan','vlambdaProtan');

fname = fullfile(iefundamentalsRootPath,'wdwright','cmfDeutan.mat');
save(fname,'wave','cmfDeutan','chromaticityDeutan','vlambdaDeutan');

fname = fullfile(iefundamentalsRootPath,'wdwright','cmfDeutanC.mat');
save(fname,'wave','cmfDeutanC');

% While we are at it
fname = fullfile(iefundamentalsRootPath,'wdwright','vlambda.mat');
save(fname,'wave','chromaticityProtan','vlambdaProtan','vlambdaDeutan','vlambdaTrichromat');
%}


%% End