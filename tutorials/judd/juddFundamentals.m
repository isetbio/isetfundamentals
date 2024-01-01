%% The Judd 1945 paper on dichromats
%
% Standard Response Functions for Protanopic and Deuteranopic Vision
% JOSA, V. 35, no. 3
%
% The paper is a workup of the Konig analysis, along with mentions of
% Hecht and Schlaer as well as Maxwell.
%
% These are the trichromatic CMFs he derives in Table III.  The idea
% is that Wd,K and Wp,K are the color-matching functions for
% deutans and protans.  He does not address tritans here.
%
% If we accept these CMFs, then we could combine them with the Wright
% tritanopic CMFs to derive the cone fundamentals.
%
% This function saves out the file juddWWK.mat with wave and WWK.  It
% also does a little plotting and comparing of the WWK to a linear
% transformation of the StockmanEnergy data.
%
% Below, we see that the M and S cones in Judd's formulation are
% nearly identical to the Stockman cones.  The L cone, however, is a
% mixture.  See the estimation of the linear transform below.
%
% See also
%   wdw and maxwell data directories.

juddWWK = [
  380.0000    0.0000    0.0001    0.0065
  390.0000    0.0001    0.0002    0.0201
  400.0000    0.0004    0.0008    0.0679
  410.0000    0.0012    0.0026    0.2074
  420.0000    0.0040    0.0088    0.6456
  430.0000    0.0116    0.0251    1.3856
  440.0000    0.0230    0.0476    1.7471
  450.0000    0.0380    0.0759    1.7721
  460.0000    0.0600    0.1163    1.6692
  470.0000    0.0910    0.1638    1.2876
  480.0000    0.1390    0.2270    0.8130
  490.0000    0.2080    0.3150    0.4652
  500.0000    0.3230    0.4642    0.2720
  510.0000    0.5030    0.6953    0.1582
  520.0000    0.7100    0.9437    0.0782
  530.0000    0.8620    1.0997    0.0422
  540.0000    0.9540    1.1650    0.0203
  550.0000    0.9950    1.1537    0.0087
  560.0000    0.9950    1.0791    0.0039
  570.0000    0.9520    0.9434    0.0021
  580.0000    0.8700    0.7610    0.0017
  590.0000    0.7570    0.5568    0.0011
  600.0000    0.6310    0.3690    0.0008
  610.0000    0.5030    0.2224    0.0003
  620.0000    0.3810    0.1248    0.0002
  630.0000    0.2650    0.0646         0
  640.0000    0.1750    0.0318         0
  650.0000    0.1070    0.0150         0
  660.0000    0.0610    0.0070         0
  670.0000    0.0320    0.0033         0
  680.0000    0.0170    0.0016         0
  690.0000    0.0082    0.0007         0
  700.0000    0.0041    0.0003         0
  710.0000    0.0021    0.0002         0
  720.0000    0.0010    0.0001         0
  730.0000    0.0005    0.0000         0
  740.0000    0.0003    0.0000         0
  750.0000    0.0001    0.0000         0
  760.0000    0.0001    0.0000         0
  770.0000    0.0000    0.0000         0];


%%
wave = juddWWK(:,1);
WWK = juddWWK(:,2:4);
fname = fullfile(iefundamentalsRootPath,'judd','juddWWK.mat');
save(fname,'wave','WWK');

%% Comparisons

% The linear transform:
%
% WWK = stockman*L
% s' * WWK = s' * s * L
% inv(s' * s) * s' * WWK = L
% L = inv(stockman'*stockman)*stockman'*WWK
%
% Notice that L is not quite diagonal, but close.  There is a
% significant entry in the 2nd row, first column.  But the M cone and
% S cone are spot on.
stockman = ieReadSpectra('stockmanEnergy',wave);
L = stockman\WWK;
estWWK = stockman*L;

ieNewGraphWin([],'wide');

tiledlayout(1,3);
nexttile
plot(wave,WWK);
grid on; xlabel("Wavelength (nm)");
legend('Wd','Wp','K');

nexttile
plot(wave,stockman);
grid on; xlabel("Wavelength (nm)");
legend('L','M','S');

nexttile
plot(wave,estWWK,'--',wave,WWK,'-');
grid on; xlabel("Wavelength (nm)");
legend('Wd','Wp','K','estWd','estWp','estK');

%%
%{
%% Copied and pasted from the paper
wave = [380
390
400
410
420
430
440
450
460
470
480
490
500
510
520
530
540
550
560
570
580
590
600
610
620
630
640
650
660
670
680
690
700
710
720
730
740
750
760
770];

Wd = [
0.00004
.00012
.0004
.0012
.0040
.0116
.0230
.0380
.0600
.0910
.1390
.2080
.3230
.5030
.7100
.8620
.9540
.9950
.9950
.9520
.8700
.7570
.6310
.5030
.3810
.2650
.1750
.1070
.0610
.0320
.0170
.0082
.0041
.0021
.00105
.00052
.00025
.00012
.00006
.00003];

Wp = [
0.00006
.00024
.00082
.00257
.00883
.0251
.0476
.0759
.1163
.1638
.2270
.3150
.4642
.6953
.9437
1.0997
1.1650
1.1537
1.0791
.9434
.7610
.5568
.3690
.2224
.1248
.0646
.0318
.0150
.0070
.0033
.00157
.00070
.00035
.00018
.000089
.000044
.000021
.000010
.000005
.000003];

K = [
0.0065
.0201
.0679
.2074
.6456
1.3856
1.7471
1.7721
1.6692
1.2876
.8130
.4652
.2720
.1582
.0782
.0422
.0203
.0087
.0039
.0021
.0017
.0011
.0008
.0003
.0002
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000
.0000];
%}
