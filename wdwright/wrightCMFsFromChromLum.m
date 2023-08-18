% Wright 1952 data audit
%
% We think Wright's 1952 data are tabulated Vlambda, r and g WDW chromaticities,
% and R and G CMFs in luminance units.  This belief is in part based on
% checks performed here.
%
% One thing we observe, unless our understanding of the data is way off,
% is that the degree to which the tabulated CMF data is consistent with
% the r, g, and Vlambda data varies across observers.  In some cases, it
% is essentially perfect, while in others it is quite a bit off.
% Wright's CMFs come from measurements of photopic luminance
% and match chromaticities.
%
% Observer C shows particularly bad agreement.  This observer has the 
% highest Vr/Vg ratio.
%
% Text in the article says that the CMFs were derived from the
% chromaticities and luminance.

% Some comments from the Wright article to remember:
%
%    "... no color receptor is required at the short-wave end of the spectrum
%     to explain tritanopic color vision, apart from a renewed activity of
%     the red receptors below 0.43μ which, as will be seen below, is
%     indicated by the color matching data."

%% Initializing
ieInit;

%% Load data typed in from Wright, 1952
%
% These were assembled and stored in wdwtritanopes.m
fname = fullfile(iefundamentalsRootPath,'wdwright','wdwTritanopes.mat');
theWrightData = load(fname,'obs','obsAverage');

