%% Demonstration that NullNull Method leads to more stable solutions
wave = linspace(300,800,5000);
%% Make two gaussian cones
cwl=[450 750]
Aorig=normpdf(wave',cwl,[10 20]);
Aorig(:,1)=ieScale(Aorig(:,1),1);
Aorig(:,2)=ieScale(Aorig(:,2),1);

cwl=[455 600]
Borig=normpdf(wave',cwl,[10 30]); % Introduce small error
Borig(:,1)=ieScale(Borig(:,1),1);
Borig(:,2)=ieScale(Borig(:,2),1);

figure;hold on;
plot(Aorig,'k')
plot(Borig,'r')
Ca=randn(2);Cb=randn(2);

A=Aorig*Ca; 
B=Borig*Cb;




estimator1=estimatorIntersect(A,B);
estimator2=estimatorLowrank(A,B);
estimator3=estimatorNullNull(A,B);
estimator4=estimatorNullNullXY(A,B);

%%

fig=figure;
lw=1.5
fig.Position=[670 321 1189 474];
subplot(121);hold on;
plot(estimator1,'linewidth',lw)
%plot(estimator4,'g--','linewidth',lw)
plot(estimator3,'r','linewidth',lw); 

subplot(122);hold on;
h1=plot(ieScale(sum(estimator1,2),1),'g','linewidth',lw);
h4=plot(ieScale(sum(estimator4,2),1),'b','linewidth',lw);

h3=plot(estimator3,'r','linewidth',lw);
horig=plot(ieScale(ieScale(Aorig(:,1),1) +ieScale(Borig(:,1)),1),'k--')
legend([horig h1 h4 h3],'Mean of ground truth','Mean of method1','Mean Method 4','NullNull')

