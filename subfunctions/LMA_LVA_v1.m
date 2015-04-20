%% -----------------------------------------------------------------------
% LMA_LVA_v1.m:  Performs least squares fit.
%-------------------------------------------------------------------------
% % sub-functions Needed:  Ueval_v8.m, UpartL_v7.m, UpartV_v8.m, 
% polyEstimate.m, ConvergeCheck.m, fitPlot.m
%% -----------------------------------------------------------------------


function [ L V A phi b] = LMA_LVA_v1(L,V ,Zo,A ,xvec, dvec, plotname, savename)
pvec=[L V Zo A];

format long e

jj=0;
converge=0;
M = zeros(10,6);
tic

phistep = .9;
stop=7;
cc=1e-6;
see =5 ;
lambda = 1e0;
nu = 3;
phi=0;


while converge ==0;
    
    jj=jj+1;
    uest = Ueval_v8(pvec(1),pvec(2),pvec(3),pvec(4),xvec);
    UpL = UpartL_v7(pvec(1),pvec(2),pvec(3),pvec(4), xvec);
    UpV = UpartV_v8(pvec(1),pvec(2),pvec(3),pvec(4), xvec);
    UpA = uest/pvec(4);
    
   
    %%
    evec = (uest-dvec);
    Aphi   =  evec*evec';
    %   a1 = [UpL ; UpV ; UpA ]';
    a1 = [UpL/norm(UpL) ; UpV/norm(UpV);  UpA/norm(UpA)]';
    b = -(a1'*a1+lambda*diag(diag(a1'*a1)))\(a1'*evec');
    LMA = b'/norm(b);
    
    Bpvec = [pvec(1)+LMA(1)*phistep*pvec(1) pvec(2)+LMA(2)*phistep*pvec(2) pvec(3) pvec(4)+LMA(3)*phistep*pvec(4)];
    Buest = Ueval_v8(Bpvec(1),Bpvec(2),Bpvec(3),Bpvec(4),xvec);
    Bevec = Buest-dvec;
    Bphi = Bevec*Bevec';
    phistepL=phistep;
    k=0;
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
            phistep = polyEstimate(  pvec, LMA,xvec,dvec,phistepL,stop );
            Bpvec = [pvec(1)+LMA(1)*phistep*pvec(1) pvec(2)+LMA(2)*phistep*pvec(2) pvec(3) pvec(4)+LMA(3)*phistep*pvec(4)];
            Buest = Ueval_v8(Bpvec(1),Bpvec(2),Bpvec(3),Bpvec(4),xvec);
            Bevec = Buest-dvec;
            Bphi = Bevec*Bevec';
            if Blambda <1e-10
                Aphi=Bphi;
            end
        end
        k=k-1;
    else
        Clambda=lambda/(nu);
        b = -(a1'*a1+Clambda*diag(diag(a1'*a1)))\(a1'*evec');
        LMA = b'/norm(b);
        phistep = polyEstimate(  pvec, LMA,xvec,dvec,phistepL ,stop );
        Cpvec = [pvec(1)+LMA(1)*phistep*pvec(1) pvec(2)+LMA(2)*phistep*pvec(2) pvec(3) pvec(4)+LMA(3)*phistep*pvec(4)];
        Cuest = Ueval_v8(Cpvec(1),Cpvec(2),Cpvec(3),Cpvec(4),xvec);
        Cevec = Cuest-dvec;
        Cphi = Cevec*Cevec';
        
        if Cphi<Aphi
            k=k+1;
            Bphi=Cphi;
            if lambda <1e-10
                Aphi=Bphi;
            end
            while Bphi<Aphi
                k=k+1;
                Aphi = Bphi;
                Blambda=lambda/(nu^k);
                b = -(a1'*a1+Blambda*diag(diag(a1'*a1)))\(a1'*evec');
                LMA = b'/norm(b);
                phistep = polyEstimate(  pvec, LMA,xvec,dvec,phistepL ,stop );
                Bpvec = [pvec(1)+LMA(1)*phistep*pvec(1) pvec(2)+LMA(2)*phistep*pvec(2) pvec(3) pvec(4)+LMA(3)*phistep*pvec(4)];
                Buest = Ueval_v8(Bpvec(1),Bpvec(2),Bpvec(3),Bpvec(4),xvec);
                Bevec = Buest-dvec;
                Bphi = Bevec*Bevec';
                if Blambda <1e-10
                    Aphi=Bphi;
                end
            end
            k=k-1;
        else
            if lambda >1e10
                Aphi=Bphi;
            else
                k=k-1;
            end
            while Aphi<Bphi
                k=k-1;
                Bphi=min(Aphi,Bphi);
                Alambda=lambda/(nu^k);
                b = -(a1'*a1+Alambda*diag(diag(a1'*a1)))\(a1'*evec');
                LMA = b'/norm(b);
                phistep = polyEstimate(  pvec, LMA,xvec,dvec,phistepL ,stop );
                Apvec = [pvec(1)+LMA(1)*phistep*pvec(1) pvec(2)+LMA(2)*phistep*pvec(2) pvec(3) pvec(4)+LMA(3)*phistep*pvec(4)];
                Auest = Ueval_v8(Apvec(1),Apvec(2),Apvec(3),Apvec(4),xvec);
                Aevec = Auest-dvec;
                Aphi = Aevec*Aevec';
                if Alambda >1e10
                    Aphi=Bphi;
                end
                
            end
            Bpvec=Apvec;
            k=k+1;
        end
    end
    lambda=lambda/(nu^k);
   % a1 = [UpL/norm(UpL) ; UpV/norm(UpV);  UpA/norm(UpA)]';
    b = -(a1'*a1+lambda*diag(diag(a1'*a1)))\(a1'*evec');
    LMA = b'/norm(b);
    phistep = polyEstimate(  pvec, LMA,xvec,dvec,phistepL ,stop );
    
    pvec = [pvec(1)+LMA(1)*phistep*pvec(1) pvec(2)+LMA(2)*phistep*pvec(2) pvec(3) pvec(4)+LMA(3)*phistep*pvec(4)];
    uest = Ueval_v8(Bpvec(1),Bpvec(2),Bpvec(3),Bpvec(4),xvec);
    evec = uest-dvec;
    phi = evec*evec';
    
    
    M(1:9,1:6)=M(2:10,1:6);
    M(10,:)=[phi pvec(1) pvec(2) pvec(3) pvec(4)  phistep ];
    
    converge = ConvergeCheck(M,cc);
