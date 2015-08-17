function [W, hubs] = generate_network(n, GRAPH_TYPE)
%GENERATE_NETWORK generates a connected random network
% W = generate_network(n, graph_type) returns the adjacency matrix of a
% GRAPH_TYPE random graph with n nodes.
%
% GRAPH_TYPE: is the type of graph Erdos?Renyi, Scale-Free or Small-World
%
%
% Example:
%            W = generate_network(20, 'Erdos?Renyi')
%            returns a random graph with 20 nodes.


    W_connected = false;  % to make sure generated graphs are connected
    
    switch GRAPH_TYPE
        case 'Erdos-Renyi'
            p = 2 * log(n)/n; % wiring probablity
%             p = 4/(n-1); %  n(n-1)p/2 =  4n
            while (~W_connected)
                W = generateRandom( n, p );
                W_connected = true; %isConnected( W );
                if ~W_connected
                    %fprintf('the Erdos-Renyi graph should be regenerated\n')
                end
            end
            
        case 'Scale-Free'
            m0 = [ 0, 1, 1; 1, 0, 1; 1, 1, 0 ]; % initial nodes for scale free network
            m = 2; % number of added connections in each iteration
            while ~W_connected
                W = generateScaleFree( n, m0, m );
                W_connected = true; %isConnected( W );
                if ~W_connected
                    fprintf('the Scale-Free graph should be regenerated\n')
                end
            end
%             W = randmio_und(W,200); % here we randomize the network while preserving the degree distribution 

        case 'Small-World'
            k = 4;  % mean degree 
            beta = .3;  % rewiring probablity
            while ~W_connected
                W = generateSmallWorld( n, k, beta );
                W_connected = true; %isConnected( W );
                if ~W_connected
                    fprintf('the Small-World graph should be regenerated\n')
                end
            end
            %W = randmio_und(W,200);
        case 'Random'
            k = 4;  % mean degree 
            beta = 1;  % rewiring probablity
            W = generateSmallWorld( n, k, beta );

        case 'Regular'
            d = 4;
            W = generateRegular(n,d);
    end
    % here we extract the top 5 degree nodes as hubs
    degree = sum(W,2);
    [~,I] = sort(degree, 'descend');
    hubs = I(1:5);
end

 