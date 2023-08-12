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

%% Protan

% These are 'spectral coefficients'.  Let's ignore.
%
%{
load('ProtanRed.mat','ProtanRed');
load('ProtanBlue.mat','ProtanBlue');

load('DeutanRed.mat','DeutanRed');
load('DeutanBlue.mat','DeutanBlue');

ProtanBlue(end,end) = -0.0031;  % Bad point in the file

%{
idx = (ProtanRed(:,1) > 599);
ProtanRed(idx,2) = 1;
idx = (DeutanRed(:,1) > 599);
DeutanRed(idx,2) = 1;
%}

%% Fix a few imperfections
pRed  = interp1(ProtanRed(:,1),ProtanRed(:,2),wave,'pchip','extrap');
pBlue = interp1(ProtanBlue(:,1),ProtanBlue(:,2),wave,'pchip','extrap');

dRed  = interp1(DeutanRed(:,1),DeutanRed(:,2),wave,'pchip','extrap');
dBlue = interp1(DeutanBlue(:,1),DeutanBlue(:,2),wave,'pchip','extrap');

pBlue(1:10) = dBlue(1:10);
pBlue(end-20:end) = dBlue(end-20:end);

%%
ieNewGraphWin;
plot(wave,pRed,'r-',wave,pBlue,'b-');
xaxisLine; grid on;
title('Protan spectral coefficients (Fig 207)');

%% Deutan



ieNewGraphWin;
plot(wave,dRed,'ro',wave,dBlue,'bo');
xaxisLine; grid on;
title('Deutan spectral coefficients (Fig 207)');

%% Now plot the whole thing, as in the book

ieNewGraphWin;
plot(wave,pRed,'r.',wave,pBlue,'r.');
hold on;
plot(wave,dRed,'g.',wave,dBlue,'g.');
xaxisLine; grid on; xaxisLine(gca,1);

title('Protan and Deutan spectral coefficients (Fig 207)');
xlabel('Wavelength (nm)');
ylabel('Spectral coefficient');
grid on;
legend({'Protan R','Protan B','Deutan R','Deutan B'},'Location','best');

%% Individual curves

ieNewGraphWin([],'wide');
tiledlayout(1,2);
nexttile;
plot(wave,pRed,'r.',wave,dRed,'g.');
legend({'Protan','Deutan'},'Location','northwest');
xlabel('Wavelength (nm)');
ylabel('Spectral coefficient');
grid on;

nexttile;
plot(wave,pBlue,'r.',wave,dBlue,'g.');
legend({'Protan','Deutan'});
xlabel('Wavelength (nm)');
ylabel('Spectral coefficient');
grid on;

%}
