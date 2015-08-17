function [I,J] = estimate_ij_star(W, plot_flag)
% Estimate IJ STAR
% Estimate sizes of $F_{I^*}$ and $J^*$. The former one is equal to the
% number of sensors needed to decouple disturbances and the latter one is
% the number of nodes whitin the community which can be controlled.

        n = size(W,1);
        INF = zeros(floor(n/10),n,n);
        for d = 1 : 20  % for distance between u and y equal to d
            INF(d,:,:) = (W')^d;
            for i = 1 : n  % for every node
                
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
        legend('|F_{I^*}|','|J^*|','Location','NorthWest')
        xlabel('L(u-->y)')
        ylabel('size')

    end
end