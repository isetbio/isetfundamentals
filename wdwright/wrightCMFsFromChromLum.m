% Wright 1952 data analysis
%
% We think Wright's 1952 data are tabulated Vlambda, r and g WDW chromaticities,
% and R and G CMFs in luminance units.  This belief is in part based on
% checks performed here.  We also think VrOverVg in the tables is 
% the WDW normalization constant W1 (where W1 is as defined by W & S's
% treatment of the WDW normalization).
%
% Text in the article says that the CMFs were derived from the
% chromaticities and luminance.
%
% Key is that you need to know the normalization constant to derive the
% CMFs from the WDW chromaticities and Vlambda.
%
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
observers = {'ObsA' 'ObsB' 'ObsC' 'ObsD' 'ObsE' 'ObsF' 'Avg'};
observerIndices = [ 1 2 3 4 5 6 NaN];
%observers = {'ObsC' 'ObsD'};
%observerIndices = [3 4];
for oo = 1:length(observers)
    observer = observers{oo};
    fprintf('\n*** Observer %s*** \n',observer);
    switch (observer)
        case 'Avg'
            wave = theWrightData.obsAverage.wave;
            RG_Tabulated = theWrightData.obsAverage.CMF;
            rgWDW_Tabulated = theWrightData.obsAverage.rg;
            Vlambda_Tabulated = theWrightData.obsAverage.Vlambda;
            VrOverVg_Tabulated(oo) = theWrightData.obsAverage.VrOverVg;

        case {'ObsA' 'ObsB' 'ObsC' 'ObsD' 'ObsE' 'ObsF'}
            ii = observerIndices(oo);
            wave = theWrightData.obs{ii}.wave;
            RG_Tabulated = theWrightData.obs{ii}.CMF;
            rgWDW_Tabulated = theWrightData.obs{ii}.rg;
            Vlambda_Tabulated = theWrightData.obs{ii}.Vlambda;
            VrOverVg_Tabulated(oo) = theWrightData.obs{ii}.VrOverVg;   % Observer specific
        otherwise
            error('Need to add case for requested observer');
    end

    %% Wright primary wavelengths
    %
    % These are the primaries for the tritanope matches
    RPrimaryWl = 650;
    GPrimaryWl = 480;
    RPrimaryWlIndex = find(wave == RPrimaryWl);
    GPrimaryWlIndex = find(wave == GPrimaryWl);

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
    % We believe the normalization factors applied to the R CMF are the
    % values 1/VrOverVg, where VrOverVg are tabulated by Wright.
    %
    % This all makes sense, except you need decide Wright didn't
    % actually mean it when he wrote in the text:
    %    "The radiations 0.65μ and 0.48μ were chosen as the matching stimuli
    %    and their units were adjusted to be equal in the match on a
    %    monochromatic yellow at wavelength 0.5825μ."
    % If that were the case, R and G would not sum to Vlambda.
    wdwNormWl = 582.5;

    % This calculation shows the tabulated CMFs do not have R == G at the
    % normalizing wavelength.
    %
    % Indeed, we think these CMFs are with respect to the primaries in photometric
    % equality, so that VR + VG = Vlambda.  In general we can't have both
    % this be true and have the R and G CMFs normalized to be equal at
    % a particular wavelength.
    interpMethod = 'linear';
    RAtNormWl_Tabulated = interp1(wave,RG_Tabulated(:,1),wdwNormWl,interpMethod);
    GAtNormWl_Tabulated = interp1(wave,RG_Tabulated(:,2),wdwNormWl,interpMethod);
    fprintf('Tabulated R and G at %0.2f nm; R = %0.3f; G = %0.3f\n',wdwNormWl,RAtNormWl_Tabulated,GAtNormWl_Tabulated);
    RToGAtNormWl_Tabulated(oo) = RAtNormWl_Tabulated/GAtNormWl_Tabulated;

    % We think the Vr/Vg value provided by Wright is the ratio of primary radiance
    % with which each contributes to luminance.  These could be used to scale
    % the tabulated CMFs to what they would have been with radiometrically
    % equated primaries, but we are not doing that.
    fprintf('\nVr/Vg = %0.3f\n',VrOverVg_Tabulated);

    %% Vlambda
    %
    % Check that Vlambda is as we think from what's given in the paper,
    % in the sense that it is obtained as Vlambda = R + G.
    %
    % This agrees with Wright's tabulated values to about 0.05% for
    % the average observer.
    VlambdaFromRplusG_Tabulated = RG_Tabulated(:,1) + RG_Tabulated(:,2);
    fprintf('Max abs percent devation of tabluated vLambda from tabulated R + G: %0.3f%%\n',100*max(abs(Vlambda_Tabulated(:)-VlambdaFromRplusG_Tabulated(:))./Vlambda_Tabulated(:)));

    %% Chromaticity normalizations
    %
    % Check that r + g == 1
    %
    % True to high precision
    rgWDWSumCheck_Tabulated = rgWDW_Tabulated(:,1) + rgWDW_Tabulated(:,2);
    fprintf('\nMax abs deviation of tabulated r+g from 1: %0.2g\n',max(abs(rgWDWSumCheck_Tabulated-1)));

    % From Wright's paper, we learn that the r and g CMFs should be WDW
    % normalized to have the same value at the normalizing wavelength of 582.5.
    %
    % We check this.  Seems to be good to about 1%.
    rWDWAtNormWl = interp1(wave,rgWDW_Tabulated(:,1),wdwNormWl,interpMethod);
    gWDWAtNormWl = interp1(wave,rgWDW_Tabulated(:,2),wdwNormWl,interpMethod);
    fprintf('\nTabulated r and g at %0.2f nm: r = %0.3f; g = %0.3f\n',wdwNormWl,rWDWAtNormWl,gWDWAtNormWl);
    fprintf('Difference in r from expected value of 0.5 in percent: %0.2f%%\n',100*abs((rWDWAtNormWl-0.5)/0.5));
    fprintf('Difference in g from expected value of 0.5 in percent: %0.2f%%\n',100*abs((gWDWAtNormWl-0.5)/0.5));

    % Derive chromaticities from tabulated CMFs after applying WDW scaling.
    % These should be consistent with tabulated WDW chromaticities, and
    % as the plot will show, they are.
    %
    % Scale the R CMF from the table to be equal to the G CMF from the
    % table at the normalizing wavelength, and then compute chromaticities.
    %RWDW_Tabulated = RG_Tabulated(:,1)/RToGAtNormWl_Tabulated(oo);
    RWDW_Tabulated = RG_Tabulated(:,1)/VrOverVg_Tabulated(oo);
    GWDW_Tabulated = RG_Tabulated(:,2);
    rWDW_FromTabulatedCMF  = RWDW_Tabulated./(RWDW_Tabulated + GWDW_Tabulated);
    gWDW_FromTabulatedCMF  = GWDW_Tabulated./(RWDW_Tabulated + GWDW_Tabulated);

    % Find R and G from rWDW, gWDW, and Vlambda
    %
    % The search method was in intermediate step.  I will
    % delete once my understanding of all this is a little
    % better, or improve if that is what is needed.
    knownWDWScaleFactor = true;
    if knownWDWScaleFactor
        % If we know that RWDW = R/W1, we can solve for R and G.
        % We believe for Wright 1952, W1 = VrOverVg_Tabulated.
        % So we call the routine that does the work and voila.
        W1 = VrOverVg_Tabulated(oo);
        [R_Derived,G_Derived] = WDWChromVlambdaToCMFFun(W1,wave,rgWDW_Tabulated(:,1),Vlambda_Tabulated);  
    else
        % If we don't know the scale factor relating RWDW and R,
        % we can't derive R and G uniquely. Different choices
        % of the scale factor lead to different solutions consistent 
        % with the tabulated rWDW and Vlambda. 
        % 
        % You can verify this ambiguity by setting W1 to different constants
        % below, running the script, and observing that you get quite different
        % CMFs for any given observer, while matching the WDW r and g and having
        % R + G sum to Vlambda.
        % 
        % If we don't know the scale factor, we can't do much other than
        % make one up and hope for the best.  Here we use 1.28, which is
        % the value Wright 1952 provides for the average tritanope.
        W1 = 1.28;
        [R_Derived,G_Derived] = WDWChromVlambdaToCMFFun(W1,wave,rgWDW_Tabulated(:,1),Vlambda_Tabulated); 
    end
    VlambdaFromRplusG_Derived = R_Derived + G_Derived;

    % Generate WDW scaled CMFs for computation of check r_WDW and g_WDW.
    RAtNormWl_Derived = interp1(wave,R_Derived,wdwNormWl,interpMethod);
    GAtNormWl_Derived = interp1(wave,G_Derived,wdwNormWl,interpMethod);
    fprintf('Derived R and G at %0.2f nm; R = %0.3f; G = %0.3f\n', ...
        wdwNormWl,RAtNormWl_Derived,GAtNormWl_Derived);
    RToGAtNormWl_Derived(oo) = RAtNormWl_Derived/GAtNormWl_Derived;
    RWDW_Derived = R_Derived/RToGAtNormWl_Derived(oo);
    GWDW_Derived = G_Derived;
    rWDW_FromDerivedCMF  = RWDW_Derived./(RWDW_Derived + GWDW_Derived);
    gWDW_FromDerivedCMF  = GWDW_Derived./(RWDW_Derived + GWDW_Derived);

    % Scale the two back to be as close to the tabulated values
    % as possible
    CMFScalarDerivedToTabulated(oo) = [R_Derived ; G_Derived]\[RG_Tabulated(:,1) ; RG_Tabulated(:,2)];
    R_DerivedScaledToTabulated = R_Derived*CMFScalarDerivedToTabulated(oo);
    G_DerivedScaledToTabulated = G_Derived*CMFScalarDerivedToTabulated(oo);

    % In the end, we only care about the CMFs up to linear transformation
    % Find best linear transform from derived to tabulated
    M_DerivedToTabulated = [R_Derived G_Derived]\[RG_Tabulated(:,1) RG_Tabulated(:,2)];
    RG_DerivedLinearToTabulated = [R_Derived G_Derived]*M_DerivedToTabulated;
    R_DerivedLinearToTabulated = RG_DerivedLinearToTabulated(:,1);
    G_DerivedLinearToTabulated = RG_DerivedLinearToTabulated(:,2);

    % Scale factor to bring our WDW scaled derived CMFs into alignment with 
    % our WDW scaled tabulated CMFs.
    WDWCMFScalarDerivedToTabulated(oo) = [RWDW_Derived ; GWDW_Derived]\[RWDW_Tabulated ; GWDW_Tabulated];

    % Plot to check that it all works
    figure;
    set(gcf,'Position',[500 500 1600 1200]);
    subplot(2,4,1); hold on
    plot(wave,Vlambda_Tabulated,'r-','LineWidth',6);
    plot(wave,VlambdaFromRplusG_Tabulated,'b-','LineWidth',4);
    plot(wave,VlambdaFromRplusG_Tabulated,'g-','LineWidth',2);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
    title([observer ' Derived and Tabulated Luminance'],'FontName','Helvetica','FontSize',14);
    legend({'Tabulated', 'Tabulated R + G', 'Derived R + G'},'FontName','Helvetica','FontSize',10,'Location','NorthWest');
    text(550,5,sprintf('Vr/Vg = %0.2f',VrOverVg_Tabulated(oo)),'FontName','Helvetica','FontSize',10);
    grid on;

    subplot(2,4,5); hold on
    maxVal = max([Vlambda_Tabulated(:) ; VlambdaFromRplusG_Tabulated(:)]);
    plot(Vlambda_Tabulated,VlambdaFromRplusG_Tabulated,'ro','MarkerFaceColor','b','MarkerSize',12);
    plot(Vlambda_Tabulated,VlambdaFromRplusG_Derived,'bo','MarkerFaceColor','g','MarkerSize',8);
    plot([0 maxVal],[0 maxVal],'k-','LineWidth',1);
    xlim([0 maxVal]); ylim([0 maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Tabulated vLambda','FontName','Helvetica','FontSize',18);
    ylabel('Derived vLambda','FontName','Helvetica','FontSize',18);
    title([observer ' Derived vs Tabulated Luminance'],'FontName','Helvetica','FontSize',14);
    axis('square');
    legend({'Tabulated R + G','Derived R + G'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    grid on;

    subplot(2,4,2); hold on;
    plot(wave,RG_Tabulated(:,1),'r-','LineWidth',6);
    plot(wave,R_DerivedScaledToTabulated,'b-','LineWidth',4);
    plot(wave,R_DerivedLinearToTabulated,'g-','LineWidth',2);
    plot(wave,RG_Tabulated(:,2),'r-','LineWidth',6);
    plot(wave,G_DerivedScaledToTabulated,'b-','LineWidth',4);
    plot(wave,G_DerivedLinearToTabulated,'g-','LineWidth',2);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel('CMF','FontName','Helvetica','FontSize',18);
    title([observer ' Tabulated and Derived CMFs'],'FontName','Helvetica','FontSize',14);
    legend({'Tabulated', 'Derived, Scaled', 'Derived, LinTran'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    grid on;

    subplot(2,4,6); hold on
    maxVal = max([RG_Tabulated(:,1); RG_Tabulated(:,2); R_Derived(:) ; G_Derived(:)]);
    plot(RG_Tabulated(:,1),R_DerivedScaledToTabulated,'bo','MarkerFaceColor','b','MarkerSize',12);
    plot(RG_Tabulated(:,1),R_DerivedLinearToTabulated,'go','MarkerFaceColor','g','MarkerSize',8);
    plot(RG_Tabulated(:,2),G_DerivedScaledToTabulated,'bo','MarkerFaceColor','b','MarkerSize',12);
    plot(RG_Tabulated(:,2),G_DerivedLinearToTabulated,'go','MarkerFaceColor','g','MarkerSize',8);
    plot([0 maxVal],[0 maxVal],'k-','LineWidth',1);
    xlim([0 maxVal]); ylim([0 maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Tabulated CMF','FontName','Helvetica','FontSize',18);
    ylabel('Derived CMF','FontName','Helvetica','FontSize',18);
    axis('square');
    title([observer ' Derived vs Tabulated CMFs'],'FontName','Helvetica','FontSize',14);
    legend({'Derived, Scaled', 'Derived, LinTran'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    grid on;

    subplot(2,4,3); hold on;
    plot(wave,rgWDW_Tabulated(:,1),'r-','LineWidth',6);
    plot(wave,rWDW_FromTabulatedCMF,'b-','LineWidth',4);
    plot(wave,rWDW_FromDerivedCMF,'g-','LineWidth',2);
    plot(wave,rgWDW_Tabulated(:,2),'r-','LineWidth',6);
    plot(wave,gWDW_FromTabulatedCMF,'b-','LineWidth',4);
    plot(wave,gWDW_FromDerivedCMF,'g-','LineWidth',2);
    plot([wdwNormWl wdwNormWl],[0 1]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel(['WDW rg'],'FontName','Helvetica','FontSize',18);
    ylim([-0.3 1.3]);
    title([observer ' WDW rg'],'FontName','Helvetica','FontSize',14);
    legend({'Tabulated', 'From Tabulated CMF', 'From Derived CMF'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    grid on;

    subplot(2,4,7); hold on
    minVal = -0.3;
    maxVal = 1.3;
    plot(rgWDW_Tabulated(:,1),rWDW_FromTabulatedCMF,'bo','MarkerFaceColor','b','MarkerSize',12);
    plot(rgWDW_Tabulated(:,1),rWDW_FromDerivedCMF,'go','MarkerFaceColor','g','MarkerSize',8);
    % plot(rgWDW_Tabulated(:,2),gWDW_FromTabulatedCMF,'bo','MarkerFaceColor','b','MarkerSize',12);
    % plot(rgWDW_Tabulated(:,2),gWDW_FromDerivedCMF,'go','MarkerFaceColor','g','MarkerSize',8);
    plot([minVal maxVal],[minVal maxVal],'k-','LineWidth',1);
    xlim([minVal maxVal]); ylim([minVal maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Tabulated WDW rg','FontName','Helvetica','FontSize',18);
    ylabel('Derived WDW rg','FontName','Helvetica','FontSize',18);
    axis('square');
    title([observer ' WDW rg'],'FontName','Helvetica','FontSize',14);
    legend({'From Tabulated CMFs', 'From Derived CMF',},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    grid on;

    subplot(2,4,4); hold on;
    maxVal = max([RWDW_Tabulated ; RWDW_Derived ; GWDW_Tabulated ; GWDW_Derived ]);
    plot(wave,RWDW_Tabulated,'r-','LineWidth',6);
    plot(wave,WDWCMFScalarDerivedToTabulated(oo)*RWDW_Derived,'b-','LineWidth',4);
    plot(wave,RWDW_Derived,'g-','LineWidth',1);
    plot(wave,GWDW_Tabulated,'r-','LineWidth',6);
    plot(wave,WDWCMFScalarDerivedToTabulated(oo)*GWDW_Derived,'b-','LineWidth',4);
    plot(wave,GWDW_Derived,'g-','LineWidth',1);
    plot([wdwNormWl wdwNormWl],[0 maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    ylabel(['WDW RG'],'FontName','Helvetica','FontSize',18);
    title([observer ' WDW RG'],'FontName','Helvetica','FontSize',14);
    legend({'Tabulated', 'Derived, Scaled', 'Derived'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    grid on;

    subplot(2,4,8); hold on
    minVal = -0.3;
    maxVal = 1.3;
    x = RWDW_Tabulated./(RWDW_Tabulated+GWDW_Tabulated);
    y = RWDW_Derived./(RWDW_Derived+GWDW_Derived);
    plot(x,y,'bo','MarkerFaceColor','b','MarkerSize',12);
    plot([minVal maxVal],[minVal maxVal],'k-','LineWidth',1);
    xlim([minVal maxVal]); ylim([minVal maxVal]);
    set(gca,'FontName','Helvetica','FontSize',16);
    xlabel('Tabulated WDW r','FontName','Helvetica','FontSize',18);
    ylabel('Derived WDW r','FontName','Helvetica','FontSize',18);
    axis('square');
    title([observer ' WDW rg'],'FontName','Helvetica','FontSize',14);
    %legend({'From Tabulated CMFs', 'From Derived CMF',},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    grid on;

    % Save figure
    saveas(gcf,['Wright_' observer '_Check'],'tiff')
end

function [R,G] = WDWChromVlambdaToCMFFun(W1,wls,rWDW,Vlambda)
% Given W1, find R and G from rWDW and Vlambda
%
% We know:
%   R_WDW = (R/W1)
%   G_WDW = G
%   R + G = Vlamda
%   r_WDW = R_WDW/(R_WDW + G_WDW) = (R/W1)/(R/W1 + G) = (R/W1)/(R/W1 + Vlambda - R)
%
% At each wavelength, solve for R given r_WDW, Vlamda, and W1. 

% Use fsolve to find R and G at each wavelength, given W1, r_WDW and
% Vlambda at each wavelength.close all
options = optimoptions('fsolve','Display','none');
for ww = 1:length(wls)
    R(ww) = fsolve(@(Rdummy)(rWDW(ww)-(Rdummy/W1)/(Rdummy/W1 + Vlambda(ww) - Rdummy)),Vlambda(ww)/2,options);
end
R = R';
G = Vlambda - R;

end