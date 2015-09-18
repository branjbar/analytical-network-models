%%ANALYSE INFLUENCE LAYERS OF REAL WORLD NETWORKS
% 
% 2015 Bijan Ranjbar-Sahraei, Delft Univeristy
close all
clc

%% import data
clear all
%% 
% This network was constructed from the USA's FAA (Federal Aviation Administration) 
% National Flight Data Center (NFDC), Preferred Routes Database. Nodes in this 
% network represent airports or service centers and links are created from strings
% of preferred routes recommended by the NFDC.

% load out_maayan_faa

%%
% This undirected network contains information about the power grid of the 
% Western States of the United States of America. An edge represents a power 
% supply line. A node is either a generator, a transformator or a substation.
load out_power_grid


%%
% This undirected network contains information about the power grid of the 
% Western States of the United States of America. An edge represents a power 
% supply line. A node is either a generator, a transformator or a substation.
% load out_euro_road  

%% turn data into adjacency matrix

n = max(max(data));  % number of nodes
W = zeros(n,n);
for i = 1 : size(data,1)
    W(data(i,1),data(i,2)) = 1;
end
W = W + W';
%% plotting the size of layers
diam = 50;
L = zeros(n,diam);
L(:,1) = sum(W>0,2); 

WP_old = W;
S = W>0;  % all nodes which are reached so far 
i = 2;
while  ((n^2 - sum(sum(S)))>0) || (i > diam)
    i
    WP_new = (WP_old * W) > 0;  % find every ith subordinate of every node
    L_tmp = (WP_new - S) > 0;  % let's find the nodes that are recently seen and truncate the wights to 1
    L(:,i) = sum(L_tmp,1);
    S = (S + WP_new) > 0;  % all nodes which are reached so far 
    WP_old = WP_new;
    i = i +1;
end


figure
plot(L')

%% get the node size

node_size = zeros(1,n);
for i = 1 : n
%     b = polyfit(1:diam,L(i,:),1);
    node_size(i) = 0;
    for j = 1 : size(L,2)
        node_size(i) = node_size(i) + 0.5^(j-1)*L(i,j);
    end
    node_size(i) = 1 / node_size(i) ;
end

figure; plot(node_size,'*')
%% export for gephi
export_for_gephi('power_grid',W,node_size);