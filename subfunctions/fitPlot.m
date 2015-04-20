%% -----------------------------------------------------------------------
% fitPlot.m:  This function fits a plot?
%-------------------------------------------------------------------------
% Parent Program:  LMA_LVA_v1.m
% sub-functions Needed:  Ueval_V8.m
% ------------------------------------------------------------------------
function [ uest ] = fitPlot( L, V ,Zo ,A ,xvec,dvec, plotname, savename)

acc=0;

uest=Ueval_v8(L,V,Zo,A,xvec);
evec = (uest-dvec);
phi  = evec*evec';


%% -----------------------------------------------------------------------
% Plot Results
% ------------------------------------------------------------------------
figure(20)
subplot(2,1,1)
plot(xvec,dvec,'o',xvec,uest,'MarkerSize',5)


%-------------------------------------------------------------------------
% Label Plot
%-------------------------------------------------------------------------
legend('data','model')
title(strcat(plotname,' , 1st dp:',num2str(xvec(1)),'microns , last dp:',num2str(xvec(length(xvec))),'microns'),'FontSize',15);
xlabel('position (microns)','FontSize',13)
ylabel('Intensity (a. u.)','FontSize',13)


d = max(uest);
c = min(uest);
text(xvec(floor(length(xvec)/2)),(c+(d-c)*9/10),[' L = ' ,num2str(round(L*1e2)*1e-2),' microns'],'FontSize',15);
text(xvec(floor(length(xvec)/2)),(c+(d-c)*7/10),[' S/D = ' ,num2str(round((V*100))/100),'/micron'],'FontSize',15);
text(xvec(floor(length(xvec)/2)),(c+(d-c)*5/10),[' Zo = ' ,num2str(round(Zo*1e2)*1e-2),' microns'],'FontSize',15);
text(xvec(floor(length(xvec)/2)),(c+(d-c)*3/10),[' Amplitude = ' ,num2str(round(A*1e4)*1e-4)],'FontSize',15);
text(xvec(floor(length(xvec)/6)),(c+(d-c)*9/10),[' phi = ' ,num2str(round(phi*1e7)/1e3),'1e-4'],'FontSize',15)


%% -----------------------------------------------------------------------
% Plot Results
% ------------------------------------------------------------------------
subplot(2,1,2)
semilogy(xvec,dvec,'o',xvec,uest,'MarkerSize',5)


%-------------------------------------------------------------------------
% Label Plot
%-------------------------------------------------------------------------
legend('data','model')
xlabel('position (microns)','FontSize',13)
ylabel('Intensity (a. u.)','FontSize',13)


%-------------------------------------------------------------------------
% Save Plot as .jpg
%-------------------------------------------------------------------------
%saveas(gcf,strcat(filenamesave,'.jpg'))
saveas(gcf,savename)
end