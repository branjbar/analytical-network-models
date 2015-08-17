function nbrs = get_m_neighbors(W, node, m)
%GET_M_NEIGHBORS collects neighbors and neighbor of neighbors and so on,
%until it reaches m members.

    nbr = zeros(size(W,1),1);
    nbr(node) = 1;
    while sum(nbr) < m
        nbrs = find(nbr == 1);
        
        for i = 1 : length(nbrs)
            nbr(W(nbrs(i),:) == 1) = 1;
        end
    end
    nbrs = find(nbr == 1);
    nbrs = randsample(nbrs,m);
end

