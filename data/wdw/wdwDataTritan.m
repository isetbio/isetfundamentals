%% Data from WDW 1952 Tritanopes
%
% This file contains the numerical data from the Wright 1952 paper on
% tritanopes. The publication includes both individual data and the
% observer averages.
%
% The file organizes the data and then stores them in the file
%
%    cmfTritan.mat
%
% This file contains additional data (chromaticity matches) which are
% stored separately for the protans and deutans.  For the moment.  I
% am considering merging those like this one.
%
% Notes
%  In the Wright 1952 paper, 'The Characteristics of Tritanopia' he
%  describes placing an ad in the paper looking specifically for
%  tritanopes. He found a number in the London area this way.  He
%  invited them to the lab, and they made dichromatic color match
%  settings for him.  The values in this file are copied from the
%  numerical tables he put in the JOSA paper.
%
%  There are values in the table that are stored as 9.XXX, but taken
%  at face value make no sense.  I believe this was an old fashioned
%  way of storing negative logarithms whose true value is 9.XXX - 10.
%  This is a memory from when I was a graduate student. I called Ed
%  Pugh to see if he remembered it the same way as I do.
%
%  Supposing this is true, I subtracted 10 from all those entries and
%  plotted the data.  Plotted this way, the curves match Figure 2
%  fairly closely. The little notches in the curves matchup, think my
%  memory is correct (BW).
%
%  The V-lambda curves for all seven tritanopes seem OK.
%
%  The CMFs for the 7th, however, is missing a lot of entries.  I put
%  junk in there to plot them, but I think we only have 6 CMFs.
%

%
% See also
%   The directory with the Maxwell data

% I store the CMFs of the individuals in this cell array.
% We keep only 6, not 7, because the data for OBS G is incomplete.
obs = cell(6,1);

% There is also an obsAverage at the end from Table II

%% OBS A
wdwA = [
    0.4100    0.3090    0.2960    0.7040    2.0370    0.4090    1.6280
    0.4200    0.6180    0.1800    0.8200    4.1500    0.4830    3.9890
    0.4300    0.7700    0.0660    0.9340    5.8880    0.2360    5.6520
    0.4400    0.8780         0    1.0000    7.5510         0    7.5510
    0.4500    0.9410   -0.0440    1.0440    8.7300   -0.2230    8.9530
    0.4600    1.1100   -0.0480    1.0480   12.8800   -0.3670   13.2470
    0.4700    1.2180   -0.0330    1.0330   16.5200   -0.3260   16.8480
    0.4800    1.3300         0    1.0000   21.3800         0   21.3800
    0.4900    1.4200    0.0400    0.9600   26.3000    0.6420   25.6600
    0.5000    1.6030    0.0770    0.9230   40.0900    1.9030   38.1800
    0.5100    1.7500    0.1060    0.8940   56.2300    3.7020   52.5300
    0.5200    1.8970    0.1400    0.8600   78.8900    7.0200   71.8700
    0.5300    1.9560    0.1780    0.8220   90.3600   10.3200   80.0400
    0.5400    1.9790    0.2180    0.7820   95.2800   13.5800   81.7000
    0.5500    1.9970    0.2680    0.7320   99.3100   17.8130   81.4900
    0.5600    1.9950    0.3140    0.6860   98.8600   21.2600   77.5900
    0.5700    1.9750    0.3790    0.6210   94.4100   25.2700   69.1400
    0.5800    1.9270    0.4720    0.5280   84.5300   29.4300   55.1000
    0.5900    1.8600    0.5760    0.4240   72.4400   32.4500   39.9900
    0.6000    1.7780    0.7000    0.3000   59.9800   34.9500   25.0300
    0.6100    1.6800    0.7800    0.2200   47.8600   32.5100   15.3500
    0.6200    1.5000    0.8480    0.1520   31.6200   24.3300    7.2930
    0.6300    1.3000    0.9110    0.0890   19.9500   17.1510    2.8010
    0.6400    1.0500    0.9600    0.0400   11.2200   10.4870    0.7310
    0.6500    0.8000    1.0000         0    6.3100    6.3090         0
    ];

