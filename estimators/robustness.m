%% Demonstration that NullNull Method leads to more stable solutions
wave = linspace(300,800,500);
%% Make two gaussian cones
cwl=[450 700]
Aorig=normpdf(wave',cwl,[10 20]);
Aorig(:,1)=ieScale(Aorig(:,1),1);
Aorig(:,2)=ieScale(Aorig(:,2),1);

cwl=[460 600]
Borig=normpdf(wave',cwl,[10 30]); % Introduce small error
Borig(:,1)=ieScale(Borig(:,1),1);
Borig(:,2)=ieScale(Borig(:,2),1);

% Randomize 
Ca=rand(2);Cb=rand(2);
A=Aorig*Ca; 
B=Borig*Cb;



%% Compute different estimates
estimator1=estimatorIntersect(A,B);
estimator2=estimatorLowrank(A,B);
estimator3=estimatorNullNull(A,B);


%%

fig=figure; hold on ;
lw=1.5
fig.Position=[670 321 1189 474];
h1=plot(ieScale(sum(estimator1,2),1),'g','linewidth',lw);
h3=plot(estimator3,'r','linewidth',lw);
horig=plot(ieScale(ieScale(Aorig(:,1),1) +ieScale(Borig(:,1)),1),'k--')

legend([horig h1 h3],'Mean of ground truth','Mean of two solutions from method 1','Null Null')
xlabel("Wavelength")