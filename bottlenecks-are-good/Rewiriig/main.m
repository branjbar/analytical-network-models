%% Initialization


%TODO: see if you can change the maxFlow for the two hubs with maximum
%degree!
% add Daan's folder before running code
N = 200;
m = 2;
n = m+1; % initial graph 
m0 = ones(n,n) - eye(n); 
W = generateScaleFree( N, m0, m );
W1 = W;
max_flow_list = [];

% storing the best and worst networks
best_W = zeros(N,N);
best_flow = 100;
worst_W = zeros(N,N);
worst_flow = 0;

% for-loop
best_W = W1;
worst_W = W1;
for i = 1 : 100
    W1 = randomize_graph_partial_und(best_W,zeros(N,N),20);
    output = get_size_of_largest_linking(W1, 0*N/10+1, 1*N/10);
    max_flow_list(i) = output(5);
    fprintf('in try %d we get %d \n', i, output(5))
    if worst_flow < output(5) 
        worst_flow = output(5);
        worst_W = W1;
    end
    if best_flow > output(5)
        best_flow = output(5);
        best_W = W1;
    end
end

%%
hist(max_flow_list,100)
%%
fileID = fopen('best_W.csv','w');
fprintf(fileID, 'Source,Target,Type\n');

for i = 1 : N
    for j = i+1:N
        if best_W(i,j) == 1
            fprintf(fileID, '%d,%d,undirected\n', i, j);
        end
    end
end


fileID = fopen('worst_W.csv','w');
fprintf(fileID, 'Source,Target,Type\n');

for i = 1 : N
    for j = i+1:N
        if worst_W(i,j) == 1
            fprintf(fileID, '%d,%d,undirected\n', i, j);
        end
    end
end
