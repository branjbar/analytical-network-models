function output = get_size_of_largest_linking(W,a,b)
%% this function, for now designed for scale free networks, finds the size 
% of maximum linking and also returns some other details
% output = get_size_of_largest_linking(W)
% output = [source_max_flow,target_max_flow, max_degree_max_flow, min_degree_max_flow, max_max_flow];
    
    N = size(W,1);
    results = [1,1];
    i = 1;
    max_max_flow = 0;
    source_max_flow = NaN;
    target_max_flow = NaN;
    %%
    [~,c] = sort(sum(W), 'descend' );
    c = c(1:10);

    %%
    for source = c
        for target = c
            if (source < target)
                W_di = BFS(W, source, target);
                W_sparse_directional = sparse(W_di);

                MaxFlow = graphmaxflow(W_sparse_directional, source, target);
                if MaxFlow > max_max_flow
                    max_max_flow = MaxFlow;
                    source_max_flow = source;
                    target_max_flow = target;
                    max_degree_max_flow = max(sum(W_di(source,:)), sum(W_di(:,target)));
                    min_degree_max_flow = min(sum(W_di(source,:)), sum(W_di(:,target)));
                end
                results(i,:) = [floor(MaxFlow), min(sum(W_di(source,:)), sum(W_di(:,target)))];
                i = i+1;
            end
        end
    end
    output = [source_max_flow,target_max_flow, max_degree_max_flow, min_degree_max_flow, max_max_flow];
end
%%
