%DISTRIBUTED_CONTROL generates a network, randomly choses some outputs and
%then finds the local-driver nodes which can control the outputs.

%% preprations
addpath('Daan') % adding path to Daan's Generative Models
clc
close all
clear all

n = 500;
GRAPH_TYPES = {'Scale-Free'  'Random' };

plot_count = 0;
for g = 1 : 2
    for k = .5
        fprintf(['generating ' GRAPH_TYPES{g} '\n'])
        W = generate_network(n, GRAPH_TYPES{g});
        
        deg = sum(W,2); % undirected degrees computation

        for i = 1 : n
            for j = i+1 : n
                if deg(i) > deg(j)
                    if rand < .5
                        W(i,j) = 0;  % hubs --> smaller nodes
                    else
                        W(j,i) = 0;    
                    end
                else
                    if rand < .5
                        W(j,i) = 0;  % hubs <-- smaller nodes
                    else
                        W(i,j) = 0;    
                    end
                end
            end
        end

        for i = 1 : n
            if sum(sum(W(i,:))) > 0
                W(i,:) = W(i,:) / sum(W(i,:));
                W(i,i) = 0;
            end
        end


        plot_count = plot_count + 1;
        subplot(1,2,plot_count)
        [I,J] = estimate_ij_star(W, true);


        title([GRAPH_TYPES{g} '(' num2str(k) ')'])
    end
end