ii = 1;
obs{ii}.wave = wdwA(:,1)*1e3;
obs{ii}.CMF = wdwA(:,6:7);
obs{ii}.logVlambda = wdwA(:,2);
obs{ii}.Vlambda = wdwA(:,5);
obs{ii}.rg = wdwA(:,3:4);
obs{ii}.VrOverVg = 0.598;

hdl = ieNewGraphWin();
hdl.Position = [0.0070    0.5819    0.3891    0.3381];

tiledlayout(1,2);
nexttile;
plot(obs{ii}.wave,obs{ii}.logVlambda);
xlabel('Wavelength (nm)')
ylabel('Log V_\lambda')
grid on;

nexttile;
plot(obs{ii}.wave,obs{ii}.CMF);
xlabel('Wavelength (nm)')
ylabel('Relative (primaries 650 and 480)');
grid on; xaxisLine;

%% OBS B
wdwB = [
    0.4100    0.1310    0.3330    0.6670    1.3520    0.4870    0.8640
    0.4200    0.2490    0.2000    0.8000    1.7740    0.3910    1.3830
    0.4300    0.3460    0.1000    0.9000    2.2180    0.2470    1.9710
    0.4400    0.4300    0.0200    0.9800    2.6920    0.0620    2.6300
    0.4500    0.4500   -0.0280    1.0280    2.8180   -0.0910    2.9080
    0.4600    0.5750   -0.0400    1.0400    3.7580   -0.1700    3.9270
    0.4700    0.8100   -0.0300    1.0300    6.4570   -0.2200    6.6770
    0.4800    0.9660         0    1.0000    9.2470         0    9.2470
    0.4900    1.0950    0.0430    0.9570   12.4500    0.6060   11.8440
    0.5000    1.3500    0.0820    0.9180   22.3900    2.0600   20.3300
    0.5100    1.6260    0.1230    0.8770   42.2700    5.7820   36.4800
    0.5200    1.8310    0.1620    0.8380   67.7600   12.1460   55.6200
    0.5300    1.9700    0.2020    0.7980   89.1300   20.7400   72.5900
    0.5400    1.9970    0.2480    0.7520   99.3100   26.9400   72.3600
    0.5500    1.9980    0.2830    0.7170   99.5400   30.7200   68.8200
    0.5600    1.9970    0.3400    0.6600   99.3100   36.5300   62.7800
    0.5700    1.9900    0.4000    0.6000   97.7200   41.9900   55.7300
    0.5800    1.9700    0.4800    0.5200   93.3300   47.6300   45.7000
    0.5900    1.9400    0.5770    0.4230   87.1000   52.8300   34.2700
    0.6000    1.8880    0.6690    0.3310   77.2700   53.7400   23.5300
    0.6100    1.8330    0.7570    0.2430   68.0800   53.0100   15.0700
    0.6200    1.7170    0.8400    0.1600   52.1200   44.6000    7.5200
    0.6300    1.5200    0.9080    0.0920   33.1100   30.3900    2.7250
    0.6400    1.2800    0.9580    0.0420   19.0500   18.3350    0.7110
    0.6500    1.0540    1.0000         0   11.3200   11.3230         0
    ];

ii = 2;
obs{ii}.wave = wdwB(:,1)*1e3;
obs{ii}.CMF = wdwB(:,6:7);
obs{ii}.logVlambda = wdwB(:,2);
obs{ii}.Vlambda = wdwB(:,5);
obs{ii}.rg = wdwB(:,3:4);
obs{ii}.VrOverVg = 1.13;

hdl = ieNewGraphWin();
hdl.Position = [0.0070    0.5819    0.3891    0.3381];

tiledlayout(1,2);
nexttile;
plot(obs{ii}.wave,obs{ii}.logVlambda);
xlabel('Wavelength (nm)')
ylabel('Log V_\lambda')
grid on;

nexttile;
plot(obs{ii}.wave,obs{ii}.CMF);
xlabel('Wavelength (nm)')
ylabel('Relative (primaries 650 and 480)');
grid on; xaxisLine;

%% OBS C
%
% Something wrong with Vlambda in this one.
% The error is in the Optical Society table.
% Check the  paper for comments
%

