%% Data from the dichromatic CMF table in Wysecki and Stiles, 1982
%
% Table 3(5.14.2)  Color-Matching Functions of Dichromats (page 469).
%
% This table is a transform of the WD Wright data on dichromats.  The
% data we scanned is from Wright's book (protan/deutan), and JOSA
% paper (tritan). The same set of curves are organized and reprinted
% in W&S Figures 4(5.14.2), 5(5.14.2), 6(5.14.2).
%
% Notice that the blue primary of the CMFs for the protan and deutan
% differ considerably.  This makes little sense because if these are
% reduction dichromats they should have the same S-cones and they
% should agree over the short wavelength part of the spectrum.  But
% the deutan B primary curve is MUCH narrower than the protan blue
% primary.  This is true both in the original book and in the
% reprinted figure in W&S.
%
% The data here are regularized by W&S in several ways that make them
% conform with the XYZ functions.
%

%% Where we work

chdir(fullfile(iefundamentalsRootPath,'wyszeckistiles'))

%%  The raw data copied from the table
WSTable = [
  400.0000    0.0408   -0.0036    0.0407   -0.0145    0.0004    0.0008
  410.0000    0.1250   -0.0108    0.1240   -0.0446    0.0012    0.0019
  420.0000    0.3880   -0.0330    0.3870   -0.1370    0.0044    0.0019
  430.0000    0.8320   -0.0652    0.8300   -0.2740    0.0153   -0.0152
  440.0000    1.0480   -0.0678    1.0470   -0.2860    0.0343   -0.0620
  450.0000    1.0630   -0.0434    1.0620   -0.1850    0.0611   -0.1370
  460.0000    1.0000         0    1.0000         0    0.1000   -0.2440
  470.0000    0.7700    0.0676    0.7710    0.3330    0.1460   -0.3290
  480.0000    0.4830    0.1550    0.4870    0.8310    0.2070   -0.3690
  490.0000    0.2720    0.2580    0.2790    1.4660    0.2890   -0.3860
  500.0000    0.1530    0.4060    0.1630    2.4220    0.4260   -0.4160
  510.0000    0.0790    0.6240    0.0950    3.8750    0.6380   -0.4350
  520.0000    0.0252    0.8560    0.0469    5.5540    0.8620   -0.3100
  530.0000         0    1.0000    0.0253    6.8140    1.0000         0
  540.0000    0.0147    1.0610    0.0122    7.6130    1.0540    0.4270
  550.0000    0.0214    1.0510    0.0052    8.0210    1.0360    0.9490
  560.0000    0.0225    0.9840    0.0023    8.1160    0.9600    1.5630
  570.0000    0.0205    0.8600    0.0013    7.8780    0.8280    2.2290
  580.0000    0.0165    0.6940    0.0010    7.3270    0.6530    2.8700
  590.0000    0.0122    0.5070    0.0007    6.5080    0.4610    3.3650
  600.0000    0.0080    0.3360    0.0005    5.5440    0.2870    3.5880
  610.0000    0.0050    0.2020    0.0002    4.5100    0.1550    3.4500
  620.0000    0.0028    0.1140    0.0001    3.4710    0.0730    2.9730
  630.0000    0.0015    0.0590         0    2.4420    0.0281    2.2500
  640.0000    0.0007    0.0289         0    1.6260    0.0074    1.5760
  650.0000    0.0003    0.0136         0    1.0000         0    1.0000
  660.0000    0.0002    0.0064         0    0.5720   -0.0015    0.5820
  670.0000    0.0001    0.0030         0    0.3010   -0.0012    0.3090
  680.0000    0.0000    0.0014         0    0.1600   -0.0008    0.1660
  690.0000    0.0000    0.0006         0    0.0770   -0.0005    0.0803
  700.0000    0.0000    0.0003         0    0.0386   -0.0003    0.0404];

%% Pull out the different dichromats
wave   = WSTable(:,1);
protan = WSTable(:,(2:3));
deutan = WSTable(:,(4:5));
tritan = WSTable(:,(6:7));

%% Compare with XYZ to confirm

% Perfect fit to XYZ
XYZ = ieReadSpectra('xyzenergy',wave);
L = XYZ\protan; protanEst = XYZ*L;
L = XYZ\deutan; deutanEst = XYZ*L;
L = XYZ\tritan; tritanEst = XYZ*L;

ieNewGraphWin;
plot(protan(:),protanEst(:),'r.',deutan(:),deutanEst(:),'g.',tritan(:),tritanEst(:),'b.');
grid on; identityLine; xlabel('Data'); ylabel('Estimate');
title('XYZ fits to W&S Dichromat adjusted data.')

%%  Plot the CMFS from the Table

