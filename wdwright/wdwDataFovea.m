%% The Willmer Wright foveal CMFs
%
% Figure 217 in WD Wright book
%
% These do not match well with the Stockman data.  There are a lot of
% difficulties in interpreting these data.  
%
% * First, fixation is hard to maintain for such a small spot. 
%
% * Second, the macular pigment is space-varying, and thus the cone
% fundamentals may not be uniform as the eye jitters across different
% pigment regimes. 
%
% Here, but thinking.
%
% See also
%   wdwData*

%%
chdir(fullfile(iefundamentalsRootPath,'data','grabit'));
wave = 400:700;

%%
load('foveaTritanGreen');
foveaGreen = interp1(foveaTritanGreen(:,1),foveaTritanGreen(:,2),wave,'pchip','extrap');

load('foveaTritanRed');
foveaRed = interp1(foveaTritanRed(:,1),foveaTritanRed(:,2),wave,'pchip','extrap');

cmfFovea = [foveaRed(:),foveaGreen(:)];

%{
ieNewGraphWin;
plot(wave,fovea);
xlabel('Wavelength (nm)'); 
grid on;
%}

%%
fname = fullfile(iefundamentalsRootPath,'wdwright','cmfFovea.mat');
save(fname,'wave','cmfFovea');

%% End
