%% Data from WDW 1952 Tritanopes
%
%  In the Wright 1952 paper, 'The Characteristics of Tritanopia' he
%  wrote an ad in the paper looking specifically for tritanopes. He
%  found a number in the London area this way.  He invited them to the
%  lab, and they made dichromatic color match settings for him.  The
%  values in this file are copied from the numerical tables he put in
%  the JOSA paper.
% 
% Notes
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
%  The numerical values from this file are stored in a file named
%
%     wdwTritanopes.mat
%
%  in the wdwright subdirectory.
%
% See also
%   The directory with the Maxwell data

% I store the CMFs of the individuals in this cell array
obs = cell(7,1);

% There is also an obsAverage at the end from Table II

%% OBS A

wdwA = [ ...
0.41	0.309	0.296	0.704
0.42	0.618	0.18	0.82
0.43	0.77	0.066	0.934
0.44	0.878	0	1
0.45	0.941	-0.044	1.044
0.46	1.11	-0.048	1.048
0.47	1.218	-0.033	1.033
0.48	1.33	0	1
0.49	1.42	0.04	0.96
0.5	1.603	0.077	0.923
0.51	1.75	0.106	0.894
0.52	1.897	0.14	0.86
0.53	1.956	0.178	0.822
0.54	1.979	0.218	0.782
0.55	1.997	0.268	0.732
0.56	1.995	0.314	0.686
0.57	1.975	0.379	0.621
0.58	1.927	0.472	0.528
0.59	1.86	0.576	0.424
0.6	1.778	0.7	0.3
0.61	1.68	0.78	0.22
0.62	1.5	0.848	0.152
0.63	1.3	0.911	0.089
0.64	1.05	0.96	0.04
0.65	0.8	1	0 ];

ii = 1;
obs{ii}.wave = wdwA(:,1)*1e3;
obs{ii}.CMF = wdwA(:,3:4);
obs{ii}.logVlambda = wdwA(:,2);

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

%% OBS B

wdwB = [ ...
    0.41	0.131	0.333	0.667
0.42	0.249	0.2	0.8
0.43	0.346	0.1	0.9
0.44	0.43	0.02	0.98
0.45	0.45	-0.028	1.028
0.46	0.575	-0.040	1.04
0.47	0.81	-0.030	1.03
0.48	0.966	0	1
0.49	1.095	0.043	0.957
0.5	1.35	0.082	0.918
0.51	1.626	0.123	0.877
0.52	1.831	0.162	0.838
0.53	1.97	0.202	0.798
0.54	1.997	0.248	0.752
0.55	1.998	0.283	0.717
0.56	1.997	0.34	0.66
0.57	1.99	0.4	0.6
0.58	1.97	0.48	0.52
0.59	1.94	0.577	0.423
0.6	1.888	0.669	0.331
0.61	1.833	0.757	0.243
0.62	1.717	0.84	0.16
0.63	1.52	0.908	0.092
0.64	1.28	0.958	0.042
0.65	1.054	1	0 ];

ii = 2;
obs{ii}.wave = wdwB(:,1)*1e3;
obs{ii}.CMF = wdwB(:,3:4);
obs{ii}.logVlambda = wdwB(:,2);

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

%% OBS B

wdwB = [ ...
    0.41	0.131	0.333	0.667
0.42	0.249	0.2	0.8
0.43	0.346	0.1	0.9
0.44	0.43	0.02	0.98
0.45	0.45	-0.028	1.028
0.46	0.575	-0.040	1.04
0.47	0.81	-0.030	1.03
0.48	0.966	0	1
0.49	1.095	0.043	0.957
0.5	1.35	0.082	0.918
0.51	1.626	0.123	0.877
0.52	1.831	0.162	0.838
0.53	1.97	0.202	0.798
0.54	1.997	0.248	0.752
0.55	1.998	0.283	0.717
0.56	1.997	0.34	0.66
0.57	1.99	0.4	0.6
0.58	1.97	0.48	0.52
0.59	1.94	0.577	0.423
0.6	1.888	0.669	0.331
0.61	1.833	0.757	0.243
0.62	1.717	0.84	0.16
0.63	1.52	0.908	0.092
0.64	1.28	0.958	0.042
0.65	1.054	1	0 ];

ii = 2;
obs{ii}.wave = wdwB(:,1)*1e3;
obs{ii}.CMF = wdwB(:,3:4);
obs{ii}.logVlambda = wdwB(:,2);

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

%% OBS C

%
% Something wrong with Vlambda in this one.
% The error is in the Optical Society table.
% Check the  paper for comments
%