%     if converge == 1
%         if stop <6
%             converge=0;
%             stop=stop+1;
%             cc=cc/5;
%             display(' ############################# YAHOOOO ###########')
%             M = zeros(10,6);
%             M(10,:)=[phi pvec(1) pvec(2) pvec(3) pvec(4)  phistep ];
%             
%             Lname = 'L = ';
%             Vname = ',  V = ';
%             Zname = ',  Zo = ';
%             Aname = ',  A = ';
%             
%             p1 = 'step =';
%             p2 = ',  phi =';
%             L1 = ',  LMA  = ';
%             lam = ',  time =';
%             lam1 = ',  jj count  =';
%             lam2 = ',  lambda =';
%             time1= toc;
%             fprintf('%s %1.4e %s %1.5e %s %1.4e %s %1.4e %s  %4.3f %10s %4.3e  \n'...
%                 ,Lname,pvec(1),Vname,pvec(2),Zname,pvec(3), Aname,pvec(4), lam,time1,lam2,lambda')
%             
%             fprintf('%s %1.10f %s %1.9e %s %3.3e %s %4.4e %4.4e %4.4e  \n \n \n'...
%                 ,p1, phistep,p2, phi,lam1,jj, L1 , LMA(1) , LMA(2) ,LMA(3));
%             fitPlot( pvec(1), pvec(2) ,pvec(3),pvec(4) ,xvec,dvec,'test' );
%             pause(.01)
%             
%             
%         end
%     end
    
    if mod(jj,see)==1;
        Lname = 'L = ';
        Vname = ',  V = ';
        Zname = ',  Zo = ';
        Aname = ',  A = ';
        
        p1 = 'step =';
        p2 = ',  phi =';
        L1 = ',  LMA  = ';
        lam = ',  time =';
        lam1 = ',  jj count  =';
        lam2 = ',  lambda =';
        time1= toc;
        fprintf('%s %1.4e %s %1.5e %s %1.4e %s %1.4e %s  %4.3f %10s %4.3e  \n'...
            ,Lname,pvec(1),Vname,pvec(2),Zname,pvec(3), Aname,pvec(4), lam,time1,lam2,lambda')
        
        fprintf('%s %1.10f %s %1.9e %s %3.3e %s %4.4e %4.4e %4.4e  \n \n \n'...
            ,p1, phistep,p2, phi,lam1,jj, L1 , LMA(1) , LMA(2) ,LMA(3));
        fitPlot( pvec(1), pvec(2) ,pvec(3),pvec(4) ,xvec,dvec, plotname, savename);
        pause(.01)
        
    end
    
    
end

L = pvec(1);
V = pvec(2);
Zo = pvec(3);
A = pvec(4);

Lname = 'L = ';
Vname = ',  V = ';
Zname = ',  Zo = ';
Aname = ',  A = ';

p1 = 'step =';
p2 = ',  phi =';
L1 = ',  LMA  = ';
lam = ',  time =';
lam1 = ',  jj count  =';
lam2 = ',  lambda =';
time1= toc;
fprintf('%s %1.4e %s %1.5e %s %1.4e %s %1.4e %s  %4.3f %10s %4.3e  \n'...
    ,Lname,pvec(1),Vname,pvec(2),Zname,pvec(3), Aname,pvec(4), lam,time1,lam2,lambda')

fprintf('%s %1.10f %s %1.9e %s %3.3e %s %4.4e %4.4e %4.4e  \n \n \n'...
    ,p1, phistep,p2, phi,lam1,jj, L1 , LMA(1) , LMA(2) ,LMA(3));

fitPlot( pvec(1), pvec(2) ,pvec(3),pvec(4) ,xvec,dvec,plotname, savename);
pause(.01)

%save('LMA_LVA_v1 Variables')
clear Aevec Auest Bevec Buest Cevec Cuest M UpA UpL UpV a1 ans dvec evec uest xvec
end



