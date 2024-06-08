%% Thomson Wright Fundamentals
%
% Close on the S and M-cones.  The L-cone miss is notable.
%
% Thomson Wright spreadsheet from DHB.
%
% See also
%


%%
twFundamentals = xlsread('Thomson_Wright_53_TabulatedFundamentals.xlsx');

wave = twFundamentals(:,1);
twFundamentals = twFundamentals(:,2:4);
ieNewGraphWin;
plot(wave,twFundamentals);
hold on;

%%
stockman = ieReadSpectra('stockman',wave);
twFundamentals1 = twFundamentals * diag(1./max(twFundamentals));

ieNewGraphWin;
plot(wave,stockman(:,1),'r-',wave,stockman(:,2),'g-',wave,stockman(:,3),'b-');
hold on;
plot(wave,twFundamentals1(:,1),'r--',wave,twFundamentals1(:,2),'g--',wave,twFundamentals1(:,3),'b--');

%%