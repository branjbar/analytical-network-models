function [ conn ] = isConnected( W )
%check if a given graph W is connected


conn = false;

N = expand(zeros(size(W,1),1), W, 1);

if sum(N) == length(N)
    conn = true;
end

end

function [ N ] = expand(N, W, n)

if N(n) == 0
    N(n) = 1;
    cand = find(W(n,:) == 1);
    for c = 1:length(cand)
        N = expand(N, W, cand(c));
    end
end

end