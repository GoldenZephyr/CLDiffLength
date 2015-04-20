function [ BB ] = CenterCut_v2( AA , Xmax)

% This will cut the matrix AA so that the columns will be of length Xmax
% Position 1 of the AA matrix is the max value of that column

[M,N]= size(AA);

DV = mean(AA');
n1 = max(DV);
n2 = find((DV) == n1,1,'first');

for I = 1:N
    n3 = find(AA(:,I) == max(AA(n2-20:n2+20,I)),1,'last');
    BB(:,I) = AA(n3:n3+Xmax-1,I);      
end

end













