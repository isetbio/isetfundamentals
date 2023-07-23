%% Judd wavelength estimates from Maxwell's paper
%
% The Judd wavelength estimates differ by a factor of 3.694 from the
% Maxwell wavelengths.  
%
%   JuddWave (nm) = Maxwell/3.694
%
%
%% Maxwell's determination of the wavelengths from the indices

% Table II
maxwellWave = [
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
    60 1755
    64 1721
    68 1688
    72 1660
    76 1630
    80 1604];

ieNewGraphWin;
plot(maxwellWave(:,1),maxwellWave(:,2),'-x');
xlabel('idx'); ylabel('Maxwell wave');

%% Judd says, however,

% Judd says that the three primaries (24, 44, 68) are the wavelengths
% 456.9, 528.1 and 630.2. Notice that a longer index is a shorter
% wavelength according to Maxwell.  So I arranged the idx and
% primaries in the same order. But I don't yet trust these estimates.
%% The Judd 1961 paper asserts that Maxwell's indices
% correspond to these wavelengths.  He also provides the primaries.
% These are cited in Qasim's paper, too.
%

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
    68 456.9
    72 449.4
    76 441.2
    80 434.2];

ieNewGraphWin;
plot(juddWave(:,1),juddWave(:,2),'-x');
xlabel('idx'); ylabel('Maxwell wave');

%% What is the relationship?

ieNewGraphWin;
plot(maxwellWave(:,2),juddWave(:,2),'k-o');
grid on;
xlabel('Maxwell wave'); ylabel('Judd wave');

%% Fit a line and show that the slope is pretty much the whole deal.

[slope, offset] = ieFitLine(maxwellWave(:,2),juddWave(:,2));

ratios = maxwellWave(:,2)./juddWave(:,2);

ieNewGraphWin;
plot(juddWave(:,2),maxwellWave(:,2)/mean(ratios),'--');
mean(ratios)
identityLine;
