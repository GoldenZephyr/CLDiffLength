function [ converge ] = ConvergeCheck( M,cc )

% This function uses matrix M and convergence criteria 'c' to determine if
% the new pvec paramters are with in tolerance for convergence

% 'd' is used to set the previous itterations for checking note that a
% value of 7 will check the rows 7-9 against the 10th row or in other
% words the previous three iterations

d=1;
converge =0;

if abs(max(M(d:9,2))-M(10,2))<=M(10,2)*cc
         if abs(max(M(d:9,3))-M(10,3))<=M(10,3)*cc
         if abs(min(M(d:9,2))-M(10,2))<=M(10,2)*cc
         if abs(min(M(d:9,3))-M(10,3))<=M(10,3)*cc
    
                converge = 1;
        
        end
        end
        end

end


end

