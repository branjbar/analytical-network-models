%%Implementation of the ASONAM paper
% Reference B. Ranjbar-Sahraei, H. Bou-Ammar, K. Tuyls, G. Weiss, "On the Skewed Degree Distribution of Hierarchical Networks", In Proceedings of the IEEE/ACM International Conference on Advances in Social Networks Analysis and Mining (ASONAM), Paris, France, 2015.

close all
clear all
clc

%% initialization

n = 300;  % number of nodes
W = zeros(n,n);  % the triangular weighted adjacency matrix 
Time = 10;  % number of evolution iterations
deltaT = 1;
W(1,1) = 1;  % initialize a link between node 2 and node 1
%% define the update rule
clc
for t = 1 : Time
    Psi = W;
    
    for i = 1 : n
        Psi = Psi + [zeros(i,n); W(1:n-i,:)];
    end
    
    Psi = tril(Psi,-1);  % just keep the lower triangular part of Psi without the diagonal elements
    Psi(1,1) = 1;  % to avoid NAN in first round
    
    dW = Psi ./ (sum(Psi,2) * ones(1,n)) - W;
    W = W + dW * deltaT;  % evolve W based on dW
    W = tril(W) + tril(W,-1)';  % make W symmetric and skip W(1,1)

    
    % plotting online the degree distribution
    ccdf_x = 1:.1:max(sum(W,2));  % the partitions of the x-axis
    df_hist = hist(sum(W,2),ccdf_x);
    ccdf_hist = cumsum(df_hist(end:-1:1));
    ccdf_hist = ccdf_hist(end:-1:1);  % computing the cummulative degree distribution
    
    
    loglog(1:.1:max(sum(W,2)), ccdf_hist,'-o'); lsline
    
    pause(.1)
end

%% Final Visualization
loglog(ccdf_x, ccdf_hist,'-o'); lsline
hold on
plot(ccdf_x, n * ccdf_x.^(-2))  % approximation of power law
legend('real system', 'power law estimation')
