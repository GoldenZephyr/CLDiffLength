function [ BB ] = Norm4fit( AA )


% For each row in AA, a background noise level is calculated by taking a
% mean of the furthest 20 value counts away from the source and then
% subtracting this background noise level from each value in that row

% The rows are then normalized to a max value of '1'

[M,N] = size(AA);
    
for I = M-19:M
    n1(I-M+20) = mean(AA(I,1:N));
end
AA = AA-mean(n1);

for I=1:N
    n2=AA(1,I);
    BB(:,I)= AA(:,I)./(n2);
end

end

