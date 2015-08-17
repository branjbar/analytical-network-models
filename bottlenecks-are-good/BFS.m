function W_di = BFS(W, source, target)
%BFS     extracts a tree from the symmetric network
% W_di = BFS(W, source, target)  applies a breadth first search in an 
% undirectional network to extract the tree which starts at source 
% and ends at target
%
% W:        a symetric adjacency matrix
% source:   the source id between 1 and size of W
% target:   the target id between 1 and size of W
%
% Example: 
%           W_di = BFS([0,1,1;1,0,1;1,1,0],1,2) extracts the following
%           
%                     |    0     1     1 |
%                 W = |    0     0     0 |
%                     |    0     1     0 |


    n = size(W,1);
    ordered_nodes = [source]; % hierarchical orderd list of nodes started from source
    old_length = 0;
    while length(ordered_nodes) > old_length  % while every node is not found by BFS yet
        old_length = length(ordered_nodes);
        for j = 1 : length(ordered_nodes)  % for each node x of ordered nodes
            x = ordered_nodes(j);
            for k = 1 : n  % for each node in the graph
                if W(x,k) && ~any(ordered_nodes == k ) && k ~= target  %see if k is a neighbor of the nodes x and is not already in the list
                    ordered_nodes(end+1) = k;
                end
            end
        end
    end
    ordered_nodes(end+1) = target;
    
    while length(ordered_nodes) > old_length  % while every node is not found by BFS yet
        old_length = length(ordered_nodes);
        for j = 1 : length(ordered_nodes)  % for each node x of ordered nodes
            x = ordered_nodes(j);
            for k = 1 : n  % for each node in the graph
                if W(x,k) && ~any(ordered_nodes == k )  %see if k is a neighbor of the nodes x and is not already in the list
                    ordered_nodes(end+1) = k;
                end
            end
        end
    end

    
% based on the orders from BFS make W directional    
    for i = 1 : n
        for j = i+1 : n
            if find(ordered_nodes == i) < find(ordered_nodes == j)
                W(j,i) = 0;
            else
                W(i,j) = 0;
            end
        end
    end
W_di = W;
