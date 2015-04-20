function [ step ] = getAstep( dvec,xvec,pvec,LMA)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    L=pvec(1);
    A=pvec(2);
    
    U = A*exp(-1/L*xvec);
    evec = U-dvec;
    SE = evec*evec';


    k=0;
    step1=.9;
    stepsize=0;
    while k==0
        L1= L+step1*LMA(1)*L;
        A1= A+step1*LMA(2)*A;
        
        U1 = A1*exp(-1/L1*xvec);
        evec1 = U1-dvec;
        SE1 = evec1*evec1';
       
        if SE1 < SE
            SE=SE1;
            stepsize=step1;
        else if stepsize~=0
                k=1;
                
            end
        end
        
        step1=step1/2;
        
        
        if step1<1e-8
            stepsize=step1;
            k=1;
        end
        
        if step1>.9
            step1=.9;
        end
        
    end

    step=stepsize;







end

