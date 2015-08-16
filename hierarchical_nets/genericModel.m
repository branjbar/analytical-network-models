function Wg= genericModel(H, model)
%% Generic ModelA
% A generic model for constructing hierarchical models. First, an arbitrary hierarchy structury is chosen, and then the
% update rules are generated. Based on update rules the edge weights are
% evolved and the evolution is demonstrated in real time.
% Link to datasets: http://moreno.ss.uci.edu/data.html

% model can be Dominance-based Attachment (DA) or Prestige-based Attachment (PA).  
if nargin == 0
   H = tril(ones(n,n),-1); % ASONAM model
   model = 'PA';
end

if nargin == 1
    model = 'PA';
end


%% initialization
n = size(H,1);  % number of nodes
Time = 100;  % number of iterations
deltaT = .1;  % time steps

%% Define the Hierarchy relations by using a binary n x n matrix
% the element [i,j] of H is 1 if i is superior to j.
% H = tril(ones(n,n),-1); % ASONAM model
% H(1,1) = 1;
% H = [ones(n,1),[zeros(1,n-1); rand(n-1,n-1)>.7]];  % a very random network


% A --> MODULE1 --> MODULE2
%     n = 2 * floor(n/2) + 1;
%     module = tril(ones((n-1)/2,(n-1)/2),-1);
%     H = [zeros(n,1),[zeros(1,n-1) ; [module, 0 * module ; 0 * module, module]]];
%     H(1,1) = 1;
% 
%     H(2,1) = 1;
%     H(3,1) = 1;
% 
%     H((n-1)/2+2,(n-1)/2+1) = 1;
%     H((n-1)/2+2,(n-1)/2) = 1;
%     H((n-1)/2+3,(n-1)/2) = 1;


%load('WolfH')
    %% Initialize the weights
    Wg = zeros(n,n);
    Wg(1,1) = 1;


    %% Construct the Psi and dW update rules and evolve the network

    for t = 1 : Time
        dW = zeros(n,n);
        Psi = zeros(n,n);
        for i = 1 : n
            for j = 1 : n
                if H(i,j) == 1  % if i is superior to j
                    Psi(i,j) = 0;
                    for k = 1 : n
                        if (k < i) || H(i,k) == 1  % the latter is for H(1,1)=1
%                         if H(i,k) == 1  % if i is superior to k
                            if strcmp(model,'PA')
                                Psi(i,j) = Psi(i,j) + Wg(j,k);
                            else
                                Psi(i,j) = Psi(i,j) + 1;
                            end
                        end
                    end
                end
            end

            for j = 1 : n
                if H(i,j) == 1  % if j is superior to k
                    dW(i,j) = Psi(i,j) / sum(Psi(i,:)) - Wg(i,j);
                end
            end
        end
        dW(isnan(dW)) = 0 ;  % replace NANs by zero

        Wg = tril(Wg) + deltaT * dW;
        Wg = tril(Wg) + tril(Wg,-1)';  % make W symmetric and skip W(1,1)
    end
end
%         % plotting online the degree distribution
%         ccdf_x = 1:.1:max(sum(Wg,2));  % the partitions of the x-axis
%         df_hist = hist(sum(Wg,2),ccdf_x);
%         ccdf_hist = cumsum(df_hist(end:-1:1));
%         ccdf_hist = ccdf_hist(end:-1:1);  % computing the cummulative degree distribution
%     %     
%     %     
%     %     subplot(211)
%     %     loglog(ccdf_x, ccdf_hist,'-o')
%     %     hold off
%     % 
%     %     subplot(212)
%     %     plot(1:n,sum(W,2),'o')
%     %     
%     %     pause(.1)
% 
%     end
% 
% 
% 
%     % %% Final Visualization
%     % subplot(211)
%     % loglog(ccdf_x, ccdf_hist,'-o')
%     % hold on
%     % loglog(ccdf_x, n * ccdf_x.^(-2),':')  % approximation of power law
%     % loglog(ccdf_x, n * ccdf_x.^(-1),'-.')  % approximation of power law
%     % legend('real system', 'power law \alpha=-3','power law \alpha=-2')
%     % 
%     % 
%     % 
% 
%     %% Final Visulaizaiton
%     ccdf_x = 1:.1:max(sum(Wg,2));  % the partitions of the x-axis
%     df_hist = hist(sum(Wg,2),ccdf_x);
%     ccdf_hist = cumsum(df_hist(end:-1:1));
%     ccdf_hist = ccdf_hist(end:-1:1);  % computing the cummulative degree distribution
%     subplot(221)
%     semilogy(ccdf_x, ccdf_hist,'-o')
%     hold on
%     semilogy(ccdf_x, exp(-ccdf_x),':')  % approximation of power law
%     semilogy(ccdf_x, exp(5-ccdf_x),'-.')  % approximation of power law
% 
% 
%     subplot(222)
%     loglog(ccdf_x, ccdf_hist,'-o')
%     hold on
%     loglog(ccdf_x, n * ccdf_x.^(-2),':')  % approximation of power law
%     loglog(ccdf_x, n * ccdf_x.^(-1),'-.')  % approximation of power law
% 
% 
%     subplot(212)
%     plot(ccdf_x,ccdf_hist,'o')
%     hold on
%     plot(ccdf_x,n * ccdf_x.^(-2),'*')
%     plot(ccdf_x,0.3*16*exp(-ccdf_x),'.')
