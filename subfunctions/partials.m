function [ UpL UpA ] = partials( pvec, xvec )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    UpL = (pvec(2)/(pvec(1)^2))*xvec.*exp(  (-1/pvec(1))  *xvec);
    UpA = exp(  (-1/pvec(1))   *xvec);

end

