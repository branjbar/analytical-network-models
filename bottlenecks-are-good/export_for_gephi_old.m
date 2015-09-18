function export_for_gephi(W_di)
%%EXPORT_TO_GEPHI exports the graph W appropriate for Gephi CSV file 
    
    % write the first line as "1;2;3;...;n"
    n = size(W_di);
    for i = 1 : n
        fprintf(';%d',i)
    end
    fprintf('\n')  % go to next line
    
    % write the first line as 1;2;3;...;n
    for i = 1 : n
        
        fprintf('%d;',i)  % start with the node id
        for j = 1 : n
            printf('%d;',W(i,j))  % add the weights
        end
        fprintf('\n')

    end
    
end

