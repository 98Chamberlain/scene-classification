function adj_mat = genAdj( num_label , mode)
% initial the adjacency matrix that is one in everywhere except the diagnal
if ( ~exist('mode','var') )
    mode = 'related';
end

if strcmp(mode , 'related')
    adj_mat = ones(num_label);

    for i = 1:num_label
        adj_mat(i,i) = 0;
    end 
end

if strcmp(mode , 'exclusive')
    adj_mat = zeros(num_label);
end

end