% Extract fields
%
% 'Avg' must be last in this list so that the indexing of observers comes
% out right.
observers = {'ObsA' 'ObsB' 'ObsC' 'ObsD' 'ObsE' 'ObsF' 'Avg'};
for oo = 1:length(observers)
    observer = observers{oo};
    fprintf('\n*** Observer %s*** \n',observer);
    switch (observer)
        case 'Avg'
            wave = theWrightData.obsAverage.wave;
            RGCMF = theWrightData.obsAverage.CMF;
            rgWDW = theWrightData.obsAverage.rg;
            Vlambda = theWrightData.obsAverage.Vlambda;

            % Adjusted for the correct value from the table.  I should fix
            % the mat file.
            % VrOverVg = theWrightData.obsAverage.VrOverVg;
            VrOverVg = 1.278;
        case {'ObsA' 'ObsB' 'ObsC' 'ObsD' 'ObsE' 'ObsF'}
            ii = oo;
            wave = theWrightData.obs{ii}.wave;
            RGCMF = theWrightData.obs{ii}.CMF;
            rgWDW = theWrightData.obs{ii}.rg;
            Vlambda = theWrightData.obs{ii}.Vlambda;
            VrOverVg = theWrightData.obs{ii}.VrOverVg;   % Observer specific
        otherwise
            error('Need to add case for requested observer');
    end

    %% Wright primary wavelengths
    %
    % These are the primaries for the tritanope matches
    wlRPrimary = 650;
    wlGPrimary = 480;

    %% WDW normalization
    %
    % For the WDW normalization, the chromaticities would be scaled to be
    % equal at the normalizing wavelength of 582.5. This pretty much appears
    % to be true in the tables.
    %
    % Stockman and Sharpe (1998) write:
    %     "WDW coordinates are a form of chromaticity coordinates devised by W.
    %     D. Wright. They are calculated by first normalizing r(l) and g(l) to
    %     be equal at 582.5 nm, and then normalizing g(l) and b(l) to be equal
    %     at 494.0 nm. This double normalization produces chromaticity data
    %     that are independent of variations in prereceptoral filtering. For
    %     tritanope data, only the first normalization applies."
    %
    % This also makes it sound like the normalization would be applied to the
    % chromaticities and not to the CMFs. Applying to chromaticities is
    % less ambigous, since for the tritanopes at least you scale either
    % r or b to 0.5 at 582.5 and then set the other via (e.g.) r = 1 - b.
    % And the tabulated CMFs are not equal at 582.5 nm.
    %
    % This all makes sense, except to decide Wright didn't
    % actually mean it when he wrote in the text:
    %    "The radiations 0.65μ and 0.48μ were chosen as the matching stimuli
    %    and their units were adjusted to be equal in the match on a
    %    monochromatic yellow at wavelength 0.5825μ."
    wlWDWNormalize = 582.5;

    % This calculation shows the tabulated CMFs do not have R == G at the
    % normalizing wavelength.
    %
    % Indeed, we think these CMFs are with respect to the primaries in photometric
    % equality, so that VR + VG = Vlambda.  In general we can't have both
    % this be true and have the R and G CMFs normalized to be equal at
    % a particular wavelength.
    interpMethod = 'linear';
    RCMFAtNormWl = interp1(wave,RGCMF(:,1),wlWDWNormalize,interpMethod);
    GCMFAtNormWl = interp1(wave,RGCMF(:,2),wlWDWNormalize,interpMethod);
    fprintf('Tabulated R and G at %0.2f nm; R = %0.3f; G = %0.3f\n',wlWDWNormalize,RCMFAtNormWl,GCMFAtNormWl);
    RToGAtNormWlNominal = RCMFAtNormWl/GCMFAtNormWl;

    % We think the Vr/Vg value provided by Wright is the ratio of primary radiance
    % with which each contributes to luminance.  These could be used to scale
    % the tabulated CMFs to what they would have been with radiometrically
    % equated primaries, but we are not doing that.
    wlRIndex = find(wave == wlRPrimary);
    wlGIndex = find(wave == wlGPrimary);
    fprintf('\nVr/Vg = %0.3f\n',VrOverVg);

    %% Vlambda
    %
    % Check that Vlambda is as we think from what's given in the paper,
    % in the sense that it is obtained as Vlambda = R + G.
    %
    % This agrees with Wright's tabulated values to about 0.05% for
    % the average observer.
    derivedVlambda = RGCMF(:,1) + RGCMF(:,2);
    fprintf('Max abs percent devation of tabluated vLambda from tabulated R + G: %0.3f%%\n',100*max(abs(Vlambda(:)-derivedVlambda(:))./Vlambda(:)));

    %% Chromaticity normalizations
    %
    % Check that r + g == 1
    %
    % True to high precision
    rgCheck = rgWDW(:,1) + rgWDW(:,2);
    fprintf('\nMax abs deviation of tabulated r+g from 1: %0.2g\n',max(abs(rgCheck-1)));

    % From Wright's paper, we learn that the r and g CMFs should be WDW
    % normalized to have the same value at the normalizing wavelength of 582.5.
    %
    % We check this.  Seems to be good to about 1%.
    rWDWAtNormWl = interp1(wave,rgWDW(:,1),wlWDWNormalize,interpMethod);
    gWDWAtNormWl = interp1(wave,rgWDW(:,2),wlWDWNormalize,interpMethod);
    fprintf('\nTabulated r and g at %0.2f nm: r = %0.3f; g = %0.3f\n',wlWDWNormalize,rWDWAtNormWl,gWDWAtNormWl);
    fprintf('Difference in r from expected value of 0.5 in percent: %0.2f%%\n',100*abs((rWDWAtNormWl-0.5)/0.5));
    fprintf('Difference in g from expected value of 0.5 in percent: %0.2f%%\n',100*abs((gWDWAtNormWl-0.5)/0.5));

    % Consistency of CMFs and chromaticity/luminance
    %
    % Derive chromaticities from tabulated CMFs and apply WDW scaling.
    % This is in the ballpark of the tabulated r and g values, but
    % not identical. The differences mean that we can't exactly
    % derive the CMFs from the chromatiticies and luminances.
    %
    % We don't know which quantities were primary and which were derived
    % in Wright's tables.
    rRawFromCMF = RGCMF(:,1)./(RGCMF(:,1) + RGCMF(:,2));
    gRawFromCMF = RGCMF(:,2)./(RGCMF(:,1) + RGCMF(:,2));
    rWDWFromCMF = rRawFromCMF*0.5/interp1(wave,rRawFromCMF,wlWDWNormalize,interpMethod);
    gWDWFromCMF = 1-rWDWFromCMF;

    % Derive R and G from Vlambda and chromaticities.
    % These have the right shape, but are not scaled
    % to each other the way Wright scaled them.
    %
    % This is because we started with WDW normalized
    % chromaticities.
    derivedRCMF_Raw = rgWDW(:,1).*Vlambda;
    derivedGCMF_Raw = rgWDW(:,2).*Vlambda;

    % Scale the two back to be as close to the tabulated values
    % as possible
    derivedRCMF = derivedRCMF_Raw*(derivedRCMF_Raw\RGCMF(:,1));
    derivedGCMF = derivedGCMF_Raw*(derivedGCMF_Raw\RGCMF(:,2));

    % Plot to check that it works as set up.
    figure;
    set(gcf,'Position',[500 500 1600 1200]);
    subplot(2,3,1); hold on
    plot(wave,Vlambda,'r-','LineWidth',5);
    plot(wave,derivedVlambda,'b-','LineWidth',3);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
    title([observer ' Derived and Tabulated Luminance'],'FontName','Helvetica','FontSize',18);
    legend({'Tabulated', 'Derived as R + G'},'FontName','Helvetica','FontSize',14,'Location','NorthWest');
    text(550,5,sprintf('Vr/Vg = %0.2f',VrOverVg),'FontName','Helvetica','FontSize',14);
    grid on;

    subplot(2,3,4); hold on
    maxVal = max([Vlambda(:) ; derivedVlambda(:)]);
    plot(Vlambda,derivedVlambda,'ro','MarkerFaceColor','r','MarkerSize',12);
    plot(Vlambda,derivedRCMF + derivedGCMF,'bo','MarkerFaceColor','b','MarkerSize',8);
    plot([0 maxVal],[0 maxVal],'k-','LineWidth',1);
    xlim([0 maxVal]); ylim([0 maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Tabulated vLambda','FontName','Helvetica','FontSize',18);
    ylabel('Derived vLambda','FontName','Helvetica','FontSize',18);
    title([observer ' Derived vs Tabulated Luminance'],'FontName','Helvetica','FontSize',18);
    axis('square');
    legend({'Tabulated R + G','Scaled Derived R + G'},'FontName','Helvetica','FontSize',14,'Location','NorthWest');
    grid on;

    subplot(2,3,2); hold on;
    plot(wave,RGCMF(:,1),'r-','LineWidth',5);
    plot(wave,derivedRCMF,'b-','LineWidth',3);
    plot(wave,RGCMF(:,2),'r-','LineWidth',5);
    plot(wave,derivedGCMF,'b-','LineWidth',3);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
    title([observer ' Derived and Tabulated CMFs'],'FontName','Helvetica','FontSize',18);
    legend({'Tabulated CMFs', 'Scaled Derived CMFs'},'FontName','Helvetica','FontSize',14,'Location','NorthWest');
    grid on;

    subplot(2,3,5); hold on
    maxVal = max([RGCMF(:,1); RGCMF(:,2); derivedRCMF(:) ; derivedGCMF(:)]);
    plot(RGCMF(:,1),derivedRCMF,'ro','MarkerFaceColor','r','MarkerSize',12);
    plot([0 maxVal],[0 maxVal],'k-','LineWidth',1);
    xlim([0 maxVal]); ylim([0 maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Tabulated CMF','FontName','Helvetica','FontSize',18);
    ylabel('Scaled Derived CMF','FontName','Helvetica','FontSize',18);
    axis('square');
    title([observer ' Derived vs Tabulated CMFs']);
    grid on;

    subplot(2,3,3); hold on;
    plot(wave,rgWDW(:,1),'r-','LineWidth',5);
    plot(wave,derivedRCMF_Raw./(derivedRCMF_Raw + derivedGCMF_Raw),'b-','LineWidth',3);
    plot(wave,rWDWFromCMF,'g-','LineWidth',1);
    plot(wave,rgWDW(:,2),'r-','LineWidth',5);
    plot(wave,derivedGCMF_Raw./(derivedRCMF_Raw + derivedGCMF_Raw),'b-','LineWidth',3);
    plot(wave,gWDWFromCMF,'g-','LineWidth',1);
    plot([wlWDWNormalize wlWDWNormalize],[0 1]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel([observer '  rg Chromaticity'],'FontName','Helvetica','FontSize',18);
    ylim([-0.3 1.3]);
    title([observer ' WDW rg'],'FontName','Helvetica','FontSize',18);
    legend({'Tabulated', 'From Derived CMF', 'From Tabulated CMFs'},'FontName','Helvetica','FontSize',14,'Location','NorthWest');
    grid on;

    subplot(2,3,6); hold on
    minVal = -0.3;
    maxVal = 1.3;
    plot(rgWDW(:,1),rWDWFromCMF,'ro','MarkerFaceColor','r','MarkerSize',12);
    plot(rgWDW(:,1),derivedRCMF_Raw./(derivedRCMF_Raw + derivedGCMF_Raw),'go','MarkerFaceColor','g','MarkerSize',6);
    plot([minVal maxVal],[minVal maxVal],'k-','LineWidth',1);
    xlim([minVal maxVal]); ylim([minVal maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Tabulated Chromaticity','FontName','Helvetica','FontSize',18);
    ylabel('Table Derived Chromaticity','FontName','Helvetica','FontSize',18);
    axis('square');
    title([observer ' Derived vs Tabulated Chromaciticities']);
    legend({'Tabulated CMFs', 'Unscaled Derived CMF',},'FontName','Helvetica','FontSize',14,'Location','NorthWest');

    grid on;

    % Save figure
    saveas(gcf,['Wright_' observer '_Check'],'tiff')
end