wdwC = [ ...
0.41	9.54-10	0.323	0.677
0.42	9.695-10	0.242	0.758
0.43	9.823-10	0.162	0.838
0.44	9.941-10	0.084	0.916
0.45	9.918-10	0.012	0.988
0.46	0.055	-0.037	1.037
0.47	0.41	-0.030	1.03
0.48	0.613	0	    1
0.49	0.731	0.04	0.96
0.5	    1.046	0.072	0.928
0.51	1.36	0.106	0.894
0.52	1.69	0.142	0.858
0.53	1.86	0.179	0.821
0.54	1.961	0.227	0.773
0.55	1.99	0.274	0.726
0.56	2.001	0.324	0.676
0.57	1.993	0.379	0.621
0.58	1.98	0.47	0.53
0.59	1.958	0.57	0.43
0.6	1.92	0.668	0.332
0.61	1.85	0.794	0.206
0.62	1.744	0.894	0.106
0.63	1.57	0.966	0.034
0.64	1.374	0.992	0.008
0.65	1.16	1	0 ];

ii = 3;
obs{ii}.wave = wdwC(:,1)*1e3;
obs{ii}.CMF = wdwC(:,3:4);
obs{ii}.logVlambda = wdwC(:,2);

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

%% OBS D

wdwD = [ ...
    0.41	0.238	0.304	0.696
0.42	0.396	0.19	0.81
0.43	0.456	0.096	0.904
0.44	0.476	0.016	0.984
0.45	0.496	-0.020	1.02
0.46	0.643	-0.033	1.033
0.47	0.891	-0.021	1.021
0.48	1.036	0	1
0.49	1.166	0.028	0.972
0.5	    1.396	0.063	0.937
0.51	1.616	0.108	0.892
0.52	1.844	0.145	0.855
0.53	1.929	0.184	0.816
0.54	1.974	0.222	0.778
0.55	1.996	0.27	0.73
0.56	1.998	0.324	0.676
0.57	1.988	0.39	0.61
0.58	1.952	0.473	0.527
0.59	1.894	0.57	0.43
0.6	    1.826	0.672	0.328
0.61	1.736	0.77	0.23
0.62	1.616	0.866	0.134
0.63	1.396	0.924	0.076
0.64	1.166	0.97	0.03
0.65	0.966	1	0
];

ii = 4;
obs{ii}.wave = wdwD(:,1)*1e3;
obs{ii}.CMF = wdwD(:,3:4);
obs{ii}.logVlambda = wdwD(:,2);

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


%% OBS E

%
% Another 9 here that may not belong
% This must be checked in the paper.

wdwE = [ ...
0.41	9.872-10	0.22	0.78
0.42	0.096	0.16	0.84
0.43	0.215	0.1	0.9
0.44	0.3	    0.042	0.958
0.45	0.36	-0.010	1.01
0.46	0.46	-0.030	1.03
0.47	0.733	-0.022	1.022
0.48	0.883	0	    1
0.49	1.04	0.028	0.972
0.5	    1.302	0.06	0.94
0.51	1.594	0.094	0.906
0.52	1.804	0.126	0.874
0.53	1.908	0.16	0.84
0.54	1.966	0.213	0.787
0.55	1.995	0.268	0.732
0.56	2	    0.342	0.658
0.57	1.986	0.388	0.612
0.58	1.94	0.47	0.53
0.59	1.88	0.561	0.439
0.6	    1.801	0.659	0.341
0.61	1.69	0.761	0.239
0.62	1.526	0.852	0.148
0.63	1.326	0.922	0.078
0.64	1.092	0.978	0.022
0.65	0.89	1	0
];

ii = 5;
obs{ii}.wave = wdwE(:,1)*1e3;
obs{ii}.CMF = wdwE(:,3:4);
obs{ii}.logVlambda = wdwE(:,2);

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
    0.4100    9.5650-10    0.3000    0.7000
    0.4200    9.8560-10    0.1700    0.8300
    0.4300    0.0760    0.0800    0.9200
    0.4400    0.1790         0    1.0000
    0.4500    0.2420   -0.0380    1.0380
    0.4600    0.3540   -0.0470    1.0470
    0.4700    0.6540   -0.0300    1.0300
    0.4800    0.8310         0    1.0000
    0.4900    0.9720    0.0370    0.9630
    0.5000    1.2940    0.0780    0.9220
    0.5100    1.6400    0.1150    0.8850
    0.5200    1.8420    0.1500    0.8500
    0.5300    1.9200    0.1860    0.8140
    0.5400    1.9810    0.2270    0.7730
    0.5500    1.9980    0.2730    0.7270
    0.5600    1.9860    0.3430    0.6570
    0.5700    1.9680    0.3800    0.6200
    0.5800    1.9380    0.4630    0.5370
    0.5900    1.8960    0.5650    0.4350
    0.6000    1.8390    0.6700    0.3300
    0.6100    1.7400    0.7730    0.2270
    0.6200    1.6100    0.8730    0.1270
    0.6300    1.3700    0.9400    0.0600
    0.6400    1.1600    0.9840    0.0160
    0.6500    0.9100    1.0000         0
];

