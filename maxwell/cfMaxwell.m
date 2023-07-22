%% Simulations and calculations related to Maxwell, 1860 color matching
%
% The Maxwell 1860 paper, reviewed by Judd and Zaidi, uses an
% interesting method to achieve color matching.
%
% RELATION BETWEEN NORMAL TRICHROMATIC VISION AND DICHROMATIC VISION
% REPRESENTING A REDUCED FORM OF NORMAL VISION (Judd in the NBS book)
%
% ON THE THEORY OF COMPOUNT COLORS (Maxwell)
%
% QASIM REVIEW
%
% JUDD MAXWELL AND MODERN COLORIMETRY
%
% NOTE: The K and J CMFs with the light box are in the 1860 paper.
% The spinning tops analysis in the 1855/1857 paper.
%
%
%% Maxwell's design in the 1860 paper

% He fixed a white and then performed a match to the white using
% mixtures of narrowband lights.  The lights were obtained by slits in
% a prismatic image, derived from an interesting box he built.
%
% Three narrowband lights were chosen as the fixed primaries.  He
% matched these to the white, repeatedly.
%
% Then he would replace one of the primaries with a different
% narrowband test light, and match these three lights to the white.
% Assuming additivity, he computed a relationship between the
% narrowband test light and the three primaries.  Thus, we had a match
% from many narrowband lights and his three primaries.  Qasim seems to
% know the actual wavelengths of the primaries (I couldn't figure out
% how he knew). Judd may have figured it out.
%
% These are shown in a table VI for observer K. and Table IX for
% observer J (maxwell himself, we think).
%
% two sets had two lights that were the same. Since they both matched
% the same white light, he could set up an equality between the two
% lights. This would result in
%
%   Wavelength, test intensity, three primar intensities
%

%% Maxwell's determination of the wavelengths from the indices

maxWave = [
    20 2450
    24 2328
    28 2240
    32 2154
    36 2078
    40 2013
    44 1951
    48 1879
    52 1846
    56 1797
    60 1755];

ieNewGraphWin;
plot(maxWave(:,1),maxWave(:,2),'-x');
xlabel('idx'); ylabel('Maxwell wave');


%% Judd wavelength

% Judd says that the three primaries (24, 44, 68) are the wavelengths
% 456.9, 528.1 and 630.2. Notice that a longer index is a shorter
% wavelength according to Maxwell.  So I arranged the idx and
% primaries in the same order. But I don't yet trust these estimates.
ieNewGraphWin;
idx = [24 44 68];
primaries = [630.2 528.1 456.9];
plot(idx,primaries,'-o');
xlabel('Index'); ylabel('Wavelength (nm)');

% This is from Judd's Table I
juddWave = [
    20 663.2
    24 630.2
    28 606.4
    32 583.1
    36 562.5
    40 544.9
    44 528.1
    48 508.6
    52 499.7
    56 486.4
    60 475.1
    64 465.9
    72 449.4
    76 441.2
    80 434.2];

ieNewGraphWin;
plot(juddWave(:,1),juddWave(:,2),'-x');
xlabel('idx'); ylabel('Maxwell wave');



%% CMFs From the 1860 paper

% The primaries were 24,  44, 68 which is why they are skipped in the
% rows, I think.  I put them in as 1s and 0s.
% Table VI.
obsK6 = [
    20.0000   44.3000   18.6000    0.4000    2.8000
   24.0000    1.0000    1.0000         0         0
   28.0000   16.1000   18.6000    5.8000   -0.1000
   32.0000   22.0000   18.6000   19.3000   -0.1000
   36.0000   25.2000   12.2000   31.4000   -0.8000
   40.0000   26.0000    3.3000   31.4000   -0.2000
   44.0000    1.0000         0    1.0000         0
   46.0000   35.0000   -1.2000   31.4000    0.3000
   48.0000   41.4000   -2.6000   31.4000    3.5000
   52.0000   62.0000   -3.4000   31.4000   30.5000
   56.0000   61.7000   -3.1000   21.0000   30.5000
   60.0000   40.5000   -1.9000    7.7000   30.5000
   64.0000   33.7000   -1.1000    1.1000   30.5000
   68.0000    1.0000         0         0    1.0000
   72.0000   32.3000    0.6000    0.2000   30.5000
   76.0000   44.0000    1.1000    0.7000   30.5000
   80.0000   63.7000    0.3000   -1.8000   30.5000];

