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


