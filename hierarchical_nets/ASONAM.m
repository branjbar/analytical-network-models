%%Implementation of the ASONAM paper
% Reference B. Ranjbar-Sahraei, H. Bou-Ammar, K. Tuyls, G. Weiss, "On the Skewed Degree Distribution of Hierarchical Networks", In Proceedings of the IEEE/ACM International Conference on Advances in Social Networks Analysis and Mining (ASONAM), Paris, France, 2015.

%% initialization
n = 10;  % number of nodes
W = zeros(n,n);  % the triangular weighted adjacency matrix 
Time = 10;  % number of evolution iterations
deltaT = .1;
W(1,1) = 1;  % initialize a link between node 2 and node 1
%% define the update rule
clc
for t = 1 : Time
    Psi = W;
    
    for i = 1 : n
        Psi = Psi + [zeros(n,i), W(:,1:n-i)];
    end
    
    dW = Psi ./ (sum(Psi,2) * ones(1,n));
    W = W + dW * deltaT;
end

W
   

%% let the system evolve

%% visualize the network characteristics
