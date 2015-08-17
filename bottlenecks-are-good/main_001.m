%MAIN Exploring the effect of bottlenecks on network robustness.
% in this file we compare the maximum flow between three types of networks
% with equal density. For each network we choose two hubs and 10% of nodes
% around each hub. The first group is the source and the second group is the 
% target.
%
% 2015 Bijan Ranjbar-Sahraei, Delft Univeristy

%% preprations
addpath('Daan') % adding path to Daan's Generative Models
clear all
clc

%% Initialization
K = 10;  % number of experiments
n = 50;  % number of nodes 
source_size = n/10;  % size of source group
target_size = n/10;  % size of target group

GRAPH_TYPES = { 'Scale-Free' 'Small-World' 'Random' };  % type of graph from ['Erdos-Renyi', 'Scale-Free', 'Small-World']

output = zeros(size(GRAPH_TYPES,2), K); % the output file for different networks and different experimetns

% creat a new folder to save files in
folder_name = ['gephi/gephi_' num2str(ceil(rand*10000))];
mkdir(folder_name) 

for g = 1 : 3  % for each type of network
    
    MaxFlow_min = 1000; MaxFlow_max = -1000;  % these two help in saving the Ws with min and max MaxFlow
    for k = 1 : K
        
        if k > 1
            fprintf('the estimated remaining time is %.2f minutes \n', (toc *(K-k) + toc * K * (3 - g)) / 60 )
        end
        tic
        %% generate a network

        
        [W, hubs] = generate_network(n, GRAPH_TYPES{g});  % generate a random network
        
        % choose two hubs as the center of source and target
        source_center = hubs(1);
        target_center = hubs(2);

         
        % augmenting the W
        source_group = zeros(1,n);
        target_geroup = zeros(n+2,1);
        source_group(get_m_neighbors(W,source_center,source_size)) = 1;
        target_geroup(get_m_neighbors(W,target_center,target_size)) = 1;
        W_aug = [[W;source_group;zeros(1,n)],zeros(n+2,1),target_geroup];
        
        
        % the last node is the target, and the second last is the source
        source = n+1;
        target = n+2;

        % directionalize the W matrix
        W_di = BFS(W_aug, source, target);

        % compute the maximum flow from source to target
        W_sparse_directional = sparse(W_di);
        MaxFlow = graphmaxflow(W_sparse_directional, source, target);
        output(g, k) = MaxFlow;
        
        % store the network if it has the minimum MinFlow
        if MaxFlow < MaxFlow_min
            Wmin_aug = W_aug; MaxFlow_min = MaxFlow;
        end
        
        % store the network if it has the maximum MaxFlow
        if MaxFlow > MaxFlow_max
            Wmax_aug = W_aug; MaxFlow_max = MaxFlow;
        end

    end
    
    % save the networks with maximum and minimum MaxFlow
    file_name = [folder_name '/graph_' GRAPH_TYPES{g} '_n' num2str(n) '_id' num2str(k) '_min_' num2str(MaxFlow_min)];
    dlmwrite(file_name,[[0:n+2];[[1:n+2]',[Wmin_aug]]],'delimiter',';')
    file_name = [folder_name '/graph_' GRAPH_TYPES{g} '_n' num2str(n) '_id' num2str(k) '_max_' num2str(MaxFlow_max)];
    dlmwrite(file_name,[[0:n+2];[[1:n+2]',[Wmax_aug]]],'delimiter',';')

end

%% plotting the results
close all
figure;
for g = 1 : 3
    MaxFlow = output(g, :); 

    subplot(1,3,g); 
    plot(MaxFlow,'o'); 
    ylim([0,max(MaxFlow)])
    xlabel('Sample Networks')
    ylabel('Max Flow') 
    title(GRAPH_TYPES{g})
end

% saving the figure in the folder
savefig([folder_name '/fig_n' num2str(n)] )


