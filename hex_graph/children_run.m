function [ children ] = children_run( adj_mat )
% determine the hierachy

len = length(adj_mat);
children = cell(len,1);

for i = 1:len
    % establish the hierachy list
    h_list = [];
    for j = 1:len
        if( adj_mat(i,j) == 1 && adj_mat(j,i) == 0 )
            if isempty(h_list)
                h_list = [h_list , j];    
            else
                for h_i = 1:length(h_list)
                    if ( (adj_mat(j,h_list(h_i)) == 0) && (adj_mat(h_list(h_i),j) == 0) )
                        h_list = [h_list , j];
                    end
                end
                if (isempty(h_list)==0) && (prod(adj_mat(j,h_list))==0)
                else
                    h_list = [h_list , j];
                end
            end
        end
    end
    children{i} = h_list;
end

end

