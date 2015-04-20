%% -----------------------------------------------------------------------
% polyEstimate.m:  This function uses the elements of 'stepvec' to 
% determine the best stepsize in the direction of 'LMA' for pvec.  It 
% returns the estimated stepsize.  
%-------------------------------------------------------------------------
% Parent Program:  LMA_LVA_v1.m
% sub-functions Needed:  errorfit.m, Ueval_V8.m
% ------------------------------------------------------------------------
function [ phistep ] = polyEstimate( pvec, LMA,xvec,dvec ,a,b1)

% stepvec = [1e-5 1e-5+.05 1e-5+.1 ];
%
% ercheck=zeros(1,length(stepvec));
%
% for j=1:length(stepvec)
%     Pcheck=[pvec(1)+LMA(1)*stepvec(j)*pvec(1) pvec(2)+LMA(2)*stepvec(j)*pvec(2) pvec(3) pvec(4)+LMA(3)*stepvec(j)*pvec(4)];
%     Ucheck=Ueval_v8(Pcheck(1),Pcheck(2),Pcheck(3),Pcheck(4),xvec);
%
%     ercheck(j)=(dvec-Ucheck)*(dvec-Ucheck)';
% end
% phistep=errorfit3(stepvec,ercheck);
% end

a=min(a*100,.08);
%b=-7;
b=-b1;
stepvec = [10^b 3*10^b a/6 a/4 a/3  a];

%stepvec = [10^b (10^b)*1.845  max((a/219),(10^b)*2.5743) max((a/111),(10^b)*2.8) max((a/10),(10^b)*3.9) max((a),(10^b)*5)];
%stepvec = [10^b 10^b+a 10^b+(a*2) 10^b+(a*3) ];


ercheck=zeros(1,length(stepvec));

for j=1:length(stepvec)
    
    Pcheck=[pvec(1)+LMA(1)*stepvec(j)*pvec(1) pvec(2)+LMA(2)*stepvec(j)*pvec(2) pvec(3) pvec(4)+LMA(3)*stepvec(j)*pvec(4)];
    Ucheck=Ueval_v8(Pcheck(1),Pcheck(2),Pcheck(3),Pcheck(4),xvec);
    
    ercheck(j)=(dvec-Ucheck)*(dvec-Ucheck)';
    
end

phistep=errorfit(stepvec,ercheck,b);
clear a b stepvec Pcheck Ucheck ercheck
end