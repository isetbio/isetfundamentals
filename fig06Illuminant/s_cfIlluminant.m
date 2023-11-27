%% Intersection of cone-illuminant fundamentals for illuminant changes
% 
% We read the Stockman fundamentals and then combine them with a blackbody
% radiator. This simulates how the system responds to different reflectance
% functions.  
% 
% We then calculate a virtual color channel based on the combined
% cone-illuminant fundamentals.  We use both the NullNull and Lowrank
% methods.
%
% Notes
%  The first, somewhat surprising, observation is that when the lights
%  change color temperature a lot, the best matches are obtained by scaling
%  the L and M cones both positively and negatively.
%
%  Thinking about opponent processes, of course.
%
%  This first calculation assumes arbitrary spectral reflectance as input.
%  We will incorporate changes if we know a linear basis for the surface
%  reflectances.
%
% See also
%
%% Read in two different blackbodies and stockman

wave  = 400:1:700;

% Three choose two is three pairs
cTemp = [2500 4000 8500];
stockman = ieReadSpectra('stockmanEnergy',wave);
day1 = blackbody(wave,cTemp(1));
day2 = blackbody(wave,cTemp(2));
day3 = blackbody(wave,cTemp(3));

% For now use this as a reflectance vector
% reflectance = blackbody(wave,cTemp(3));

%% Multiply to get new 'reflectance' fundamentals

% These are the fundamentals with the illuminant multiplied in.  For this
% analysis, it is as if we are measuring the reflectances, not the spectral
% radiance of the light.
st1 = diag(day1)*stockman;
st2 = diag(day2)*stockman;
st3 = diag(day3)*stockman;

%% These are the three sets of illuminant fundamentals
ieNewGraphWin([],'wide');
tiledlayout(1,3);
nexttile
plot(wave,st3);
xlabel('Wavelength (nm)'); ylabel('QE'); grid on;
title(sprintf('Color temperatre %.0f',cTemp(3)));

nexttile; plot(wave,st2);
xlabel('Wavelength (nm)'); ylabel('QE'); grid on;
title(sprintf('Color temperatre %.0f',cTemp(2)));

nexttile; plot(wave,st1);
xlabel('Wavelength (nm)'); ylabel('QE'); grid on;
title(sprintf('Color temperatre %.0f',cTemp(1)));

%% We have three combinations of lights

% We use the NullNull method because it applies to matrices of any
% dimension, not just (wave x 2)

% (1,2), (1,3), and (2,3)
v12 = estimatorNullNull(st1,st2);
v13 = estimatorNullNull(st1,st3);
v23 = estimatorNullNull(st2,st3);

ieNewGraphWin;
plot(wave,v12,'r--',wave,v23,'b--',wave,v13,'g--');
grid on; xlabel('Wave (nm)'); ylabel('Virtual channel sensitivity');
xax = xaxisLine; xax.LineStyle = '-'; xax.LineWidth = 1; xax.Color = [0.5 0.5 0.5];

legend({sprintf('%dK-%dK',cTemp(1),cTemp(2)),...
    sprintf('%dK-%dK',cTemp(2),cTemp(3)),...
    sprintf('%dK-%dK',cTemp(1),cTemp(3))});

% Find the weights for each of the estimates
wgts12 = ieScale(st1\v12,1);
wgts23 = ieScale(st1\v23,1);
wgts13 = ieScale(st1\v13,1);

disp('NullNull')
disp([wgts12, wgts23, wgts13])

%% Now use the lowrank method

% (1,2), (1,3), and (2,3)
v12 = estimatorLowrank(st1,st2);
v13 = estimatorLowrank(st1,st3);
v23 = estimatorLowrank(st2,st3);

ieNewGraphWin;
plot(wave,v12,'r--',wave,v23,'b--',wave,v13,'g--');
grid on; xlabel('Wave (nm)'); ylabel('Virtual channel sensitivity');

xax = xaxisLine; xax.LineStyle = '-'; xax.LineWidth = 1; xax.Color = [0.5 0.5 0.5];
legend({sprintf('%dK-%dK',cTemp(1),cTemp(2)),...
    sprintf('%dK-%dK',cTemp(2),cTemp(3)),...
    sprintf('%dK-%dK',cTemp(1),cTemp(3))});

% Find the weights for each of the estimates
wgts12 = ieScale(st1\v12,1);
wgts23 = ieScale(st1\v23,1);
wgts13 = ieScale(st1\v13,1);

disp('Low rank')
disp([wgts12, wgts23, wgts13])

%% Paper figure(s)
%
% Show the three illuminants on the left panel.
% Show the three virtual channels that match 12 23 and 13 on the right
% panel.
%
% Maybe just show the red and blue (1,2) and (2,3).  These are the most
% different.
% 
% Also, should we calculate the response of the virtual channel to the MCC
% reflectance chart?  We might calculate the L and S under two lights and
% then the virtual channel under the two lights?

ieNewGraphWin;
tiledlayout(1,2);
nexttile
plot(wave,day1,'k-',wave, day2,'k--',wave,day3,'k-.')
grid on; xlabel('Wave (nm)'); ylabel('Blackbody illuminant radiance (energy)');
legend({sprintf('%dK',cTemp(1)),...
    sprintf('%dK',cTemp(2)),...
    sprintf('%dK',cTemp(3))});

nexttile;
plot(wave,v12,'r-',wave,v23,'b-',wave,v13,'g-');
grid on; xlabel('Wave (nm)'); ylabel('Virtual channel sensitivity');
xax = xaxisLine; xax.LineStyle = '--'; xax.LineWidth = 1; xax.Color = [0.5 0.5 0.5];
legend({sprintf('%dK-%dK',cTemp(1),cTemp(2)),...
    sprintf('%dK-%dK',cTemp(2),cTemp(3)),...
    sprintf('%dK-%dK',cTemp(1),cTemp(3))});

%% End


