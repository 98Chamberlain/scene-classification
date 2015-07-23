% adj_mat = genAdj(6);
% adj_mat = setHier(adj_mat,2,4);
% adj_mat = setHier(adj_mat,1,[2,3]);
% adj_mat = setHier(adj_mat,5,6);
% adj_mat = setRela(adj_mat,3,5);
% adj_mat = setRela(adj_mat,3,4);

adj_mat = genAdj(6,'exclusive');
adj_mat = setHier(adj_mat,2,4);
adj_mat = setHier(adj_mat,1,[2,3]);
adj_mat = setHier(adj_mat,5,6);
adj_mat = setExcl(adj_mat,1,6);
adj_mat = setExcl(adj_mat,2,5);