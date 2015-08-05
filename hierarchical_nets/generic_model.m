%%Generic Model: I have a generic model for constructing hierarchical
%%models. First, an arbitrary hierarchy structury is chosen, and then the
%%update rules are generated. Based on update rules the edge weights are
%%evolved and the evolution is demonstrated in real time.

%% initialization
clear all
figure(2)
hold off
clc
n = 100;  % number of nodes
Time = 100;  % number of iterations
deltaT = .1;  % time steps

%% Define the Hierarchy relations by using a binary n x n matrix
% the element [i,j] of H is 1 if i is superior to j.
%H = tril(ones(n,n),-1); % ASONAM model
% H(1,1) = 1;
% H = [ones(n,1),[zeros(1,n-1); rand(n-1,n-1)>.7]];  % a very random network


% A --> MODULE1 --> MODULE2
    n = 2 * floor(n/2) + 1;
    module = tril(ones((n-1)/2,(n-1)/2),-1);
    H = [zeros(n,1),[zeros(1,n-1) ; [module, 0 * module ; 0 * module, module]]];
    H(1,1) = 1;

    H(2,1) = 1;
    H(3,1) = 1;

    H((n-1)/2+2,(n-1)/2+1) = 1;
    H((n-1)/2+2,(n-1)/2) = 1;
    H((n-1)/2+3,(n-1)/2) = 1;

%% Initialize the weights
W = zeros(n,n);
W(1,1) = 1;


%% Construct the Psi and dW update rules and evolve the network

for t = 1 : Time
    t
    dW = zeros(n,n);
    Psi = zeros(n,n);
    for i = 1 : n
        for j = 1 : n
            if H(i,j) == 1  % if i is superior to j
                Psi(i,j) = 0;
                for k = 1 : n
                    if H(i,k) == 1  % if i is superior to k
                        Psi(i,j) = Psi(i,j) + W(j,k);
                    end
                end
            end
        end

        for j = 1 : n
            if H(i,j) == 1  % if j is superior to k
                dW(i,j) = Psi(i,j) / sum(Psi(i,:)) - W(i,j);
            end
        end
    end
    dW(isnan(dW)) = 0 ;  % replace NANs by zero
    
    W = tril(W) + deltaT * dW;
    W = tril(W) + tril(W,-1)';  % make W symmetric and skip W(1,1)

    % plotting online the degree distribution
    ccdf_x = 1:.1:max(sum(W,2));  % the partitions of the x-axis
    df_hist = hist(sum(W,2),ccdf_x);
    ccdf_hist = cumsum(df_hist(end:-1:1));
    ccdf_hist = ccdf_hist(end:-1:1);  % computing the cummulative degree distribution
    
    
    subplot(211)
    loglog(ccdf_x, ccdf_hist,'-o'); lsline
    hold off

    subplot(212)
    plot(1:n,sum(W,2),'o')
    
    pause(.1)

end

%% Final Visualization
subplot(211)
loglog(ccdf_x, ccdf_hist,'-o'); lsline
hold on
plot(ccdf_x, n * ccdf_x.^(-2),':')  % approximation of power law
plot(ccdf_x, n * ccdf_x.^(-1),'-.')  % approximation of power law
legend('real system', 'power law \alpha=-3','power law \alpha=-2')




