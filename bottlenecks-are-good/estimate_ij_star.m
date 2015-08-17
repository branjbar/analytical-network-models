function [I,J] = estimate_ij_star(W, plot_flag)
        n = size(W,1);
        INF = zeros(floor(n/10),n,n);
        for d = 1 : 15
            INF(d,:,:) = (W')^d;
            for i = 1 : n
                
                if d > 1
                    J(d,i) = 1 + nnz(sum(INF(1:d-1,i,:),1));
                    
                    x_new = logical(INF(d,i,:));
                    x_old = sum(INF(1:d-1,i,:),1)>0;
                    I(d,i) = nnz(x_new(~x_old)) ;

                else

                    J(d,i) = 1;
                    I(d,i) = length(find(INF(d,i,:)>0));
                end
            end
        end
    I = mean(I,2);
    J = mean(J,2);

    
    if plot_flag
        plot(I,'.:')
        hold on
        plot(J)    
        legend('F_{I^*}','J^*','Location','NorthWest')
        xlabel('L(u-->y)')
        ylabel('size')
%         ylim([1,n/2])
%         xlim([1,size(I,1)])

    end
end