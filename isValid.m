function bool = isValid(adj_mat,index,x,y)

bool = true;
% exclusion
if ( adj_mat(x,y) == 1 && adj_mat(y,x) == 1 )
    if ( index(x) == 1 && index(y) == 1 )
        bool = false;
    else
        bool = true;
    end
end

% hierarchy
if ( adj_mat(x,y) == 1 && adj_mat(y,x) == 0 )
    if ( index(x) == '0' && index(y) == '1' )
        bool = false;
    else
        bool = true;
    end
end

end

