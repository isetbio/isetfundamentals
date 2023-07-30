%% These are the trichromatic matches to white reported in Maxwell 1860
%
%
%
% More explanation here about why that is interesting later.
%
% It turns out we have 

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

%% Table IV Observer K the mean of four sets of observations

%{
% All of these spectral vectors (columns) match the standard white. The
% values are the average of four matches by OBS K. 
% 
% Why is there a single match for the index 46 in here?  Could that
% actually be a 48 or a 44?  If it is 44 that would be the three primaries
% match to white, and it would make more sense of the data.
table4Matches = [
    20     44.3  0     0     0     0     0     0     0     0     0     0     0     0     0     
    24     0     0     0   6.4     15.3  19.8  21.2  22    21.7  20.5  19.7  18.0  17.5  18.3  
    28     0     16.1  0     0     0     0     0     0     0     0     0     0     0     0     
    32     0     0     22.0  0     0     0     0     0     0     0     0     0     0     0     
    36     0     0     0     25.2  0     0     0     0     0     0     0     0     0     0     
    40     0     0     0     0     26.0  0     0     0     0     0     0     0     0     0     
    44     31    25.6  12.1  0     0     0     0     0     10.4  23.7  30.3  31.2  30.7  33.2     
    46     0     0     0     0     0     35.0  0     0     0     0     0     0     0     0     
    48     0     0     0     0     0     0     41.4  0     0     0     0     0     0     0     
    52     0     0     0     0     0     0     0     62    0     0     0     0     0     0     
    56     0     0     0     0     0     0     0     0     61.7  0     0     0     0     0     
    60     0     0     0     0     0     0     0     0     0     40.5  0     0     0     0     
    64     0     0     0     0     0     0     0     0     0     0     33.7  0     0     0     
    68     27.7  30.6  30.6  31.3  30.7  30.2  27.0  13    0     0     0     0     0     0     
    72     0     0     0     0     0     0     0     0     0     0     0     32.3  0     0     
    76     0     0     0     0     0     0     0     0     0     0     0     0     44    0     
    80     0     0     0     0     0     0     0     0     0     0     0     0     0     63.7    
];
%}

% Adjusted from the table, setting the 46 value to 44.  That way, we
% include the primaries match to the white.  If it is 46, well, that would
% just be weird.
table4Matches = [
    20     44.3  0     0     0     0     0     0     0     0     0     0     0     0     0     
    24     0     0     0   6.4     15.3  19.8  21.2  22    21.7  20.5  19.7  18.0  17.5  18.3  
    28     0     16.1  0     0     0     0     0     0     0     0     0     0     0     0     
    32     0     0     22.0  0     0     0     0     0     0     0     0     0     0     0     
    36     0     0     0     25.2  0     0     0     0     0     0     0     0     0     0     
    40     0     0     0     0     26.0  0     0     0     0     0     0     0     0     0     
    44     31    25.6  12.1  0     0     35.0  0     0     10.4  23.7  30.3  31.2  30.7  33.2     
    48     0     0     0     0     0     0     41.4  0     0     0     0     0     0     0     
    52     0     0     0     0     0     0     0     62    0     0     0     0     0     0     
    56     0     0     0     0     0     0     0     0     61.7  0     0     0     0     0     
    60     0     0     0     0     0     0     0     0     0     40.5  0     0     0     0     
    64     0     0     0     0     0     0     0     0     0     0     33.7  0     0     0     
    68     27.7  30.6  30.6  31.3  30.7  30.2  27.0  13    0     0     0     0     0     0     
    72     0     0     0     0     0     0     0     0     0     0     0     32.3  0     0     
    76     0     0     0     0     0     0     0     0     0     0     0     0     44    0     
    80     0     0     0     0     0     0     0     0     0     0     0     0     0     63.7    
];

%% From 10nm to 15nm fits are fine.  20nm is too much.  5 too little.
juddAdjust = 12;
table4Matches(:,1) = juddWave(:,2)-juddAdjust;   % Set to wavelength
table4Matches = flipud(table4Matches);

wave    = table4Matches(:,1);
matches = table4Matches(:,2:end);

