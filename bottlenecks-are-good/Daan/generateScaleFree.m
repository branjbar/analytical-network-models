function [ W ] = generateScaleFree( N, m0, m )
%Generates a scale-free graph following the Barabasi-Albert model.
%   needs final number of node N, initial graph m0 and number of new
%   connections for each consecutive node m, where m <= number of initial
%   nodes.

W = zeros(N);

N_init = size(m0,1);

W(1:N_init, 1:N_init) = m0;

for i = N_init+1:N,
    % calculate prob distr based on node degree
    Wi = datasample(1:i-1,m,'Replace',false,'Weights',sum(W(1:i-1,1:i-1)));
    W(i,Wi) = 1;
    W(Wi,i) = 1;
end

end