% These are not the same as the WDW curves.  And they are worse.
ieNewGraphWin([],'tall');
tiledlayout(3,1);
nexttile;
plot(wave,protan(:,1),'r-',wave,protan(:,2),'r--');
grid on; xlabel('Wavelength (nm)')
nexttile
plot(wave,deutan(:,1),'g-',wave,deutan(:,2),'g--');
grid on; xlabel('Wavelength (nm)')
nexttile
plot(wave,tritan(:,1),'b-',wave,tritan(:,2),'b--');
grid on; xlabel('Wavelength (nm)')

%% Write out only some times, and by hand.

chdir(fullfile(iefundamentalsRootPath,'wyszeckistiles'))

saveFlag = false;
if saveFlag
    wave = wave(:);
    fname = fullfile(iefundamentalsRootPath,'wyszeckistiles','wsTable.mat');
    ieSaveSpectralFile(wave, WSTable(:,2:end), 'Table 3(5.14.2)  Color-Matching Functions of Dichromats (page 469)',fname);
    foo  = ieReadSpectra('wsTable.mat',400:50:700);

    fname = fullfile(iefundamentalsRootPath,'wyszeckistiles','wsProtan.mat');
    ieSaveSpectralFile(wave, WSTable(:,3:4),'WS Table 3(5.14.2) columns 2,3',fname);
    protan  = ieReadSpectra('wsProtan.mat');

    fname = fullfile(iefundamentalsRootPath,'wyszeckistiles','wsDeutan.mat');
    ieSaveSpectralFile(wave,deutan,'WS Table 3(5.14.2) columns 4,5',fname);
    deutan  = ieReadSpectra('wsDeutan.mat');

    fname = fullfile(iefundamentalsRootPath,'wyszeckistiles','wsTritan.mat');
    ieSaveSpectralFile(wave,tritan,'WS Table 3(5.14.2) columns 6,7',fname);
    tritan  = ieReadSpectra('wsTritan.mat');

end

%% Original numbers, scanned.  No longer needed.

%{
%% p1(lambda)
p1 = [
    0.0408
    0.125
    0.388
    0.832
    1.048
    1.063
    1.000
    0.770
    0.483
    0.272
    0.153
    0.079
    0.0252
    0
    0.0147
    0.0214
    0.0225
    0.0205
    0.0165
    0.0122
    0.0080
    0.0050
    0.00277
    0.00150
    0.00074
    0.00035
    0.00016
    0.00008
    0.00004
    0.00002
    0.00001
    ];
 
%% p2(lambda)
p2 = [
   -0.0036
   -0.0108
   -0.0330
   -0.0652
   -0.0678
   -0.0434
    0
    0.0676
    0.155
    0.258
    0.406
    0.624
    0.856
    1.000
    1.061
    1.051
    0.984
    0.860
    0.694
    0.507
    0.336
    0.202
    0.114
    0.059
    0.0289
    0.0136
    0.0064
    0.00297
    0.00142
    0.00063
    0.00030
    ];

%% d1(lambda)
d1 = [
    0.0407
    0.124
    0.387
    0.830
    1.047
    1.062
    1.000
    0.771
    0.487
    0.279
    0.163
    0.095
    0.0469
    0.0253
    0.0122
    0.0052
    0.00233
    0.00126
    0.00102
    0.00066
    0.00048
    0.00018
    0.00012
    0.00000
    0.00000
    0.00000
    0.00000
    0.00000
    0.00000
    0.00000
    0.00000
    ];

%%
d2 = [
    -0.0145
    -0.0446
    -0.137
    -0.274
    -0.286
    -0.185
    0
    0.333
    0.831
    1.466
    2.422
    3.875
    5.554
    6.814
    7.613
    8.021
    8.116
    7.878
    7.327
    6.508
    5.544
    4.510
    3.471
    2.442
    1.626
    1.000
    0.572
    0.301
    0.160
    0.077
    0.0386
    ];

%% t1
t1 = [
    0.0004
    0.0012
    0.0044
    0.0153
    0.0343
    0.0611
    0.100
    0.146
    0.207
    0.289
    0.426
    0.638
    0.862
    1.000
    1.054
    1.036
    0.960
    0.828
    0.653
    0.461
    0.287
    0.155
    0.073
    0.0281
    0.0074
    0
   -0.00154
   -0.00123
   -0.00083
   -0.00046
   -0.00025
    ];

%%﻿ T2
t2 = [
    0.00084
    0.00190
    0.00190
    -0.0152
    -0.062
    -0.137
    -0.244
    -0.329
    -0.369
    -0.386
    -0.416
    -0.435
    -0.310
    0
    0.427
    0.949
    1.563
    2.229
    2.870
    3.365
    3.588
    3.450
    2.973
    2.250
    1.576
    1.000
    0.582
    0.309
    0.166
    0.0803
    0.0404
    ];

%% Assemble
WSTable = [wave(:),p1(:),p2(:),d1(:),d2(:),t1(:),t2(:)];
protan = [p1(:),p2(:)];
deutan = [d1(:),d2(:)];
tritan = [t1(:),t2(:)];
%}


%%
