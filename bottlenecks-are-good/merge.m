%MERGE starts from some random nodes and gradually merges the nodes with it's
%neighbors. the goal is to look at changes in degree distribution

%% preprations
addpath('Daan') % adding path to Daan's Generative Models
clc
close all
clear all

n = 1000;
GRAPH_TYPES = { 'Scale-Free'  'Random' };
for g = 1 : 2
    W = generate_network(n, GRAPH_TYPES{g});

    W_original = W;%randmio_und(W,200);

    %% merging process
    for t = 1:10
        t
        count2 = 1;

        n_new = n;
        W = logical(W_original);
        component = ones(n,1);
        while n_new>2
            is = find(component == min(component)); 
%             i = randsample(1:n_new,1);
            i = is(randsample(1:length(is),1));

            js = find(W(i,:) == 1);
            j = js(randsample(1:length(js),1));
            
            % merge j to i
            W(i,W(j,:)) = 1;
            W(W(:,j),i) = 1;
            W(i,i) = 0;
            component(i) = component(i) + component(j);
            % get rid of the jth row and column
            W = W([1:j-1 j+1:n_new],[1:j-1 j+1:n_new]);
            component = component([1:j-1 j+1:n_new]);
            
            
            n_new = size(W,1);
            Deg = sum(W,2);  % degree distribution
            components(g,t, count2) = mean(component);
            cutset(g,t, count2) = max(Deg);
            count2 = count2 + 1;
        end
    end
end

%%
for g = 1 : 2
    subplot(1,2,g)
    
    %plot(squeeze(modularity(g,:,:))','-.')
    plot(squeeze(components(g,:,:))',squeeze(cutset(g,:,:))','.-  ')
    xlabel('average component size')
    ylabel('maximum Max-Flow')
%     subplot(2,3,g+3)
%     plot(squeeze(modularity_c(g,:,:))','-.')
     title(GRAPH_TYPES{g})
end
    