wdwC = [
    0.4100   -0.4600    0.3230    0.6770    0.3470    0.2070    0.1400
    0.4200   -0.3050    0.2420    0.7580    0.4960    0.2470    0.2490
    0.4300   -0.1770    0.1620    0.8380    0.6650    0.2490    0.4160
    0.4400   -0.0590    0.0840    0.9160    0.8730    0.1930    0.6800
    0.4500   -0.0820    0.0120    0.9880    0.8280    0.0300    0.7980
    0.4600    0.0550   -0.0370    1.0370    1.1350   -0.1420    1.2770
    0.4700    0.4100   -0.0300    1.0300    2.5700   -0.2550    2.8250
    0.4800    0.6130         0    1.0000    4.1020         0    4.1020
    0.4900    0.7310    0.0400    0.9600    5.3830    0.6160    4.7670
    0.5000    1.0460    0.0720    0.9280   11.1200    2.1540    8.9650
    0.5100    1.3600    0.1060    0.8940   22.9100    6.1620   16.7450
    0.5200    1.6900    0.1420    0.8580   48.9800   16.6010   32.3700
    0.5300    1.8600    0.1790    0.8210   72.4400   29.2200   43.2300
    0.5400    1.9610    0.2270    0.7730   91.4100   43.5700   47.8400
    0.5500    1.9900    0.2740    0.7260   97.7200   52.6700   45.0400
    0.5600    2.0010    0.3240    0.6760  100.2000   59.8800   40.3200
    0.5700    1.9930    0.3790    0.6210   98.4000   64.3800   34.0200
    0.5800    1.9800    0.4700    0.5300   95.5000   70.0200   25.4700
    0.5900    1.9580    0.5700    0.4300   90.7800   73.0100   17.7700
    0.6000    1.9200    0.6680    0.3320   83.1800   71.7000   11.4900
    0.6100    1.8500    0.7940    0.2060   70.7900   65.3100    5.4670
    0.6200    1.7440    0.8940    0.1060   55.4600   53.4200    2.0430
    0.6300    1.5700    0.9660    0.0340   37.1500   36.7300    0.4170
    0.6400    1.3740    0.9920    0.0080   23.6600   23.6000    0.0610
    0.6500    1.1600    1.0000         0   14.4500   14.4500         0
    ];

ii = 3;
obs{ii}.wave = wdwC(:,1)*1e3;
obs{ii}.CMF = wdwC(:,6:7);
obs{ii}.logVlambda = wdwC(:,2);
obs{ii}.Vlambda = wdwC(:,5);
obs{ii}.rg = wdwC(:,3:4);
obs{ii}.VrOverVg = 3.10;

hdl = ieNewGraphWin();
hdl.Position = [0.0070    0.5819    0.3891    0.3381];

tiledlayout(1,2);
nexttile;
plot(obs{ii}.wave,obs{ii}.logVlambda);
xlabel('Wavelength (nm)')
ylabel('Log_{10} V_\lambda')
grid on;

nexttile;
plot(obs{ii}.wave,obs{ii}.CMF);
xlabel('Wavelength (nm)')
ylabel('Relative (primaries 650 and 480)');
grid on; xaxisLine;

%% OBS D
wdwD = [
    0.4100    0.2380    0.3040    0.6960    1.7300    0.4810    1.2490
    0.4200    0.3960    0.1900    0.8100    2.4890    0.4260    2.0640
    0.4300    0.4560    0.0960    0.9040    2.8580    0.2460    2.6130
    0.4400    0.4760    0.0160    0.9840    2.9920    0.0420    2.9500
    0.4500    0.4960   -0.0200    1.0200    3.1330   -0.0560    3.1900
    0.4600    0.6430   -0.0330    1.0330    4.3950   -0.1270    4.5210
    0.4700    0.8910   -0.0210    1.0210    7.7800   -0.1480    7.9270
    0.4800    1.0360         0    1.0000   10.8600         0   10.8600
    0.4900    1.1660    0.0280    0.9720   14.6600    0.3680   14.2880
    0.5000    1.3960    0.0630    0.9370   24.8900    1.4040   23.4900
    0.5100    1.6160    0.1080    0.8920   41.3000    3.9750   37.3200
    0.5200    1.8440    0.1450    0.8550   69.8200    9.0920   60.7300
    0.5300    1.9290    0.1840    0.8160   84.9200   14.0660   70.8500
    0.5400    1.9740    0.2220    0.7780   94.1900   18.9500   75.2300
    0.5500    1.9960    0.2700    0.7300   99.0800   24.3600   74.7200
    0.5600    1.9980    0.3240    0.6760   99.5400   29.5200   70.0200
    0.5700    1.9880    0.3900    0.6100   97.2700   35.0700   62.2000
    0.5800    1.9520    0.4730    0.5270   89.5400   39.5500   49.9900
    0.5900    1.8940    0.5700    0.4300   78.3400   42.2000   36.1500
    0.6000    1.8260    0.6720    0.3280   66.9900   43.1100   23.8800
    0.6100    1.7360    0.7700    0.2300   54.4500   40.6600   13.7900
    0.6200    1.6160    0.8660    0.1340   41.3000   35.1300    6.1690
    0.6300    1.3960    0.9240    0.0760   24.8900   22.7700    2.1260
    0.6400    1.1660    0.9700    0.0300   14.6600   14.1800    0.4970
    0.6500    0.9660    1.0000         0    9.2470    9.2510         0
    ];

