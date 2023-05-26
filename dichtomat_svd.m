%% Example script showing a generalization of the subspace method for the case when
%% the two dichromats do not share exactly a cone fundamental. 
% The script adds deformation and noise to the cone fundamentals
%
% TG 2023-04-01:
% This script is stochastic. Run this several times to see the difference.
% Most of the time the reconstruction is very satisfactory. In other cases
% it is terrible for some cones.
% I need to think a bit more where this comes from. Probably because randn
% gives very big numbers sometimes.
%
% 
% Created By Thomas Goossens 



close all;
%% Options
noiseFlag=1;
noiseStd=0.05;
%% Construct three gaussians which act as the LMS cone fundamentals
x=linspace(350,800,100);
n=@(A)A/max(abs(A(:))); % normalize
l=n(normpdf(x,700,80)');
m=n(normpdf(x,650,80)');
s=n(normpdf(x,450,80)');
figure;
plot(x,l,x,m,x,s)


%% Make a mixture to obtain color matching curves
Cp= randn(2);
Cd= randn(2);
Ct= randn(2);

P=[m s]*Cp;
D=[l s]*Cd;
T=[l m]*Ct;

%% Obtain color matching curves for a different individual
% Perturb each cone fundamental because each individual is different
addnoise =@(x) x+noiseFlag*noiseStd*randn(size(x));
lnew=n(addnoise(l+2*sqrt(l)))
mnew=n(addnoise(m+m.^2))
snew=n(addnoise((s+0.2*(4*s.^3))))

% Contruct the new color matching functions
Pn=[addnoise(m) addnoise(s)]*Cp;
Dn=[addnoise(l) snew]*Cd;
Tn=[lnew mnew]*Ct;


%% Demonstrate that we can exactly recover the S fundamental using the null space
Z=null([P D])
figure();
hold on
plot(x,abs(n(P*Z(1:2,1))),'linewidth',2)
plot(x,s,'r--')
legend('Reconstruction','S-cone')

%% Demonstrate that we can exactly recover the S fundamental using the null space
figure

% First row: show the color matching functions for reach type of dichromat
subplot(331),plot(x,Pn); title('P')
subplot(332),plot(x,Dn);title('D')
subplot(333),plot(x,Tn);title('T')

legend('CMF1',"CMF2")

% Secondrow: show the L,M,S and their perturbations
subplot(334),plot(x,l,x,lnew); title('L')
subplot(335),plot(x,m,x,mnew); title('M')
subplot(336),plot(x,s,x,snew); title('S')
legend('cone',"cone'")

% Reconstruct the LMS cones using the SVD approach
% Note that in the current formulation we obtain two estimates: one
% expressed in the column spaces of both dichromats.
%%% Reconstruct L
subplot(3,3,7); hold on
[U,S,V]=svd([Dn Tn])
plot(x,l,'k','linewidth',3)
plot(x,abs(n(Dn*V(1:2,4))),'r-','linewidth',3)
plot(x,abs(n(Tn*V(3:4,4))),'b-','linewidth',3)

title('L SVD')


%%% Reconstruct M
subplot(3,3,8); hold on
[U,S,V]=svd([Pn Tn])
plot(x,m,'k','linewidth',3)
plot(x,abs(n(Pn*V(1:2,4))),'r-','linewidth',3)
plot(x,abs(n(Tn*V(3:4,4))),'b-','linewidth',3)
title('M SVD')


%%% Reconstruct S
subplot(3,3,9); hold on
[U,S,V]=svd([Pn Dn])
plot(x,s,'k','linewidth',3)
plot(x,abs(n(Pn*V(1:2,4))),'r-','linewidth',3)
plot(x,abs(n(Dn*V(3:4,4))),'b-','linewidth',3)
title('S SVD')
legend('real','est1','est2')








