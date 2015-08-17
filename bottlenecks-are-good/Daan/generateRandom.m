function [ W ] = generateRandom( N, p )
%Generates an Erdos-Renyi random graph with N nodes and probility p of two
%random nodes being connected.
W = zeros(N);

r = rand(N);

for i = 1:N
    for j = i+1:N
        if r(i,j) < p
            W(i,j) = 1; W(j,i) = 1;
        end
    end
end

end