ii = 4;
obs{ii}.wave = wdwD(:,1)*1e3;
obs{ii}.CMF = wdwD(:,6:7);
obs{ii}.logVlambda = wdwD(:,2);
obs{ii}.Vlambda = wdwD(:,5);
obs{ii}.rg = wdwD(:,3:4);
obs{ii}.VrOverVg = 0.8810;

hdl = ieNewGraphWin();
hdl.Position = [0.0070    0.5819    0.3891    0.3381];

tiledlayout(1,2);
nexttile;
plot(obs{ii}.wave,obs{ii}.logVlambda);
xlabel('Wavelength (nm)')
ylabel('Log V_\lambda')
grid on;

nexttile;
plot(obs{ii}.wave,obs{ii}.CMF);
xlabel('Wavelength (nm)')
ylabel('Relative (primaries 650 and 480)');
grid on; xaxisLine;


%% OBS E
%
% Another 9 here that may not belong
% This must be checked in the paper.
wdwE = [ ...
   0.4100   -0.1280    0.2200    0.7800    0.7450    0.1660    0.5790
    0.4200    0.0960    0.1600    0.8400    1.2470    0.2030    1.0440
    0.4300    0.2150    0.1000    0.9000    1.6410    0.1670    1.4740
    0.4400    0.3000    0.0420    0.9580    1.9950    0.0860    1.9090
    0.4500    0.3600   -0.0100    1.0100    2.2910   -0.0230    2.3140
    0.4600    0.4600   -0.0300    1.0300    2.9170   -0.0910    3.0080
    0.4700    0.7330   -0.0220    1.0220    5.4080   -0.1190    5.5270
    0.4800    0.8830         0    1.0000    7.6380         0    7.6380
    0.4900    1.0400    0.0280    0.9720   10.9600    0.3180   10.6400
    0.5000    1.3020    0.0600    0.9400   20.0400    1.2190   18.7800
    0.5100    1.5940    0.0940    0.9060   39.2600    3.7610   35.5000
    0.5200    1.8040    0.1260    0.8740   63.6800    8.1900   55.4900
    0.5300    1.9080    0.1600    0.8400   80.9100   13.1500   67.7600
    0.5400    1.9660    0.2130    0.7870   92.4700   19.9900   72.4800
    0.5500    1.9950    0.2680    0.7320   98.8600   26.8600   72.0100
    0.5600    2.0000    0.3420    0.6580  100.0000   34.6600   65.3400
    0.5700    1.9860    0.3880    0.6120   96.8300   38.0400   58.7900
    0.5800    1.9400    0.4700    0.5300   87.1000   41.3500   45.7500
    0.5900    1.8800    0.5610    0.4390   75.8600   42.9200   32.9400
    0.6000    1.8010    0.6590    0.3410   63.2400   41.9500   21.2900
    0.6100    1.6900    0.7610    0.2390   49.9800   37.4500   11.5300
    0.6200    1.5260    0.8520    0.1480   33.5700   28.6900    4.8900
    0.6300    1.3260    0.9220    0.0780   21.1800   19.5600    1.6200
    0.6400    1.0920    0.9780    0.0220   12.3600   12.1000    0.2700
    0.6500    0.8900    1.0000         0    7.7620    7.7600         0
    ];

