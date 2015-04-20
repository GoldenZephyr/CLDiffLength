%% -----------------------------------------------------------------------
% UpartV_v8.m:  This function calculates the partial derivatives of 
% u(L,V,Z,A) with respect to V.  It takes as inputs the value for each 
% variable L, V, Z, A, and a vector of x values.  It sends as its output
% a vector with the partial of u WRT V evaluated at each x value in xvec.
%-------------------------------------------------------------------------
% Parent Program:  LMA_LVA_v1.m
% sub-functions Needed:  none
% ------------------------------------------------------------------------
function [  UpV ] = UpartV_v8( L,V,Zo,A,xvec )

k  = length(xvec); % length of xvec


%% -----------------------------------------------------------------------
% Initialize vectors UpV
% ------------------------------------------------------------------------
UpV = zeros(1,k);


%% -----------------------------------------------------------------------
% Begin parallel for-loops
% ------------------------------------------------------------------------
parfor n=1:k % parallel for-loop
  
    
%% -----------------------------------------------------------------------
% Numerically-evaluate integral U1 using adaptive Gauss-Kronrod quadrature
%------------------------------------------------------------------------- 
a=100*eps; % Relative Error Tolerance for quadgk integral
b=1e-23; % Absolute Error Tolerance for quadgk integral
    
x = xvec(n); % Select one x at a time from xvec for integration
    
tt = 3;
    
    if tt == 1
        
        f1 = @(r) besselk(0,sqrt(r+(x/L)^2)).*(Zo-L.*sqrt(r)).*exp(V.*(Zo-L.*sqrt(r)))./(2.*sqrt(r));
        LL = (Zo/L)^2;
        UU = inf;
        
    elseif tt== 2
        
        f1 = @(r) besselk(0,sqrt(r+x^2)/L).*exp(V*(Zo-sqrt(r))).*(Zo-sqrt(r))./(2*L.*sqrt(r));
        LL = Zo^2;
        UU = inf;
        
    else
        
        f1 = @(r) besselk(0,sqrt(r.^2+x^2)/L).*exp(V*(Zo-r)).*(Zo-r)./(L);
        LL = Zo;
        UU = inf;
        
    end
    
%     acc1=10;
%     ww=10;
%     stop = min(LL*acc1,ww);
%     c = 500;
%     
%     
%     i=1;
%     while LL<=stop;
%         inc = log(1+(i)/c)^4;
%         int1 = int1 + quadgk(f1,LL,LL+inc,'RelTol',a,'AbsTol',b,'MaxIntervalCount',9999999);
%         
%         
%         i=i+1;
%         LL=LL+inc;
%     end
    
      
    int1=0;
    
    UpV(n)= int1 + quadgk(f1,LL,UU,'RelTol',a,'AbsTol',b,'MaxIntervalCount',9999999);
 
    
end

UpV=UpV*A;
clear f1 LL UU int1
end