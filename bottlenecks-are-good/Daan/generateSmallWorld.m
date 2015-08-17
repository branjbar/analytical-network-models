function [ W ] = generateSmallWorld( N, K, beta )
%Generates a Watts-Strogatz small-world network of N nodes with mean
%degree K (should be even!) and rewiring probability beta.

W = zeros(N);

if mod(K,2) == 1
    K = K - 1; % K should be even
end

for i = 1:N % create regular lattice of degree K
    for j = 1:N
        if 0 < mod( abs(i-j), N - 1 - (K/2) ) && mod( abs(i-j), N - 1 - (K/2) ) <= (K/2)
            W(i,j) = 1; W(j,i) = 1;
        end
    end
end

r = rand(N,K/2);

for L = 1:(K/2) % rewiring for K/2 laps
    for i = 1:N
        if r(i,L) < beta
            j = i + L; % neighbout to consider
            if j > N, j = 0 + j - N; end % loop around the edge
            j_cand = randi(N-1);
            if j_cand >= i, j_cand = j_cand + 1; end
            if sum( j_cand == find( W(i,:) == 1 ) ) == 0 % not already connected
                W(i,j) = 0; W(j,i) = 0; % rewire!
                W(i,j_cand) = 1; W(j_cand,i) = 1;
            end
        end
    end
end

end