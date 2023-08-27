function coneF = conefundamental(cmf1,cmf2,varargin)
% Estimate a cone fundamental from a pair of dichromatic color
% matching functions
%
% Inputs
%   cmf1 - Dichromatic CMF
%   cmf2 - Dichromatic CMF
%
% Optional key/val
%   method
%
% Output
%   coneF - Estimated cone fundamental
%
% See also
%  wdwEstimates, many others.

% Examples:
%{
thisW = 410:650;
load('cmfDeutanC.mat','wave','cmfDeutanC');
cmfDeutan = interp1(wave,cmfDeutanC,thisW');

load('cmfProtan.mat','wave','cmfProtan');
cmfProtan = interp1(wave,cmfProtan,thisW);

load('cmfTritan.mat','obsAverage');
cmfTritan = interp1(obsAverage.wave,obsAverage.CMF,thisW);

stockman = ieReadSpectra('stockmanEnergy.mat',thisW);

Scone = conefundamental(cmfProtan,cmfDeutan,'method','nullnull');
ieNewGraphWin; plot(thisW,Scone,'b-',thisW,stockman(:,3),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

Mcone = conefundamental(cmfProtan,cmfTritan,'method','nullnull');
ieNewGraphWin; plot(thisW,Mcone,'g-',thisW,stockman(:,2),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;

Lcone = conefundamental(cmfDeutan,cmfTritan,'method','nullnull');
ieNewGraphWin; plot(thisW,Lcone,'r-',thisW,stockman(:,1),'k.','Linewidth',2);
xlabel('Wavelength (nm)'); grid on;
%}

%% Parse
varargin = ieParamFormat(varargin);

p = inputParser;

vFunc = @(x)(ismatrix(x) && size(x,2) == 2);
p.addRequired('cmf1',vFunc);
p.addRequired('cmf2',vFunc);
p.addParameter('method','nullnull',@ischar);

p.parse(cmf1,cmf2,varargin{:});

method = p.Results.method;

%% Run the relevant method through this case statement

coneF = [];

switch method
    case 'nullnull'
        coneF = estimatorNullNull(cmf1,cmf2);
    case 'sumoftwo'
        coneF = sum(estimatorIntersect(cmf1,cmf2),2);
    case 'two'
        coneF =estimatorIntersect(cmf1,cmf2);
    case 'lowrank'
        coneF = estimatorLowrank(cmf1,cmf2);
           
    otherwise
end

end