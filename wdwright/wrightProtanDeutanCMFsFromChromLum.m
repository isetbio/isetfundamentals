% Wright protan and deutan CMFs

%% Initializing
ieInit;

% Define wavelengths we'll use
wave = SToWls([400 10 31]);

%% Load data digitized from Wright's book
%
% rWDW
the_rWDWProtanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwChromRedProtan.mat'));
the_rWDWDeutanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwChromRedDeutan.mat'));
rWDW_Protan = interp1(the_rWDWProtanData.wdwProtanChromRed(:,1),the_rWDWProtanData.wdwProtanChromRed(:,2),wave,'spline',NaN);
rWDW_Deutan = interp1(the_rWDWDeutanData.wdwDeutanChromRed(:,1),the_rWDWDeutanData.wdwDeutanChromRed(:,2),wave,'spline',NaN);

rWDWFig = figure;
subplot(1,2,1); hold on;
plot(the_rWDWProtanData.wdwProtanChromRed(:,1),the_rWDWProtanData.wdwProtanChromRed(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',8);
plot(wave,rWDW_Protan,'r-','LineWidth',2);
title('Protan rWDW');
subplot(1,2,2); hold on;
plot(the_rWDWDeutanData.wdwDeutanChromRed(:,1),the_rWDWDeutanData.wdwDeutanChromRed(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',8);
plot(wave,rWDW_Deutan,'r-','LineWidth',2);
title('Deutan rWDW');

%% Normalization info
Vr_Protan = 100;
Vb_Protan = 7.1;
VbOverVr_Protan = Vb_Protan/Vr_Protan;
Vr_Deutan = 100;
Vb_Deutan = 6.2;
VbOverVr_Deutan = Vb_Deutan/Vr_Deutan;

% Luminance
the_VlambdaProtanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwVlambda_Protan.mat'));
the_VlambdaDeutanData = load(fullfile(iefundamentalsRootPath,'wdwright','wdwVlambda_Deutan.mat'));
Vlambda_Protan = interp1(the_VlambdaProtanData.Wright_Protan_Vlambda(:,1),the_VlambdaProtanData.Wright_Protan_Vlambda(:,2),wave,'spline',NaN);
Vlambda_Deutan = interp1(the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,1),the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,2),wave,'spline',NaN);

lumFig = figure;
subplot(1,2,1); hold on;
plot(the_VlambdaProtanData.Wright_Protan_Vlambda(:,1),the_VlambdaProtanData.Wright_Protan_Vlambda(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',8);
plot(wave,Vlambda_Protan,'r-','LineWidth',2);
title('Protan Vlambda');
subplot(1,2,2); hold on;
plot(the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,1),the_VlambdaDeutanData.Wright_Deutan_Vlambda(:,2), ...
    'ro','MarkerFaceColor','r','MarkerSize',8);
plot(wave,Vlambda_Deutan,'r-','LineWidth',2);
title('Deutan Vlambda');

%% Wright primary wavelengths
%
% These are the primaries for the tritanope matches
RPrimaryWl = 650;
BPrimaryWl = 460;
RPrimaryWlIndex = find(wave == RPrimaryWl);
BPrimaryWlIndex = find(wave == BPrimaryWl);
wdwNormWl = 494;

% Find R and B from rWDW,and Vlambda
%
% The search method was in intermediate step.  I will
% delete once my understanding of all this is a little
% better, or improve if that is what is needed.
knownWDWScaleFactor = true;
if knownWDWScaleFactor
    W1_Protan = 1/VbOverVr_Protan;
    [R_Protan_Derived,B_Protan_Derived] = WDWChromVlambdaToCMFFun(W1_Protan,wave,rWDW_Protan,Vlambda_Protan);  
end
VlambdaFromRplusB_Protan_Derived = R_Protan_Derived + B_Protan_Derived;
if knownWDWScaleFactor
    W1_Deutan = 1/VbOverVr_Deutan;
    [R_Deutan_Derived,B_Deutan_Derived] = WDWChromVlambdaToCMFFun(W1_Deutan,wave,rWDW_Deutan,Vlambda_Deutan);  
end
VlambdaFromRplusB_Deutan_Derived = R_Deutan_Derived + B_Deutan_Derived;

% Load in tabulated CMFs
theR_Protan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','ProtanCMFRed.mat'));
R_Protan_Tabulated = interp1(theR_Protan_Data.ProtanCMFRed(:,1),theR_Protan_Data.ProtanCMFRed(:,2),wave,'spline',NaN);
theB_Protan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','ProtanCMFBluex5.mat'));
B_Protan_Tabulated = interp1(theB_Protan_Data.ProtanCMFBluex5(:,1),theB_Protan_Data.ProtanCMFBluex5(:,2),wave,'spline',NaN)/5;
VlambdaFromRplusB_Protan_Tabulated = R_Protan_Tabulated + B_Protan_Tabulated;

theR_Deutan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','DeutanCMFRed.mat'));
R_Deutan_Tabulated = interp1(theR_Deutan_Data.DeutanCMFRed(:,1),theR_Deutan_Data.DeutanCMFRed(:,2),wave,'spline',NaN);
theB_Deutan_Data = load(fullfile(iefundamentalsRootPath,'wdwright','DeutanCMFBluex5.mat'));
B_Deutan_Tabulated = interp1(theB_Deutan_Data.DeutanCMFBluex5(:,1),theB_Deutan_Data.DeutanCMFBluex5(:,2),wave,'spline',NaN)/5;
VlambdaFromRplusB_Deutan_Tabulated = R_Deutan_Tabulated + B_Deutan_Tabulated;

% Get Vlambda as sum or R + B and add to plot as a check
figure(lumFig);
subplot(1,2,1);
plot(wave,VlambdaFromRplusB_Protan_Derived,'k-','LineWidth',2);
plot(wave,VlambdaFromRplusB_Protan_Tabulated,'k:','LineWidth',2);
ylim([0 1.2]);
xlabel('Wavelength (nm)');
ylabel('Luminance');
subplot(1,2,2);
plot(wave,VlambdaFromRplusB_Deutan_Derived,'k-','LineWidth',2);
plot(wave,VlambdaFromRplusB_Deutan_Tabulated,'k:','LineWidth',2);
ylim([0 1.2]);
xlabel('Wavelength (nm)');
ylabel('Luminance');

% Plot derived CMFs
cmfFig = figure;
subplot(1,2,1); hold on;
plot(wave,R_Protan_Derived,'r-','LineWidth',3);
plot(wave,R_Protan_Tabulated,'k-','LineWidth',1);
plot(wave,5*B_Protan_Derived,'b-','LineWidth',3);
plot(wave,5*B_Protan_Tabulated,'k-','LineWidth',1);
xlabel('Wavelength (nm)');
ylabel('CMF');
title('Protan CMFs');
subplot(1,2,2); hold on;
plot(wave,R_Deutan_Derived,'r-','LineWidth',3);
plot(wave,R_Deutan_Tabulated,'k-','LineWidth',1);
plot(wave,5*B_Deutan_Derived,'b-','LineWidth',3);
plot(wave,5*B_Deutan_Tabulated,'k-','LineWidth',1);
xlabel('Wavelength (nm)');
ylabel('CMF');
title('Deutan CMFs');

save(fullfile(iefundamentalsRootPath,'wdwright','Wright_ProtanDeutanDerivedCMFs'), ...
    'wave', ...
    'R_Protan_Derived','B_Protan_Derived','R_Deutan_Derived','B_Deutan_Derived', ...
    'R_Protan_Tabulated','B_Protan_Tabulated','R_Deutan_Tabulated','B_Deutan_Tabulated');

    % % Generate WDW scaled CMFs for computation of check r_WDW and g_WDW.
    % RAtNormWl_Derived = interp1(wave,R_Derived,wdwNormWl,interpMethod);
    % GAtNormWl_Derived = interp1(wave,B_Derived,wdwNormWl,interpMethod);
    % fprintf('Derived R and G at %0.2f nm; R = %0.3f; G = %0.3f\n', ...
    %     wdwNormWl,RAtNormWl_Derived,GAtNormWl_Derived);
    % RToGAtNormWl_Derived(oo) = RAtNormWl_Derived/GAtNormWl_Derived;
    % RWDW_Derived = R_Derived/RToGAtNormWl_Derived(oo);
    % GWDW_Derived = B_Derived;
    % rWDW_FromDerivedCMF  = RWDW_Derived./(RWDW_Derived + GWDW_Derived);
    % gWDW_FromDerivedCMF  = GWDW_Derived./(RWDW_Derived + GWDW_Derived);

    % % Scale the two back to be as close to the tabulated values
    % % as possible
    % CMFScalarDerivedToTabulated(oo) = [R_Derived ; B_Derived]\[RG_Tabulated(:,1) ; RG_Tabulated(:,2)];
    % R_DerivedScaledToTabulated = R_Derived*CMFScalarDerivedToTabulated(oo);
    % G_DerivedScaledToTabulated = B_Derived*CMFScalarDerivedToTabulated(oo);
    % 
    % % In the end, we only care about the CMFs up to linear transformation
    % % Find best linear transform from derived to tabulated
    % M_DerivedToTabulated = [R_Derived B_Derived]\[RG_Tabulated(:,1) RG_Tabulated(:,2)];
    % RG_DerivedLinearToTabulated = [R_Derived B_Derived]*M_DerivedToTabulated;
    % R_DerivedLinearToTabulated = RG_DerivedLinearToTabulated(:,1);
    % G_DerivedLinearToTabulated = RG_DerivedLinearToTabulated(:,2);
    % 
    % % Scale factor to bring our WDW scaled derived CMFs into alignment with 
    % % our WDW scaled tabulated CMFs.
    % WDWCMFScalarDerivedToTabulated(oo) = [RWDW_Derived ; GWDW_Derived]\[RWDW_Tabulated ; GWDW_Tabulated];

    % % Plot to check that it all works
    % figure;
    % set(gcf,'Position',[500 500 1600 1200]);
    % subplot(2,4,1); hold on
    % plot(wave,Vlambda_Tabulated,'r-','LineWidth',6);
    % plot(wave,VlambdaFromRplusG_Tabulated,'b-','LineWidth',4);
    % plot(wave,VlambdaFromRplusG_Tabulated,'g-','LineWidth',2);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    % ylabel('Primary Intensity','FontName','Helvetica','FontSize',18);
    % title([observer ' Derived and Tabulated Luminance'],'FontName','Helvetica','FontSize',14);
    % legend({'Tabulated', 'Tabulated R + G', 'Derived R + G'},'FontName','Helvetica','FontSize',10,'Location','NorthWest');
    % text(550,5,sprintf('Vr/Vg = %0.2f',VrOverVg_Tabulated(oo)),'FontName','Helvetica','FontSize',10);
    % grid on;
    % 
    % subplot(2,4,5); hold on
    % maxVal = max([Vlambda_Tabulated(:) ; VlambdaFromRplusG_Tabulated(:)]);
    % plot(Vlambda_Tabulated,VlambdaFromRplusG_Tabulated,'ro','MarkerFaceColor','b','MarkerSize',12);
    % plot(Vlambda_Tabulated,VlambdaFromRplusB_Derived,'bo','MarkerFaceColor','g','MarkerSize',8);
    % plot([0 maxVal],[0 maxVal],'k-','LineWidth',1);
    % xlim([0 maxVal]); ylim([0 maxVal]);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Tabulated vLambda','FontName','Helvetica','FontSize',18);
    % ylabel('Derived vLambda','FontName','Helvetica','FontSize',18);
    % title([observer ' Derived vs Tabulated Luminance'],'FontName','Helvetica','FontSize',14);
    % axis('square');
    % legend({'Tabulated R + G','Derived R + G'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    % grid on;
    % 
    % subplot(2,4,2); hold on;
    % plot(wave,RG_Tabulated(:,1),'r-','LineWidth',6);
    % plot(wave,R_DerivedScaledToTabulated,'b-','LineWidth',4);
    % plot(wave,R_DerivedLinearToTabulated,'g-','LineWidth',2);
    % plot(wave,RG_Tabulated(:,2),'r-','LineWidth',6);
    % plot(wave,G_DerivedScaledToTabulated,'b-','LineWidth',4);
    % plot(wave,G_DerivedLinearToTabulated,'g-','LineWidth',2);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    % ylabel('CMF','FontName','Helvetica','FontSize',18);
    % title([observer ' Tabulated and Derived CMFs'],'FontName','Helvetica','FontSize',14);
    % legend({'Tabulated', 'Derived, Scaled', 'Derived, LinTran'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    % grid on;
    % 
    % subplot(2,4,6); hold on
    % maxVal = max([RG_Tabulated(:,1); RG_Tabulated(:,2); R_Derived(:) ; B_Derived(:)]);
    % plot(RG_Tabulated(:,1),R_DerivedScaledToTabulated,'bo','MarkerFaceColor','b','MarkerSize',12);
    % plot(RG_Tabulated(:,1),R_DerivedLinearToTabulated,'go','MarkerFaceColor','g','MarkerSize',8);
    % plot(RG_Tabulated(:,2),G_DerivedScaledToTabulated,'bo','MarkerFaceColor','b','MarkerSize',12);
    % plot(RG_Tabulated(:,2),G_DerivedLinearToTabulated,'go','MarkerFaceColor','g','MarkerSize',8);
    % plot([0 maxVal],[0 maxVal],'k-','LineWidth',1);
    % xlim([0 maxVal]); ylim([0 maxVal]);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Tabulated CMF','FontName','Helvetica','FontSize',18);
    % ylabel('Derived CMF','FontName','Helvetica','FontSize',18);
    % axis('square');
    % title([observer ' Derived vs Tabulated CMFs'],'FontName','Helvetica','FontSize',14);
    % legend({'Derived, Scaled', 'Derived, LinTran'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    % grid on;
    % 
    % subplot(2,4,3); hold on;
    % plot(wave,rgWDW_Tabulated(:,1),'r-','LineWidth',6);
    % plot(wave,rWDW_FromTabulatedCMF,'b-','LineWidth',4);
    % plot(wave,rWDW_FromDerivedCMF,'g-','LineWidth',2);
    % plot(wave,rgWDW_Tabulated(:,2),'r-','LineWidth',6);
    % plot(wave,gWDW_FromTabulatedCMF,'b-','LineWidth',4);
    % plot(wave,gWDW_FromDerivedCMF,'g-','LineWidth',2);
    % plot([wdwNormWl wdwNormWl],[0 1]);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    % ylabel(['WDW rg'],'FontName','Helvetica','FontSize',18);
    % ylim([-0.3 1.3]);
    % title([observer ' WDW rg'],'FontName','Helvetica','FontSize',14);
    % legend({'Tabulated', 'From Tabulated CMF', 'From Derived CMF'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    % grid on;
    % 
    % subplot(2,4,7); hold on
    % minVal = -0.3;
    % maxVal = 1.3;
    % plot(rgWDW_Tabulated(:,1),rWDW_FromTabulatedCMF,'bo','MarkerFaceColor','b','MarkerSize',12);
    % plot(rgWDW_Tabulated(:,1),rWDW_FromDerivedCMF,'go','MarkerFaceColor','g','MarkerSize',8);
    % % plot(rgWDW_Tabulated(:,2),gWDW_FromTabulatedCMF,'bo','MarkerFaceColor','b','MarkerSize',12);
    % % plot(rgWDW_Tabulated(:,2),gWDW_FromDerivedCMF,'go','MarkerFaceColor','g','MarkerSize',8);
    % plot([minVal maxVal],[minVal maxVal],'k-','LineWidth',1);
    % xlim([minVal maxVal]); ylim([minVal maxVal]);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Tabulated WDW rg','FontName','Helvetica','FontSize',18);
    % ylabel('Derived WDW rg','FontName','Helvetica','FontSize',18);
    % axis('square');
    % title([observer ' WDW rg'],'FontName','Helvetica','FontSize',14);
    % legend({'From Tabulated CMFs', 'From Derived CMF',},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    % grid on;
    % 
    % subplot(2,4,4); hold on;
    % maxVal = max([RWDW_Tabulated ; RWDW_Derived ; GWDW_Tabulated ; GWDW_Derived ]);
    % plot(wave,RWDW_Tabulated,'r-','LineWidth',6);
    % plot(wave,WDWCMFScalarDerivedToTabulated(oo)*RWDW_Derived,'b-','LineWidth',4);
    % plot(wave,RWDW_Derived,'g-','LineWidth',1);
    % plot(wave,GWDW_Tabulated,'r-','LineWidth',6);
    % plot(wave,WDWCMFScalarDerivedToTabulated(oo)*GWDW_Derived,'b-','LineWidth',4);
    % plot(wave,GWDW_Derived,'g-','LineWidth',1);
    % plot([wdwNormWl wdwNormWl],[0 maxVal]);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Wavelength (nm)','FontName','Helvetica','FontSize',18);
    % ylabel(['WDW RG'],'FontName','Helvetica','FontSize',18);
    % title([observer ' WDW RG'],'FontName','Helvetica','FontSize',14);
    % legend({'Tabulated', 'Derived, Scaled', 'Derived'},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    % grid on;
    % 
    % subplot(2,4,8); hold on
    % minVal = -0.3;
    % maxVal = 1.3;
    % x = RWDW_Tabulated./(RWDW_Tabulated+GWDW_Tabulated);
    % y = RWDW_Derived./(RWDW_Derived+GWDW_Derived);
    % plot(x,y,'bo','MarkerFaceColor','b','MarkerSize',12);
    % plot([minVal maxVal],[minVal maxVal],'k-','LineWidth',1);
    % xlim([minVal maxVal]); ylim([minVal maxVal]);
    % set(gca,'FontName','Helvetica','FontSize',16);
    % xlabel('Tabulated WDW r','FontName','Helvetica','FontSize',18);
    % ylabel('Derived WDW r','FontName','Helvetica','FontSize',18);
    % axis('square');
    % title([observer ' WDW rg'],'FontName','Helvetica','FontSize',14);
    % %legend({'From Tabulated CMFs', 'From Derived CMF',},'FontName','Helvetica','FontSize',8,'Location','NorthWest');
    % grid on;

    % Save figure
    %saveas(gcf,fullfile(iefundamentalsRootPath,'wdwright',['Wright_Tritan_' observer '_Check']),'tiff');

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
    if (~isnan(rWDW(ww)) & ~isnan(Vlambda(ww)))
        R(ww) = fsolve(@(Rdummy)(rWDW(ww)-(Rdummy/W1)/(Rdummy/W1 + Vlambda(ww) - Rdummy)),Vlambda(ww)/2,options);
    else
        R(ww) = NaN;
    end
end
R = R';
G = Vlambda - R;

end