ii = 5;
obs{ii}.wave = wdwE(:,1)*1e3;
obs{ii}.CMF = wdwE(:,6:7);
obs{ii}.logVlambda = wdwE(:,2);
obs{ii}.Vlambda = wdwE(:,5);
obs{ii}.rg = wdwE(:,3:4);
obs{ii}.VrOverVg = 1.02;

hdl = ieNewGraphWin();
hdl.Position = [0.0070    0.5819    0.3891    0.3381];

tiledlayout(1,2);
nexttile;
plot(obs{ii}.wave,obs{ii}.logVlambda);
xlabel('Wavelength (nm)')
ylabel('Log V_\lambda')
grid on;

nexttile;
plot(obs{ii}.wave,obs{ii}.CMF);
xlabel('Wavelength (nm)')
ylabel('Relative (primaries 650 and 480)');
grid on;

%% OBS F
%
% Another 9 here that may not belong
% This must be checked in the paper.
wdwF = [ ...
    0.4100   -0.4350    0.3000    0.7000    0.3670    0.1230    0.2440
    0.4200   -0.1440    0.1700    0.8300    0.7180    0.1400    0.5790
    0.4300    0.0760    0.0800    0.9200    1.1910    0.1100    1.0800
    0.4400    0.1790         0    1.0000    1.5100         0    1.5100
    0.4500    0.2420   -0.0380    1.0380    1.7460   -0.0730    1.6730
    0.4600    0.3540   -0.0470    1.0470    2.2590   -0.1130    2.1460
    0.4700    0.6540   -0.0300    1.0300    4.5080   -0.1480    4.3600
    0.4800    0.8310         0    1.0000    6.7760         0    6.7760
    0.4900    0.9720    0.0370    0.9630    9.3760    0.4100    8.9660
    0.5000    1.2940    0.0780    0.9220   19.6800    1.7860   17.9000
    0.5100    1.6400    0.1150    0.8850   43.6500    5.8140   37.8300
    0.5200    1.8420    0.1500    0.8500   69.5000   11.9800   57.5200
    0.5300    1.9200    0.1860    0.8140   83.1800   16.6000   64.9800
    0.5400    1.9810    0.2270    0.7730   95.7200   24.6400   71.0800
    0.5500    1.9980    0.2730    0.7270   99.5400   30.5500   68.9900
    0.5600    1.9860    0.3430    0.6570   96.8300   36.9300   59.9100
    0.5700    1.9680    0.3800    0.6200   92.9000   38.9700   53.9300
    0.5800    1.9380    0.4630    0.5370   86.7000   43.7100   42.9900
    0.5900    1.8960    0.5650    0.4350   78.7000   47.7000   31.1100
    0.6000    1.8390    0.6700    0.3300   69.0200   48.7000   20.3200
    0.6100    1.7400    0.7730    0.2270   54.9500   43.9900   10.9500
    0.6200    1.6100    0.8730    0.1270   40.7400   36.2700    4.4720
    0.6300    1.3700    0.9400    0.0600   23.4400   22.2400    1.2030
    0.6400    1.1600    0.9840    0.0160   14.4500   14.2600    0.1960
    0.6500    0.9100    1.0000         0    8.1280    8.1280         0
    ];

ii = 6;
obs{ii}.wave = wdwF(:,1)*1e3;
obs{ii}.CMF = wdwF(:,6:7);
obs{ii}.logVlambda = wdwF(:,2);
obs{ii}.Vlambda = wdwF(:,5);
obs{ii}.rg = wdwF(:,3:4);
obs{ii}.VrOverVg = 1.18;


hdl = ieNewGraphWin();
hdl.Position = [0.0070    0.5819    0.3891    0.3381];

tiledlayout(1,2);
nexttile;
plot(obs{ii}.wave,obs{ii}.logVlambda);
xlabel('Wavelength (nm)')
ylabel('Log V_\lambda')
grid on;

nexttile;
plot(obs{ii}.wave,obs{ii}.CMF);
xlabel('Wavelength (nm)')
ylabel('Relative (primaries 650 and 480)');
grid on;

