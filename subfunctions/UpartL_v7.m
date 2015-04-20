%% -----------------------------------------------------------------------
% UpartL_v7.m:  This function calculates the partial derivatives of 
% u(L,V,Z,A) with respect to L.  It takes as inputs the value for each 
% variable L, V, Z, A, and a vector of x values.  It sends as its output
% a vector with the partial of u WRT L evaluated at each x value in xvec.
%-------------------------------------------------------------------------
% Parent Program:  LMA_LVA_v1.m
% sub-functions Needed:  none
% ------------------------------------------------------------------------
function [ UpL  ] = UpartL_v7( L,V,Zo,A,xvec )

k  = length(xvec); % length of xvec


%% -----------------------------------------------------------------------
% Initialize vectors I1, I2, and I3
% ------------------------------------------------------------------------
I1 = zeros(1,k);
I2 = zeros(1,k);
I3 = zeros(1,k);


%% -----------------------------------------------------------------------
% Begin parallel for-loops
% ------------------------------------------------------------------------
parfor n=1:k % parallel for-loop

    
%% -----------------------------------------------------------------------
% Numerically-evaluate integral I1 using adaptive Gauss-Kronrod quadrature
%------------------------------------------------------------------------- 
 a=1e-13; % Relative Error Tolerance for quadgk integral
 b=1e-13; % Absolute Error Tolerance for quadgk integral
 
 x = xvec(n); % Select one x at a time from xvec for integration
        
 LL = x/L; % Lower limit of integral
 UU = inf; % Upper limit of integral   
    
 ef = @(t) sqrt(  t.^2 - (x/L)^2  );
 f1 = @(t) besselk(2,t).*ef(t).*(x^2/L^3)./t;
    
 I1(n)= quadgk(f1,LL,UU,'RelTol',a,'AbsTol',b,'MaxIntervalCount',9999999);
%-------------------------------------------------------------------------


%% -----------------------------------------------------------------------
% Numerically-evaluate integral I3 using adaptive Gauss-Kronrod quadrature
% Note that a change of variable from t to r was made.
%-------------------------------------------------------------------------
 a=1e-13; % Relative Error Tolerance for quadgk integral
 b=1e-13; % Absolute Error Tolerance for quadgk integral
 
 x = xvec(n); % Select one x at a time from xvec for integration
    
% f2 = @(r) besselk(0,sqrt(r+(x/L)^2)).*( (-V*(r+(x/L)^2).*exp(V*(Zo-L.*sqrt(r)))./(r) ) + ...
%      (1- exp(V*(Zo-L.*sqrt(r))) ).*x^2./(L^3*r.^(3/2)) )/2;
% LL= (Zo/L)^2;
    
% f2 = @(r) (1-exp(V.*(Zo-sqrt(r))))./(2*L^2.*sqrt(r)).*(     besselk(1,sqrt(r+x^2)./L).*(sqrt(r+x^2)./L)-besselk(0,sqrt(r+x^2)./L)   );
% LL= Zo^2;
    
  f2 = @(r) 1/(L^2)*(1-exp(V.*(Zo-r))).*(besselk(1,sqrt(r.^2+x^2)./(L)).*sqrt(r.^2+x^2)./(L)-besselk(0,sqrt(r.^2+x^2)./(L))); 
  LL = Zo;
  UU = inf;
      
  I2(n)= quadgk(f2,LL,UU,'RelTol',a,'AbsTol',b,'MaxIntervalCount',9999999);
    
    
end

UpL=(I1+I2)*A;
clear a b x LL UU ef f1 I1 f2 I2
end