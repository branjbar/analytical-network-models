% Exploring the effect of bottlenecks on network robustness.
% Bijan Ranjbar-Sahraei, 24 July 2015
% here I add path to some packages that I need

%% preprations
clear all
clc

W_sparse_directional = sparse([1,1,1,2,3,4,5,6,6,6,7,8,9],[2,3,4,5,5,5,6,7,8,9,10,10,10],ones(1,13),10,10);
[MaxFlow, FlowMatrix, Cut] = graphmaxflow(W_sparse_directional, 1, 10);
fprintf('maximum possible flow is %d \n', MaxFlow)

%% visualize the bottlenecks with colors
h = view(biograph(W_sparse_directional,[]));  % vizualizing the directed network
set(h.Nodes(Cut(1,:)),'Color',[1 0 0]); % colloring the sets S and T in red and yellow

