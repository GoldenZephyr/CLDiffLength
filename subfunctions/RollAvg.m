function [RollingAverage] = RollAvg(CutImage, Points2Roll)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%%
CutImage=CutImage'; %
[M,N]=size(CutImage); %
P=Points2Roll; %number of colums to be used for rolling average
RollingAverage=zeros(M-P+1,N); 
for k=1:M-P+1; %
    RollingAverage(k,:)=mean(CutImage(k:k+(P-1),:)); %Average of five columns through entire dataset
end


end

