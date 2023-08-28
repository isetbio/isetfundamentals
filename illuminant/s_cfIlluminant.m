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
cTemp = [3000 7500];
stockman = ieReadSpectra('stockmanEnergy',wave);
day1 = blackbody(wave,cTemp(1));
day2 = blackbody(wave,cTemp(2));

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


