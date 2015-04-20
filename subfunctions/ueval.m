function [ uest ] = ueval( pvec, xvec )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
uest = pvec(2)*exp(  (-1/pvec(1))   *xvec);

end

