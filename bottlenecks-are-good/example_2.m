%MAIN Exploring the effect of bottlenecks on network robustness.
%  2015 Bijan Ranjbar-Sahraei, Delft Univeristy

%% preprations
addpath('Daan') % adding path to Daan's Generative Models
clear all
clc

%% determine number of nodes and type of the graph
n = 20;  % number of nodes

% generate a random graph
% GRAPH_TYPE = 'Scale-Free';  % type of graph from ['Erdos-Renyi', 'Scale-Free', 'Small-World']
% [W, hubs] = generate_network(n, GRAPH_TYPE);  
% 
% % pick a random source and target
% random_hubs = hubs(randsample(5,2)); 
% source = random_hubs(1); 
% target = random_hubs(2);

% load a sampel graph
load W_4_example_2
source = 1; target = 6 ;


% directionlize the network based on source and target
W_di = BFS(W, source, target);

%% Count number of min-cut sets and their size
W_sparse_directional = sparse(W_di);
[MaxFlow, FlowMatrix, Cut] = graphmaxflow(W_sparse_directional, source, target);
fprintf('\n\n\n%d ---> %d \nMax Flow \t=\t%.0f \n', source, target, MaxFlow)
fprintf('degree(source) \t= \t%d \ndegree(target) \t= \t%d \n'...
    , sum(W(source,:)),sum(W(target,:)))

RichClub = rich_club_bu(W);
degree_source = sum(W(source,:));
degree_target = sum(W(target,:));
output = [MaxFlow, mean([degree_source, degree_target]), nanmean(RichClub)];

%% visualize the networks and min-cut set
h = view(biograph(W_sparse_directional,[]));  % vizualizing the directed network
[~,i] = min(abs(sum(Cut,2) - n/2));  % choose the cut set with equal size of sets on both sides.
set(h.Nodes(Cut(i,:)),'Color',[1 0 0]); % colloring the sets S and T in red and yellow
set(h.Nodes(source),'Color',[1 0 .8]);
set(h.Nodes(target),'Color',[1 1 0]);

