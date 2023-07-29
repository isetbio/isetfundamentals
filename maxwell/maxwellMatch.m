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
table4Matches(:,1) = juddWave(:,2)-15;   % Set to wavelength
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

%%
ieNewGraphWin;
plot(wave,y);
xlabel('Wavelength'); ylabel('Arbitrary');
grid on;

% Columns increasing in smoothness parameter.  All solutions should be 1.
tmp = matches'*y;

%% Is the solution within a linear transformation of the SS or CIE?

stockman = ieReadSpectra('stockmanenergy',wave);

n = 2;
stock2maxwell = stockman \ y(:,n);
estMaxwell = stockman*stock2maxwell;
maxwell = y(:,n);
ieNewGraphWin; plot(wave,maxwell,'k-',wave,estMaxwell,'ko');
xlabel('Wavelength estimate (nm, Judd - 15nm)');
ylabel('Arbitrary');
title('Stockman and Maxwell')
grid on;

%%



