%% s_maxwellCMF2CIEshift
%
% See also
%   maxwellCMF2CIE
%
%   maxwellMatch - That script contains a new analysis. It computes
%   directly from the matches in Table IV to the CMFs and shows a good
%   match, as well.
%
%   maxwellJuddWave.m - We explain Judd's estimate of the wavelength in
%   nanometers from Maxwell's reported wavelengths.
%
%   maxwellDataCMF - Writes out the data from the Maxwell 1860 paper into
%   the data subdirectory. The values are taken from the original paper.
%
% See also

%% Initialize
clear; close all;

%% Maxwell observers' CMFs
%
% These data are in the data directory of this repository.
obsJ = load("maxwellCMF_obsJ.mat");
obsK = load('maxwellCMF_obsK');

% We believe that Judd's estimates of Maxwell's wavelengths are off by ~10 nm.
% The reason may be that there was a slight, constant offset, in the position that Maxwell
% identified on his apparatus. We have no specific evidence for this, but
% including this adjustment brings Maxwell's data in excellent alignment
% with the modern data, particularly in the short wavelength part of the
% spectrum.

cnt = 1;
shiftValues = 0:2:20;

err = zeros(numel(shiftValues),3);
for juddAdjust = shiftValues

    %% Transform Maxwell's CMFs to CIE XYZ and plot the comparison
    %
    % Start with Observer K
    %
    % Adjust the wavelengths
    waveK = obsK.wave - juddAdjust;
    XYZK = ieReadSpectra('XYZEnergy',waveK);
    RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];

    % Find the linear transform from the CMF to CIE XYZ
    %
    % The fit
    %    XYZ ~ RGB*L
    %    pinv(RGB)*XYZ = L
    %
    %   XYZ_est = RGB*L
    L = pinv(RGB)*XYZK;
    XYZ_estK = RGB*L;

    % Now for Observer J.
    waveJ = obsJ.wave - juddAdjust;
    XYZJ = ieReadSpectra('XYZEnergy',waveJ);
    RGB = [obsJ.R(:),obsJ.G(:),obsJ.B(:)];
    L = pinv(RGB)*XYZJ;
    XYZ_estJ = RGB*L;
    
   

    %%  Transform Maxwell's CMFs to Stockman-Sharpe CMF and compare
    %
    % Bring Maxwell's CMFs into alighnment with
    % the Stockman-Sharpe cone fundamentals.
    wave = obsK.wave - juddAdjust;
    SS = ieReadSpectra('StockmanEnergy',wave);
    RGB = [obsK.R(:),obsK.G(:),obsK.B(:)];
    L = pinv(RGB)*SS;
    SS_est = RGB*L;

    %% Make a slightly different figure styled for a slide
    %
    % This references Maxwell and Stockman-Sharpe back to CIE XYZ
    %
    % This should be run after the sections above, as it uses variables
    % created there.
    SSK = ieReadSpectra('StockmanEnergy',waveK);
    L = pinv(SSK)*XYZK;
    XYZK_SSest = SSK*L;

    %% Finally, create a form of the same plot a monochrome paper figure
    %{
    ieNewGraphWin([],'big'); clf; hold on;
    marker = [ 0.95 0.8 0.5];   % Gray levels of the subject marker data

    set(gca,'FontName','Helvetica','FontSize',26);
    plot(waveK,XYZK(:,1),'-','Color',[1 1 1]*0.5,'LineWidth',4);
    plot(waveK,XYZK_SSest(:,1),':','Color',[1 1 1]*0.0,'LineWidth',4);
    set(gca,'FontName','Helvetica','FontSize',14);
    plot(waveK,XYZ_estK(:,1),'o','Color',[1 1 1]*0,'MarkerFaceColor',[1 1 1]*marker(1),'MarkerSize',12);
    plot(waveJ,XYZ_estJ(:,1),'s','Color',[1 1 1]*0,'MarkerFaceColor',[1 1 1]*marker(1),'MarkerSize',12);

    plot(waveK,XYZK(:,2),'-','Color',[1 1 1]*0.5,'LineWidth',4);
    plot(waveK,XYZK_SSest(:,2),':','Color',[1 1 1]*0,'LineWidth',4);
    plot(waveK,XYZ_estK(:,2),'o','Color',[1 1 1]*0,'MarkerFaceColor',[1 1 1]*marker(2),'MarkerSize',12);
    plot(waveJ,XYZ_estJ(:,2),'s','Color',[1 1 1]*0,'MarkerFaceColor',[1 1 1]*marker(2),'MarkerSize',12);

    plot(waveK,XYZK(:,3),'-','Color',[1 1 1]*0.5,'LineWidth',4);
    plot(waveK,XYZK_SSest(:,3),':','Color',[1 1 1]*0,'LineWidth',4);
    plot(waveK,XYZ_estK(:,3),'o','Color',[1 1 1]*0,'MarkerFaceColor',[1 1 1]*marker(3),'MarkerSize',12);
    plot(waveJ,XYZ_estJ(:,3),'s','Color',[1 1 1]*0,'MarkerFaceColor',[1 1 1]*marker(3),'MarkerSize',12);

    fSizeTicks = 20;
    fSizeLabel = 24;
    fontName = 'Georgia';
    set(gca,'FontSize',fSizeTicks,'FontName',fontName);
    tmp = xlabel('Wavelength (nm)','FontName',fontName,'FontSize',fSizeLabel);
    ylabel('Tristimulus value','FontName',fontName,'FontSize',fSizeLabel);
    % legend({'CIE 1931 XYZ', 'Stockman-Sharpe expressed in XYZ', 'Maxwell 1860 Obs K expressed in XYZ', 'Maxwell 1860 Obs J expressed in XYZ'},'FontName','Helvetica','FontSize',18);
    % title('Color Matching Over 150 Years','FontName','Helvetica','FontSize',30);
    xaxisLine;
    title(sprintf('Judd shift %d',juddAdjust));
    drawnow;
    %}

    tmp1 = [XYZK; XYZJ];
    tmp2 = [XYZ_estK; XYZ_estJ];
    err(cnt,:) = rmse(tmp2(:),tmp1(:));
    cnt = cnt+1;

end

ieNewGraphWin;
plot(shiftValues,err);
grid on;
xlabel('Shift in nm');
ylabel('RMSE in XYZ terms (ugh)')
title('Judd-Maxwell adjustment')
%% END