%% Find the best fit to all ones
%
% This is under-determined.  There are 16 wavelengths and only 14 matches.
% So we need to reduce the dimensionality of the solution to obtain an
% estimate of y, and then interpolate it back up.
%
% The structure of the matrix equation we want is
%   
%     1sColumn = Matches^t x
%
% 

% The first question is whether the solution
O = ones(size(matches',1),1);
lambda = logspace(-2,3,6);
y = zeros(numel(wave),numel(lambda));
for ii = 1:numel(lambda)
    y(:,ii) = ieTikhonov(matches',O,'smoothness',lambda(ii));
end

%% How good are the smooth'd fits?

%{
ieNewGraphWin;
plot(wave,y);
xlabel('Wavelength'); ylabel('Arbitrary'); grid on;

% Columns increasing in smoothness parameter.  All solutions should be 1.
tmp = matches'*y;
%}

%% Is the solution within a linear transformation of the SS or CIE?

stockman = ieReadSpectra('stockmanenergy',wave);

% The first few are all OK.  
n = 1;
stock2maxwell = stockman \ y(:,n);
estMaxwell = stockman*stock2maxwell;
maxwell = y(:,n);
ieNewGraphWin; plot(wave,maxwell,'k-',wave,estMaxwell,'ko');
xlabel(sprintf('Wavelength estimate (nm, Judd - %d nm)',juddAdjust));
ylabel('Arbitrary');
title('Stockman and Maxwell')
grid on;
legend('Maxwell','Stockman')

%%  Let's see if we can find the null space.

% The idea is to set up an equation to solve for one vector in the null
% space.  Then we will add that vector to the match matrix and solve again,
% hopefully to find a new, independent vector in the null space.
%

A = matches';
N = null(A);

% These are already pretty smooth.  But we could smooth them more if we
% liked.
ieNewGraphWin;
plot(wave,N); grid on;
xlabel(sprintf('Wavelength estimate (nm, Judd - %d nm)',juddAdjust));
ylabel('Arbitrary');
title('Null space vectors');



%% Now let's see how well we do fitting all three

M = [ieScale(maxwell(:),1), ieScale(N(:,1),1), ieScale(N(:,2),1)];
lTransform = M \ stockman;
estStockman = M * lTransform;

%{
plot(wave,M); grid on;
xlabel(sprintf('Wavelength estimate (nm, Judd - %d nm)',juddAdjust));
ylabel('Arbitrary');
xaxisLine;
%}

ieNewGraphWin;
plot(wave,estStockman); grid on; hold on;
plot(wave,stockman(:,1),'ro',wave,stockman(:,2),'go',wave,stockman(:,3),'bo');
xlabel(sprintf('Wavelength estimate (nm, Judd - %d nm)',juddAdjust));
ylabel('Arbitrary');
title('Maxwell mapped to Stockman')
legend('Maxwell','Stockman')


%% Experiment with smoothing

% A smooth solution might be to make a low frequency approximation to the
% null space vectors. But, it does not fit quite as well because the green
% is too narrow.

%{
g = fspecial('gaussian',[1,16],0.5);
smoothedN(:,2) = conv(N(:,2),g,'same');

M = [ieScale(maxwell(:),1), ieScale(smoothedN(:,1),1), ieScale(smoothedN(:,2),1)];
lTransform = M \ stockman;
estStockman = M * lTransform;

ieNewGraphWin;
plot(wave,estStockman); grid on; hold on;
plot(wave,stockman(:,1),'ro',wave,stockman(:,2),'go',wave,stockman(:,3),'bo');
xlabel(sprintf('Wavelength estimate (nm, Judd - %d nm)',juddAdjust));
ylabel('Arbitrary');
title('Smoothed Maxwell mapped to Stockman')
legend('Maxwell','Stockman')
%}

%%
%{
%% Fit to the Maxwell from the Stockman

lTransform = stockman \ M;

estMaxwell3 = stockman *lTransform;

plot(wave,estMaxwell3);
grid on;
xlabel('Wavelength'); ylabel('Arbitrary');
hold on;
plot(wave,M,'ro');
xlabel('Wavelength'); ylabel('Arbitrary');
%}


