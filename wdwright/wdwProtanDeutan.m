%% Wright 'spectral coefficients' for deutan and protan subjects
%
% These are from Fig 207 in the Color Deficient Observers book by Wright.
%
% These are really tiny differences represented this way.  
%
% Notice that the the short-wavelength region, the values are identical.
% This must be because all that there is down there is the S-cone.  In the
% long-wavelength region they differ slightly.  Because M and L differ
% slightly.
% 
% Both are monochromatic above about 600.
%
% The scan is not flat enough to use grabit well.  I need to redo.
%
% I also need to get in the V lambda for these.
%

%%  Data are stored here
chdir(fullfile(iefundamentalsRootPath,'wdwright'));

% We save at this resolution.  We do not have enough tritan data for all
% this, but that's OK.
wave = 400:700;

%% Matches Figure 200
load('ProtanCMFBluex5.mat');
protanBlue = interp1(ProtanCMFBluex5(:,1),ProtanCMFBluex5(:,2),wave,'pchip','extrap');
load('ProtanCMFRed.mat');
protanRed = interp1(ProtanCMFRed(:,1),ProtanCMFRed(:,2),wave,'pchip','extrap');

ieNewGraphWin;
plot(wave,protanBlue,'b-',wave,protanRed,'r-');
grid on;
title("Matches Figure 200")

protan = [protanRed(:), protanBlue(:)];


%% Matches Figure 208
load('DeutanCMFBluex5.mat');
deutanBlue = interp1(DeutanCMFBluex5(:,1),DeutanCMFBluex5(:,2),wave,'pchip','extrap');
load('DeutanCMFRed.mat');
deutanRed = interp1(DeutanCMFRed(:,1),DeutanCMFRed(:,2),wave,'pchip','extrap');
ieNewGraphWin;
plot(wave,deutanBlue,'b-',wave,deutanRed,'r-');
grid on;
title("Matches Figure 208")

deutan = [deutanRed(:), deutanBlue(:)];

%% Now compare with Stockman

stockman = ieReadSpectra('stockmanEnergy',wave);

%% deutan = stockman*L
ieNewGraphWin([],'wide');
tiledlayout(1,2);

% protan = stockman*L
Lprotan = stockman\protan;
estProtan = stockman*Lprotan;
nexttile;
plot(wave,estProtan,'k-',wave,protan,'k.')
title('Stockman to Protan (Fig 200)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;

nexttile;
Ldeutan = stockman\deutan;
estDeutan = stockman*Ldeutan;
plot(wave,estDeutan,'k-',wave,deutan,'k.')
title('Stockman to Deutan (Fig 208)');
xlabel('Wavelength (nm)');
ylabel('CMF'); grid on;

%% Does not normally run.

% The blue curve in the book seems off. 
deutanC = deutan;
deutanC(:,2) = protan(:,2);

saveFlag = false;
if saveFlag
    ieSaveSpectralFile(wave,deutan,'WDW data from book figures 198-208','wdwDeuteranopes.mat');
    ieSaveSpectralFile(wave,deutanC,'WDW data corrected for blue','wdwDeuteranopesC.mat');
    ieSaveSpectralFile(wave,protan,'WDW data from book figures 198-208','wdwProtanopes.mat');    
end

%% Check that we got
if saveFlag
    DC = ieReadSpectra('wdwDeuteranopesC.mat',wave);
    D = ieReadSpectra('wdwDeuteranopes.mat',wave);
    P = ieReadSpectra('wdwProtanopes.mat',wave);

    ieNewGraphWin;
    plot(wave,DC,'--',wave,D,':',wave,P,'-.');
end

%%