waveK6 = interp1(juddWave(:,1),juddWave(:,2),obsK6(:,1));

obsK6(:,1) = waveK6(:);

% Obs J
obsJ9 = [
   20.0000   44.3000   18.1000   -2.5000    2.3000
   24.0000    1.0000    1.0000         0         0
   28.0000   16.0000   18.1000    6.2000   -0.7000
   32.0000   21.5000   18.1000   25.2000   -0.7000
   36.0000   19.3000    8.1000   27.5000   -0.3000
   40.0000   20.7000    2.1000   27.5000   -0.5000
   44.0000    1.0000         0    1.0000         0
   48.0000   52.3000   -1.4000   27.5000   10.7000
   52.0000   95.0000   -2.4000   27.5000   37.0000
   56.0000   51.7000   -2.2000    4.8000   37.0000
   60.0000   37.2000   -1.2000    0.8000   37.0000
   64.0000   36.7000   -0.2000    0.8000   37.0000
   68.0000    1.0000         0         0    1.0000
   72.0000   35.0000    0.6000   -0.2000   37.0000
   76.0000   40.0000    0.9000    0.5000   37.0000
   80.0000   51.0000    1.1000    0.5000   37.0000];

waveJ9 = interp1(juddWave(:,1),juddWave(:,2),obsJ9(:,1));

ieNewGraphWin;
lw = 2;
plot(waveK6,obsK6(:,3)./obsK6(:,2),'r','LineWidth',lw); hold on;
plot(waveK6,obsK6(:,4)./obsK6(:,2),'g','LineWidth',lw); hold on;
plot(waveK6,obsK6(:,5)./obsK6(:,2),'b','LineWidth',lw); hold on;

plot(waveJ9,obsJ9(:,3)./obsJ9(:,2),'r--','LineWidth',lw); hold on;
plot(waveJ9,obsJ9(:,4)./obsJ9(:,2),'g--','LineWidth',lw); hold on;
plot(waveJ9,obsJ9(:,5)./obsJ9(:,2),'b--','LineWidth',lw); hold on;
xlabel('Wavelength index');
ylabel('Primary intensity');
grid on;

% Show where the possible primaries are
yline(1,'LineWidth',2);
legend('K','','','J','','','');


%% Individual

ieNewGraphWin([],'wide');
tiledlayout(1,2);
nexttile;
plot(waveK6,obsK6(:,3)./obsK6(:,2)); hold on;
plot(waveK6,obsK6(:,4)./obsK6(:,2)); hold on;
plot(waveK6,obsK6(:,5)./obsK6(:,2)); hold on;
xlabel('Wavelength index');
ylabel('Primary intensity');
grid on;

nexttile;
plot(waveJ9,obsJ9(:,3)./obsJ9(:,2)); hold on;
plot(waveJ9,obsJ9(:,4)./obsJ9(:,2)); hold on;
plot(waveJ9,obsJ9(:,5)./obsJ9(:,2)); hold on;
xlabel('Wavelength index');
ylabel('Primary intensity');
grid on;

%% Save the data out for use by other scripts
B = obsJ9(:,3)./obsJ9(:,2);
G = obsJ9(:,4)./obsJ9(:,2);
R = obsJ9(:,5)./obsJ9(:,2);
wave = waveJ9;
save('maxwellCMF_obsJ','wave','R','G','B');

B = obsK6(:,3)./obsK6(:,2);
G = obsK6(:,4)./obsK6(:,2);
R = obsK6(:,5)./obsK6(:,2);
wave = waveK6;
save('maxwellCMF_obsK','wave','R','G','B');

ieNewGraphWin([],'wide');
tiledlayout(1,2);
nexttile;
obsJ = load("maxwellCMF_obsJ.mat");
plot(obsJ.wave,obsJ.R(:),'r',obsJ.wave,obsJ.G(:),'g',obsJ.wave,obsJ.B(:),'b');
nexttile;
obsK = load("maxwellCMF_obsK.mat");
plot(obsK.wave,obsK.R(:),'r',obsK.wave,obsK.G(:),'g',obsK.wave,obsK.B(:),'b');

%%