ii = 6;
obs{ii}.wave = wdwF(:,1)*1e3;
obs{ii}.CMF = wdwF(:,3:4);
obs{ii}.logVlambda = wdwF(:,2);

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

% Unlikely, but I stuck the values in so I could plot it
wdwG = [ ...
    0.4100    0.2200         0    1.0000
    0.4200    0.4000         0    1.0000
    0.4300    0.5460         0    1.0000
    0.4400    0.6300         0    1.0000
    0.4500    0.6820         0    1.0000
    0.4600    0.8110         0    1.0000
    0.4700    1.0650         0    1.0000
    0.4800    1.1860         0    1.0000
    0.4900    1.2670         0    1.0000
    0.5000    1.4390         0    1.0000
    0.5100    1.6500         0    1.0000
    0.5200    1.8190         0    1.0000
    0.5300    1.9060         0    1.0000
    0.5400    1.9600    0.2300    0.7700
    0.5500    1.9950    0.2770    0.7230
    0.5600    1.9950    0.3280    0.6720
    0.5700    1.9760    0.3830    0.6170
    0.5800    1.9440    0.4710    0.5290
    0.5900    1.9060    0.5750    0.4250
    0.6000    1.8520    0.6800    0.3200
    0.6100    1.7720    0.7700    0.2300
    0.6200    1.6160    1.0000         0
    0.6300    1.3750    1.0000         0
    0.6400    1.1500    1.0000         0
    0.6500    0.9300    1.0000         0
];

ii = 7;
obs{ii}.wave = wdwG(:,1)*1e3;
obs{ii}.CMF = wdwG(:,3:4);
obs{ii}.logVlambda = wdwG(:,2);

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

wdwAve = [...
   0.4100    9.9820-10    0.2960    0.7040
    0.4200    0.1870    0.1900    0.8100
    0.4300    0.3190    0.1010    0.8990
    0.4400    0.4040    0.0270    0.9730
    0.4500    0.4410   -0.0210    1.0210
    0.4600    0.5730   -0.0390    1.0390
    0.4700    0.8260   -0.0280    1.0280
    0.4800    0.9780         0    1.0000
    0.4900    1.0990    0.0360    0.9640
    0.5000    1.3470    0.0720    0.9280
    0.5100    1.6050    0.1090    0.8910
    0.5200    1.8180    0.1440    0.8560
    0.5300    1.9210    0.1820    0.8180
    0.5400    1.9740    0.2260    0.7740
    0.5500    1.9960    0.2730    0.7270
    0.5600    1.9960    0.3310    0.6690
    0.5700    1.9820    0.3850    0.6150
    0.5800    1.9500    0.4700    0.5300
    0.5900    1.9050    0.5710    0.4290
    0.6000    1.8430    0.6740    0.3260
    0.6100    1.7570    0.7720    0.2280
    0.6200    1.6180    0.8620    0.1380
    0.6300    1.4080    0.9280    0.0720
    0.6400    1.1820    0.9740    0.0260
    0.6500    0.9590    1.0000         0
    ];

% DHB: I think the last two columns are the CMFs
wdwAveCMFs = [ ...
    0.335  0.624
    0.355  1.183
    0.261  1.822
    0.088  2.447
   -0.075  2.835
   -0.189  3.931
   -0.243  6.942
    0.000  9.506
    0.572 11.990
    2.005 20.22
    5.435 34.84
   11.64  54.13
   18.48  64.88
   25.61  68.58
   32.14  66.94
   38.38  60.70
   42.64  53.30
   47.36  41.77
   50.61  29.74
   50.53  19.13
   46.43  10.73
   36.88   4.619
   24.12   1.464
   14.90   0.311
    9.098  0.000
];

obsAverage.wave = wdwAve(:,1)*1e3;
%obsAverage.CMF = wdwAve(:,3:4);
obsAverage.CMF = wdwAveCMFs(:,1:2);
obsAverage.logVlambda = wdwAve(:,2);

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

saveFlag = false;
if saveFlag
    fname = fullfile(iefundamentalsRootPath,'wdwright','wdwTritanopes.mat');
    save(fname,'obs','obsAverage')
end
