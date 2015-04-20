
function [t] = errorfit( a,f,b )
n1 = length(f);

S = zeros(n1,n1);
S(:,1)=f;
for i = 2:n1
    for j = 2:i
        S(i,j)=(S(i,j-1)-S(i-1,j-1))/(a(i)-a(i-j+1));
    end
end

f1 =@(x) S(1,1) +(x-a(1)).*S(2,2)+(x-a(1)).*(x-a(2)).*S(3,3)+...
            (x-a(1)).*(x-a(2)).*(x-a(3)).*S(4,4)+(x-a(1)).*(x-a(2)).*(x-a(3)).*(x-a(4)).*S(5,5);
        
        
        
        x=min(a)/10^b:max(a)/10^b;
        x=x*10^b;
%        plot(x,f1(x))
t=x(find(f1(x)==min(f1(x)),1,'first'));

        
end