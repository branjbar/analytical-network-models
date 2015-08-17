function [ W ] = generateRegular( N, d )
%Generates a regular graph of degree d with N nodes.

W = zeros(N);

for i = 1:N,
    deg = sum( W(i,:) ); % current node degree
    if deg < d
        cand = find( sum( W(:,[1:i-1 i+1:N]) ) < d ); % candidate neighbors
        tmp = find( cand >= i );
        cand(tmp) = cand(tmp) + 1;
        if isempty(cand) % this can happen when the last remaining node wants a link to itself
            x_cand = [1:i-1 i+1:N];
            x = x_cand(randi(N-1));
            y_cand = find( W(x,:) == 1);
            y_cand = find(y_cand ~= i);
            y = y_cand(randi(length(y_cand)));
            W(x,y) = 0; W(y,x) = 0;
            W(x,i) = 1; W(i,x) = 1; W(y,i) = 1; W(i,y) = 1;
        else

            ind = cand( randperm( length(cand), min(length(cand),d - deg) ) ); %select new neighbors
            W(i,ind) = 1;
            W(ind,i) = 1;
        end
    end
end

end