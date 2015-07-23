function adj_out = setExcl( adj_mat , node1 , node2 )
% set exclusive relation
% node2 can be a list
% node1 should be an integer

if ( size(adj_mat,1)~=size(adj_mat,2) )
    error('adjacency matrix mismatch!');
end
if length(find( node2 == node1 ))>=1
    error('the node cannot be exclusive to itself!');
end

adj_out = adj_mat;

len = size(adj_mat,1);
nd2_len = length(node2);

for i = 1:nd2_len
    if ( ~(adj_out( node1,node2(i) ) == 1 && adj_out( node2(i),node1 ) == 0) )
        adj_out( node1,node2(i) ) = 1;
        adj_out( node2(i),node1 ) = 1;
    end
    
    % set the son of the node2(i)
    for j = 1:len
        if ( adj_mat( node2(i) , j ) == 1 && adj_mat( j , node2(i) ) == 0 )
            adj_out( node1 , j ) = 1;
            adj_out( j , node1 ) = 1;
        end
    end
    % set the son of the node1
    for j = 1:len
        if ( adj_mat( node1 , j ) == 1 && adj_mat( j , node1 ) == 0 )
            adj_out( node2(i) , j ) = 1;
            adj_out( j , node2(i) ) = 1;
        end
    end
end


end

