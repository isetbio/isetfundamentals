%% Intersection of cone fundamentals with illuminant change
%
% The first calculation is designed to work with arbitrary spectral
% radiance as input.  Later we will incorporate changes so that if we know
% the likely surface reflectances, we will do better.
%
% The first, somewhat surprising, observation is that when the lights
% change color temperature a lot, the best matches are obtained by scaling
% the L and M cones both positively and negatively.
%
% Thinking about opponent processes, of course.
%
% See also
%
%% Read in two different blackbodies and stockman

wave  = 400:10:700;
cTemp = [3000 7500 5000];
stockman = ieReadSpectra('stockmanEnergy',wave);
day1 = blackbody(wave,cTemp(1));
day2 = blackbody(wave,cTemp(2));
day3 = blackbody(wave,cTemp(3));

% For now use this as a reflectance vector
reflectance = blackbody(wave,cTemp(3));

%% Multiply to get new 'reflectance' fundamentals

% These are the fundamentals that see reflectances, not spectral radiance
st1 = diag(day1)*stockman;
st2 = diag(day2)*stockman;

ieNewGraphWin;
tiledlayout(2,1);
nexttile; plot(wave,st2);
xlabel('Wavelength (nm)'); ylabel('QE'); grid on;
title(sprintf('Color temperatre %.0f',cTemp(1)));

nexttile; plot(wave,st1);
xlabel('Wavelength (nm)'); ylabel('QE'); grid on;
title(sprintf('Color temperatre %.0f',cTemp(2)));

%% Find the svd so we can find the best match

M = [st2, st1];
[U,S,V] = svd(M,'econ');

%{
% The decomposition
Mest = U*S*V';
plot(M(:),Mest(:),'.');
identityLine;
%}

%{
% Check I have the proper column of V.
% I screwed this up once.
st40(:,3) = st65(:,3);
M = [st40, st65];
[U,S,V] = svd(M,'econ');
diag(S)
for ii=1:size(V,1)
    nVector = V(:,ii);
    norm(M*nVector(:))
end
% The last column of V is the answer
%}

%% This is how close the two 'virtual' fundamentals are

avec = V(1:3,end);
A = M(:,1:3)*avec(:);
bvec = -1*V(4:6,end);
B = M(:,4:6)*bvec(:);

ieNewGraphWin;
tiledlayout(2,1);
nexttile;
plot(wave,A,'r-',wave,B,'k-');
xlabel('Wavelength (nm)'); ylabel('QE'); grid on;
title('Virtual QE: 1st match')
xaxisLine;

fprintf('Cone weights 1 (ctemp 1):  %.1f %.1f %.1f\n', avec);
fprintf('Cone weights 1 (ctemp 2):  %.1f %.1f %.1f\n', bvec);

% Screwing around.  2nd best match

avec = V(1:3,end-1);
A = M(:,1:3)*avec(:);
bvec = -1*V(4:6,end-1);
B = M(:,4:6)*bvec(:);

nexttile;
plot(wave,A,'r-',wave,B,'k-');
xlabel('Wavelength (nm)'); ylabel('QE'); grid on;
title('Virtual QE: 2nd match')
xaxisLine;

fprintf('Cone weights 2 (ctemp 1):  %.1f %.1f %.1f\n', avec);
fprintf('Cone weights 2 (ctemp 2):  %.1f %.1f %.1f\n', bvec);



%% Low rank approximation 
fig=figure(10); clf;
fig.Position= [281 117.6667 908.6667 500.3333];

% Calculate low rank approximation
ranks = [5,4,3]
for r=1:numel(ranks)
    [U,S,V]=svds(M,ranks(r));
    Mlr = U*S*V';

    % Null space 
    N = null(Mlr);

    % Plot the low rank approximations of the original cones
    subplot(3,3,r)
    hold on; 
    h=plot(wave,M,'k');
    hlr=plot(wave,Mlr,'r--');
    title("Compare quality low rank approximation");
    legend([h(1) hlr(1)],"M","M lowrank");
    title(["Rank " num2str(ranks(r))])

    % Use the null space to find the virtual cones
    subplot(3,3,r+3);hold on;
    A=-M(:,1:3)*N(1:3,:);
    B=M(:,4:6)*N(4:6,:);
    plot(wave,A,'k')
    plot(wave,B,'r--')
    title(["Rank " num2str(ranks(r))])

    % use virtual cones to measure a third spectrum
    subplot(3,3,7) ; hold on;
    A=-M(:,1:3)*N(1:3,:);
    B=M(:,4:6)*N(4:6,:);
    vConeA{r}=A'*reflectance;
    vConeB{r}=B'*reflectance;
    scatter(ranks(r),vConeA{r},'k+') 
    scatter(ranks(r),vConeB{r},'r') 
    xticks([3 4 5])
    title("Virtual cones response to day3")


     subplot(3,3,8) ; hold on;
     scatter(ranks(r),st1'*day3,'k+') 
     scatter(ranks(r),st2'*day3,'r') 
     xticks([3 4 5])
     title("Original cones response to day3")
    

end


