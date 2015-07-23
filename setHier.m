function adj_out = setHier( adj_mat , father , son )
% set son be father's son
% son can be a list
% father should be an integer

if ( size(adj_mat,1)~=size(adj_mat,2) )
    error('adjacency matrix mismatch!');
end
if length(find( son == father ))>=1
    error('the son cannot be itself''s father!');
end

adj_out = adj_mat;

len = size(adj_mat,1);
son_len = length(son);

for i = 1:son_len
    if ( ~(adj_out( father,son(i) ) == 1 && adj_out( son(i),father ) == 0) )
        adj_out( father,son(i) ) = 1;
        adj_out( son(i),father ) = 0;
    end
    
    % set the son of the son
    for j = 1:len
        if ( adj_mat( son(i) , j ) == 1 && adj_mat( j , son(i) ) == 0 )
            adj_out( father , j ) = 1;
            adj_out( j , father ) = 0;
        end
    end
end

end

