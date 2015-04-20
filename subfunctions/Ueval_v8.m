%% -----------------------------------------------------------------------
% Ueval_v8.m:  Evaluates U by the provided inputs.  This requires the 
% evaluation of two integrals 'f1' and 'f2'.  Easy function ef is used 
% to simplify f1 and f2.
%-------------------------------------------------------------------------
% Parent Program:  LMA_LVA_v1.m, polyEstimate.m, fitPlot.m
% sub-functions Needed:  none
% ------------------------------------------------------------------------
function [ Uest ] = Ueval_v8( L,V,Zo,A,xvec )

k  = length(xvec);  % length of xvec


%% -----------------------------------------------------------------------
% Initialize vectors U1, U2, and U3
% ------------------------------------------------------------------------
U1 = zeros(1,k);
U2 = zeros(1,k);
U3 = zeros(1,k);


%% -----------------------------------------------------------------------
% Begin parallel for-loops
% ------------------------------------------------------------------------
parfor n=1:k % parallel for-loop
    
    
%% -----------------------------------------------------------------------
% Numerically-evaluate integral U1 using adaptive Gauss-Kronrod quadrature
%------------------------------------------------------------------------- 
 a=1e-13; % Relative Error Tolerance for quadgk integral
 b=1e-13; % Absolute Error Tolerance for quadgk integral
    
 x = xvec(n); % Select one x at a time from xvec for integration
        
 LL = x/L; % Lower limit of integral
 UU = inf; % Upper limit of integral
    
 ef = @(t) sqrt(  t.^2 - (x/L).^2  ); % (square root portion)
 f1 = @(t) besselk(1,t).*ef(t); % (Bessel function K1 portion) 
    
 U1(n)=  quadgk(f1,LL,UU,'RelTol',a,'AbsTol',b,'MaxIntervalCount',9999999);
    

%% -----------------------------------------------------------------------
% Numerically-evaluate integral U3 using adaptive Gauss-Kronrod quadrature
% Note that a change of variable from t to r was made.
%-------------------------------------------------------------------------
 a=1e-13; % Relative Error Tolerance for quadgk integral
 b=1e-13; % Absolute Error Tolerance for quadgk integral
 
 x = xvec(n); % Select one x at a time from xvec for integration
 
% f3 = @(r) besselk(0,sqrt(r+(x/L)^2)).*(exp(V*(Zo-L.*sqrt(r)))-1)./(2.*sqrt(r));
% LL=(Zo/L)^2;

% f3 = @(r) besselk(0,sqrt(r+x^2)/L).*( exp(V*(Zo-sqrt(r)))-1 )./(2*L.*sqrt(r));
% LL=Zo^2;

  f3 = @(r) besselk(0,sqrt(r.^2+x^2)/L).*( exp(V*(Zo-r))-1 )./L;
  LL=Zo;
  UU=inf;

U3(n)= quadgk(f3,LL,UU,'RelTol',a,'AbsTol',b,'MaxIntervalCount',9999999);
 
    
end

Uest=(U1+U3)*A; % Why not - ?
clear U1 U3 f3 x LL UU ef f1 a b U2 k
end