%% OBS G
%
% Many missing entries
% Maybe they are all 0 and 1?
%{
% This is the original
wdwG = [ ...
    0.41	0.22		
0.42	0.4		
0.43	0.546		
0.44	0.63		
0.45	0.682		
0.46	0.811		
0.47	1.065		
0.48	1.186	0	1
0.49	1.267		
0.5	1.439		
0.51	1.65		
0.52	1.819		
0.53	1.906		
0.54	1.96	0.23	0.77
0.55	1.995	0.277	0.723
0.56	1.995	0.328	0.672
0.57	1.976	0.383	0.617
0.58	1.944	0.471	0.529
0.59	1.906	0.575	0.425
0.6	1.852	0.68	0.32
0.61	1.772	0.77	0.23
0.62	1.616		
0.63	1.375		
0.64	1.15		
0.65	0.93	1	0
];
%}



%% Overlay the individuals
ieNewGraphWin;
for ii=1:numel(obs)
    plot(obs{ii}.wave,obs{ii}.logVlambda);
    hold on;
end
xlabel('Wavelength (nm)')
ylabel('Log V_\lambda')
grid on;

%% Average
wdwAve = [
    0.4100   -0.0180    0.2960    0.7040    0.9590    0.3350    0.6240
    0.4200    0.1870    0.1900    0.8100    1.5380    0.3550    1.1830
    0.4300    0.3190    0.1010    0.8990    2.0840    0.2610    1.8220
    0.4400    0.4040    0.0270    0.9730    2.5350    0.0880    2.4470
    0.4500    0.4410   -0.0210    1.0210    2.7610   -0.0750    2.8350
    0.4600    0.5730   -0.0390    1.0390    3.7410   -0.1890    3.9310
    0.4700    0.8260   -0.0280    1.0280    6.6990   -0.2430    6.9420
    0.4800    0.9780         0    1.0000    9.5060         0    9.5060
    0.4900    1.0990    0.0360    0.9640   12.5600    0.5720   11.9900
    0.5000    1.3470    0.0720    0.9280   22.2300    2.0050   20.2200
    0.5100    1.6050    0.1090    0.8910   40.2700    5.4350   34.8400
    0.5200    1.8180    0.1440    0.8560   65.7700   11.6400   54.1300
    0.5300    1.9210    0.1820    0.8180   83.3700   18.4800   64.8800
    0.5400    1.9740    0.2260    0.7740   94.1900   25.6100   68.5800
    0.5500    1.9960    0.2730    0.7270   99.0800   32.1400   66.9400
    0.5600    1.9960    0.3310    0.6690   99.0800   38.3800   60.7000
    0.5700    1.9820    0.3850    0.6150   95.9400   42.6400   53.3000
    0.5800    1.9500    0.4700    0.5300   89.1300   47.3600   41.7700
    0.5900    1.9050    0.5710    0.4290   80.3500   50.6100   29.7400
    0.6000    1.8430    0.6740    0.3260   69.6600   50.5300   19.1300
    0.6100    1.7570    0.7720    0.2280   57.1500   46.4300   10.7300
    0.6200    1.6180    0.8620    0.1380   41.5000   36.8800    4.6190
    0.6300    1.4080    0.9280    0.0720   25.5900   24.1200    1.4640
    0.6400    1.1820    0.9740    0.0260   15.2100   14.9000    0.3110
    0.6500    0.9590    1.0000         0    9.0990    9.0980         0];

obsAverage.wave = wdwAve(:,1)*1e3;
obsAverage.CMF = wdwAve(:,6:7);
obsAverage.logVlambda = wdwAve(:,2);
obsAverage.Vlambda = wdwAve(:,5);
obsAverage.rg = wdwAve(:,3:4);
obsAverage.VrOverVg = 1.278;

hdl = ieNewGraphWin();
hdl.Position = [0.0070    0.5819    0.3891    0.3381];

tiledlayout(1,2);
nexttile;
plot(obsAverage.wave,obsAverage.logVlambda);
xlabel('Wavelength (nm)')
ylabel('Log V_\lambda')
grid on;

nexttile;
plot(obsAverage.wave,obsAverage.CMF);
xlabel('Wavelength (nm)')
ylabel('Relative (primaries 650 and 480)');
grid on;

%%  I keep this as false until I want to overwrite the data file.
%
% This way, executing the script will not over-write the file.
%
% wave is stored as part of all the obs structs.
%
disp('Uncomment the line here to save the data.  Be aware of over-writing!')
%{
  fname = fullfile(iefundamentalsRootPath,'data','wdw','cmfTritan.mat');
  save(fname,'obs','obsAverage')
%}
