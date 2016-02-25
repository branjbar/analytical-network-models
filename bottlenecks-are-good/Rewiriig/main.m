%% Initialization


%TODO: see if you can change the maxFlow for the two hubs with maximum
%degree!
% add Daan's folder before running code
N = 100;
m = 2;
n = m+1; % initial graph 
m0 = ones(n,n) - eye(n); 
%W = generateScaleFree( N, m0, m );
%W = generateRegular( N, 2*m );
W = generateSmallWorld(N,2*m,.4);
%
results = [1,1];
i = 1;
for source = 1 : N
    for target = 1 : N
        if ~(source == target)
            % source = 1;
            % target = 1;
            % while( source == target) 
            %    two_random_numbers = ceil(rand(1,2)*N); 
            %    source = two_random_numbers(1);
            %    target = two_random_numbers(2);
            % end
            W_di = BFS(W, source, target);
            W_sparse_directional = sparse(W_di);

            MaxFlow = graphmaxflow(W_sparse_directional, source, target);
            %fprintf(fileID,'%d;%d\n', MaxFlow, ...
             %   min(sum(W_di(source,:)), sum(W_di(:,target))));
            results(i,:) = [floor(MaxFlow), min(sum(W_di(source,:)), sum(W_di(:,target)))];
            i = i+1;
        end
    end
end

%%
