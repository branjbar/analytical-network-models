%MAIN Exploring the effect of bottlenecks on network robustness.
% in this file we compare the maximum flow between three types of networks
% with equal density. Network size varies between 5- and 500 nodes, and for each network we choose two hubs and 2%-20% of nodes
% around each hub. The first group is the source and the second group is the 
% target.
%
% 2015 Bijan Ranjbar-Sahraei, Delft Univeristy

%% preprations
addpath('Daan') % adding path to Daan's Generative Models
clear all
clc

%% Initialization
K = 4;  % number of experiments for each configuration
n_min = 50;  % size of networks are from n_min to 10*n_min

GRAPH_TYPES = { 'Scale-Free' 'Small-World' 'Random' };  % type of graph from ['Erdos-Renyi', 'Scale-Free', 'Small-World']

output = zeros(size(GRAPH_TYPES,2), 10, 10, 3); % the output file (graph types¸ n, group_size, [mean, min, max])

% creat a new folder to save files in
folder_name = ['gephi/gephi_' num2str(ceil(rand*10000))];
mkdir(folder_name) 

for g = 1 : 3  % for each type of network
    for n_iter = 1 : 3    % for each node size
        n = n_min * n_iter;

        for group_size_iter = 1 : 2    % for node size
             fprintf('graph_type = %d , #nodes = %d , group_size = %d\n', g, n, group_size_iter * 2)
    
            group_size = floor(group_size_iter * .02 * n);  % the group size
            
            MaxFlow_min = 1000; MaxFlow_max = -1000;  % these two help in saving the Ws with min and max MaxFlow
            MaxFlowArray = zeros(K,1);
            
            for k = 1 : K  % K iteration for a specific network configuration
                if k > 1
                    fprintf('the estimated remaining time is %.2f minutes \n', (toc *(K-k) + toc * K * (4 - g) * (11-n_iter) * (11-group_size_iter)) / 60 )
                end
                tic
                %% generate a network


                [W, hubs] = generate_network(n, GRAPH_TYPES{g});  % generate a random network

                % choose two hubs as the center of source and target
                source_center = hubs(1);
                target_center = hubs(2);


                % augmenting the W
                source_group = zeros(1,n);
                target_group = zeros(n+2,1);
                source_group(get_m_neighbors(W,source_center,group_size)) = 1;
                target_group(get_m_neighbors(W,target_center,group_size)) = 1;
                W_aug = [[W;source_group;zeros(1,n)],zeros(n+2,1),target_group];


                % the last node is the target, and the second last is the source
                source = n+1;
                target = n+2;

                % directionalize the W matrix
                W_di = BFS(W_aug, source, target);

                % compute the maximum flow from source to target
                W_sparse_directional = sparse(W_di);
                MaxFlow = graphmaxflow(W_sparse_directional, source, target);
                MaxFlowArray(k) = MaxFlow;

                % store the network if it has the minimum MinFlow
                if MaxFlow < MaxFlow_min
                    Wmin_aug = W_aug; MaxFlow_min = MaxFlow;
                end

                % store the network if it has the maximum MaxFlow
                if MaxFlow > MaxFlow_max
                    Wmax_aug = W_aug; MaxFlow_max = MaxFlow;
                end

            end
            output(g, n_iter, group_size_iter,:) = [mean(MaxFlowArray) / group_size, MaxFlow_min/ group_size, MaxFlow_max/ group_size];
            
            % save the networks with maximum and minimum MaxFlow
            file_name = [folder_name '/g_' GRAPH_TYPES{g} '_n' num2str(n) '_g' num2str(group_size) '_id' num2str(k) '_min_' num2str(MaxFlow_min)];
            dlmwrite(file_name,[[0:n+2];[[1:n+2]',[Wmin_aug]]],'delimiter',';')
            file_name = [folder_name '/g_' GRAPH_TYPES{g} '_n' num2str(n) '_g' num2str(group_size) '_id' num2str(k) '_max_' num2str(MaxFlow_max)];
            dlmwrite(file_name,[[0:n+2];[[1:n+2]',[Wmax_aug]]],'delimiter',';')

        end
    end
end

%% drawing heatmaps
close all
figure;
for g = 1 : 3
    
    % plot mean
    subplot(3,3,3*(g-1)+1)
    imagesc(squeeze(output(g, :,:,1)),[0 1])
    title(['Maximum Flow in ' GRAPH_TYPES{g} ' (mean)'])
    xlabel('number of nodes')
    ylabel('group fraction')
    xticklabels = n_min:n_min:n_min*10;
    yticklabels = 2:2:20;
    set(gca, 'XTick', 1:10, 'XTickLabel', xticklabels)
    set(gca, 'YTick', 1:10, 'YTickLabel', yticklabels)
    
    % plot min
    subplot(3,3,3*(g-1)+2)
    imagesc(squeeze(output(g, :,:,2)),[0 1])
    title(['Maximum Flow in ' GRAPH_TYPES{g} ' (min)'])
    xlabel('number of nodes')
    ylabel('group fraction')
    xticklabels = n_min:n_min:n_min*10;
    yticklabels = 2:2:20;
    set(gca, 'XTick', 1:10, 'XTickLabel', xticklabels)
    set(gca, 'YTick', 1:10, 'YTickLabel', yticklabels)
    
    % plot max
    subplot(3,3,3*(g-1)+3)
    imagesc(squeeze(output(g, :,:,3)),[0 1])
    title(['Maximum Flow in ' GRAPH_TYPES{g} ' (max)'])
    xlabel('number of nodes')
    ylabel('group fraction')
    xticklabels = n_min:n_min:n_min*10;
    yticklabels = 2:2:20;
    set(gca, 'XTick', 1:10, 'XTickLabel', xticklabels)
    set(gca, 'YTick', 1:10, 'YTickLabel', yticklabels)

end
%% drawing error bars
figure;
for g = 1 : 3
    subplot(1,3,g); 
    errorbar([n_min:n_min:n_min*10], output(g,:,3,1), squeeze(output(g,:,3,1) - output(g,:,3,2)), squeeze(output(g,:,3,1) - output(g,:,3,3)))
    title([GRAPH_TYPES{g} ' (6%)'])
    xlim([0,550])
    ylim([0,1.1])
    xlabel('Network size')
    ylabel('F_{max}^{n}')
    box off
end
%%

% saving the figure in the folder
savefig([folder_name '/fig_n' num2str(n)] )


