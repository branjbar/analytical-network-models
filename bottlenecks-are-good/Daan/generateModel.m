function [ H ] = generateModel( W, X, b, c )
%Generate dynamical model ("Laplacian") for given network W, initial 
%policies X, benefit b and cost c.

N = length(W);
F = zeros(N,1);
H = zeros(N);

for i = 1 : N
    sum = 0;
    for j = 1 : N
        if W(i,j) == 1
            sum = sum - X(i) * c + X(j) * b;
        end
    end
    F(i) = sum;
end

for i = 1 : N
    for j = 1 : N
        if W(i,j) == 1
            H(i,j) = 1 / (1 + exp(F(i) - F(j)));
        end
    end
end
for i = 1 : N
    deg = 0;
    for j = 1 : N
        if i ~= j
            H(i,i) = H(i,i) - H(i,j);
            deg = deg + 1;
        end
    end
    for j = 1 : N
        H(i,j) = H(i,j) / deg;
    end
end

end

