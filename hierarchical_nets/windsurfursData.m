%% VALIDATING THE WINDSURFURS DATASET (Prestige-based Attachment Model) (to be checked)
% 
% 
% <<windsurfurs.jpg>>
% 
% Observations of 43 individuals were made for 31 days. All interpersonal 
% contacts among collections of these individuals were recorded. 
%
% Source: <http://moreno.ss.uci.edu/data.html#beach>

%% Importing Data
clear all
load windsurfurs_data

%% Preprocessing 
% Preprocessing the data to make it lower triangular and normalized.
n = size(data,1);
data_tril = tril(data,-1);

%% 
% Whenever an agent doesn't have any decendent, we give it a self loop.
for i = 1 : n
    if sum(data_tril(i,:)) == 0
        data_tril(i,i) = 1;
    end
end
data_normalized = data_tril ./ (sum(data_tril,2) * ones(1,n)) ;


%% 
% Extracting the network hierarchy
H = data_normalized > 0;
W_tril = tril(data_normalized,-1);
W = W_tril + W_tril';
for i = 1 : n
    if sum(W_tril(i,:)) == 0
        W(i,i) = 1;
    end
end

%% Degree Distribution
% Here we compare the degree distribution with exponential and power law
% distributions.

ccdf_x = 1:.1:max(sum(W,2));  % the partitions of the x-axis
df_hist = hist(sum(W,2),ccdf_x);
ccdf_hist = cumsum(df_hist(end:-1:1));
ccdf_hist = ccdf_hist(end:-1:1);  % computing the cummulative degree distribution
subplot(121)
semilogy(ccdf_x, ccdf_hist,'-o')
hold on
semilogy(ccdf_x, exp(-ccdf_x),':')  % approximation of power law
semilogy(ccdf_x, exp(5-ccdf_x),'-.')  % approximation of power law
legend('wolves','exponent','exponent - 5')


subplot(122)
loglog(ccdf_x, ccdf_hist,'-o')
hold on
loglog(ccdf_x, n * ccdf_x.^(-2),':')  % approximation of power law
loglog(ccdf_x, n * ccdf_x.^(-1),'-.')  % approximation of power law
legend('wolves','power law,2','power law,3')



%% Strength Distribution Predictions
% Using the hierarchy network, we generate the PA model and compare the
% predicted strength distributions and real distribution.
Wg = genericModel(H,'PA');

ccdf_x_g = 1:.1:max(sum(Wg,2));  % the partitions of the x-axis
df_hist_g = hist(sum(Wg,2),ccdf_x_g);
ccdf_hist_g = cumsum(df_hist_g(end:-1:1));
ccdf_hist_g = ccdf_hist_g(end:-1:1);  % computing the cummulative degree distribution


figure
plot(ccdf_x,ccdf_hist,'o')
hold on
plot(ccdf_x_g,ccdf_hist_g,'*')
legend('Real-World Data','PA predictions')

%% Edge Comparison
% In the previous section we showed the predictions of strength
% distributions. In this section, we compare the single weights with each
% other.

edges = tril(W,-1);
edgesG = tril(Wg,-1);


figure
plot(edges(:),edgesG(:),'o'); lsline
xlabel('real edge weights')
ylabel('predicted edge weights')

