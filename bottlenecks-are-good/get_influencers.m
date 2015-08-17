function nbrs = get_influencers(W,nodei,d)
%%GET_INFLUENCERS finds all the neighbors in form of nodej influences nodei after d steps   
% w is the adjacency matrix
% nodei is the the node we're looking for it's influencers
% d is the depth of influencers
%
% Example1:
%           nbrs = get_influencers([0,.5,.5; 0,0,1; 0,0,0],1,1)
%            nbrs = [0;1;1] 
% Example2:
%           nbrs = get_influencers([0,.5,.5; 0,0,1; 0,0,0],1,2)
%            nbrs = [0;0;1] 

n = size(W,1);
x0 = zeros(n,1);
x0(nodei) = 1;


nbrs = logical((W')^d*x0);

end