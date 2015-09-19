function export_for_gephi(graph_name, W, node_size, node_label)
%%EXPORT_TO_GEPHI exports the graph W appropriate for Gephi CSV file 

%% node table
nodeTable = fopen(strcat(graph_name,'[Nodes].csv'),'w');
fprintf(nodeTable,'Id,Label,size\n');
n = size(W,1);

% write the first line as 1;2;3;...;n
for i = 1 : n
    fprintf(nodeTable,'%d,%s,%2f\n',i,node_label{i},node_size(i));  % start with the node id
end
fclose(nodeTable);

%% edge table
edgeTable = fopen(strcat(graph_name,'[Edges].csv'),'w');
fprintf(edgeTable,'Source,Target,Type,Id,Label,Weight\n');
edge_count = 1;
for i = 1 : n
    for j = 1 : n
        if W(i,j)>0
            fprintf(edgeTable,'%d,%d,Undirected,%d,%d,1\n',i,j,edge_count,edge_count);  % start with the node id
        edge_count = edge_count + 1;
        end
    end
end
            
end
