function [ A L] = Fit2D( dvec, xvec, A , L )

pvec = [L A];
lambda = 5;
nu = 1.5;
converge = 0;
step=.9;
M = zeros(10,3);
phi = 1e16;
cc=1e-4;%6;

while converge ==0
    uest = ueval( pvec, xvec );
    [UpL UpA] = partials( pvec, xvec );
    
    evec = (uest-dvec);
    Aphi   =  evec*evec';
    a1 = [UpL/norm(UpL) ;  UpA/norm(UpA)]';
    b = -(a1'*a1+lambda*diag(diag(a1'*a1)))\(a1'*evec');
    LMA = b'/norm(b);
    
    
    k=0;
    
    
    Bpvec = [pvec(1)+LMA(1)*step*pvec(1) pvec(2)+LMA(2)*step*pvec(2)];
    Buest =  ueval( Bpvec, xvec );
    Bevec = Buest-dvec;
    Bphi = Bevec*Bevec';
    
    if Bphi<Aphi
        if lambda <1e-10
            Aphi=Bphi;
        end
        while Bphi<Aphi
            k=k+1;
            Aphi = Bphi;
            Blambda=lambda/(nu^k);
            b = -(a1'*a1+Blambda*diag(diag(a1'*a1)))\(a1'*evec');
            LMA = b'/norm(b);
            step = getAstep( dvec,xvec, pvec, LMA);
            Bpvec = [pvec(1)+LMA(1)*step*pvec(1) pvec(2)+LMA(2)*step*pvec(2)];
            Buest =  ueval( Bpvec, xvec );
            Bevec = Buest-dvec;
            Bphi = Bevec*Bevec';
            if Blambda <1e-10
                Aphi=Bphi;
            end
        end
        k=k-1;
        lambda=lambda/(nu^k);
    else
        k=k-1;
        Clambda=lambda/(nu^k);
        b = -(a1'*a1+Clambda*diag(diag(a1'*a1)))\(a1'*evec');
        LMA = b'/norm(b);
        step = getAstep( dvec,xvec, pvec, LMA);
        Cpvec = [pvec(1)+LMA(1)*step*pvec(1) pvec(2)+LMA(2)*step*pvec(2)];
        Cuest = ueval( Cpvec, xvec );
        Cevec = Cuest-dvec;
        Cphi = Cevec*Cevec';
        
        if Cphi<Aphi
            k=k-1;
            if lambda <1e-10
                Aphi=Cphi;
            end
            
            while Cphi<Aphi
                k=k-1;
                Aphi = Cphi;
                Clambda=lambda/(nu^k);
                b = -(a1'*a1+Clambda*diag(diag(a1'*a1)))\(a1'*evec');
                LMA = b'/norm(b);
                step = getAstep( dvec,xvec, pvec, LMA);
                Cpvec = [pvec(1)+LMA(1)*step*pvec(1) pvec(2)+LMA(2)*step*pvec(2)];
                Cuest = ueval(Cpvec, xvec );
                Cevec = Cuest-dvec;
                Cphi = Cevec*Cevec';
                if Clambda <1e-10
                    Aphi=Cphi;
                end
            end
            k=k+1;
            lambda=lambda/(nu^k);
        end
    end
    
    b = -(a1'*a1+lambda*diag(diag(a1'*a1)))\(a1'*evec');
    LMA = b'/norm(b);
    pvec = [pvec(1)+LMA(1)*step*pvec(1) pvec(2)+LMA(2)*step*pvec(2)];
  
    uest = ueval( pvec, xvec );
    evec = (uest-dvec);
    phi   =  evec*evec';
    
    M(1:9,1:3)=M(2:10,1:3);
    M(10,:)=[phi pvec(1) pvec(2) ];
    
    converge = ConvergeCheck(M,cc);
 
    
    
end
L = pvec(1);
A = pvec(2);

end


