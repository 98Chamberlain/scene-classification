function result = searchBest_hr(adj_mat,sum_prob,feature,model,mf,nrm)
% Hierachy search the best path

feature = feature';
thr = 0.5;
len = length(adj_mat);
% thr_m = 0.5*ones(1,len);

% determine the hierachy
i = 1;
% h_list = [1];
result = [1];
value = [];
i_list = 1;
max_result = [1]; % for while loop 
while( ~isempty( max_result ) )

    max_result = [];
    for ind = 1:length(i_list)
        i = i_list(ind);
        % establish the hierachy list
        h_list = [];
        for j = 1:len
            if( adj_mat(i,j) == 1 && adj_mat(j,i) == 0 )
                if isempty(h_list)
                    h_list = [h_list , j];
                % elseif ( (isempty(h_list)==0) && (prod(adj_mat(j,h_list))==0) )
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
    
    
    % determine the best path
    if isempty(h_list) % maintain max_result 
        
    else
        h_len = length(h_list);
        if h_len == 1; % 
            if (sum_prob(h_list)./sum_prob(i)) >= thr % threshold
                max_result = [max_result , h_list(1)];
                max_prob = prod( exp(sum_prob([result,h_list])) );
            else
                max_prob = prod( exp(sum_prob(result)) );
            end
        else
            valid = 1;
            max_prob = 0;
            % max_result = [];
%             if ~isempty(model{i})
%                 
%                 [m2,~]=size(feature);
%                 feature_t =(feature - ones(m2,1)*mf{i})*nrm{i};
%                 predicted = svmpredict(1 , feature_t , model{i});
%                 if predicted == 1
%                     p_list = h_list;
%                 else
%                     p_list = [];
%                 end
%             else
               p_list =  h_list( (sum_prob(h_list)./sum_prob(i)) >= thr ); % threshold
%                p_list = h_list;
%             end
            if isempty(p_list)
                % max_result = [];
                max_prob = prod( exp(sum_prob(result)) );
            else
                
            r_list = []; % result list
            for p1 = 1:length(p_list)
                if isempty(r_list)
                    max_prob = prod( exp(sum_prob([result])) );
                    prob_tmp = prod( exp(sum_prob([result,p_list(p1)])) );
                    % disp(['now calculate ',num2str([result,p_list(p1)]),', the valid is ' ,num2str(valid),', the prob is ' ,num2str(prob_tmp)]);
                    if prob_tmp > max_prob
                        max_prob = prob_tmp;
                        r_list = [r_list , p_list(p1)];
                    end               
                else
                    r_len = length(r_list);
                    valid_m = zeros(1,r_len);
                    for r = 1:r_len
                        index = zeros(len,1);
                        index([result,p_list(p1),r_list(r)]) = 1;                        
                        valid_m(1,r) = isValid(adj_mat,index,p_list(p1),r_list(r));
                    end
                        
                    if ( prod(valid_m) == 1 ) % 
                        prob_tmp = prod( exp(sum_prob([result,r_list,p_list(p1)])) );
                        if ( prob_tmp > prod( exp(sum_prob([result,r_list])) ) ) 
                            r_list = [r_list , p_list(p1)];
                        end
                    else % 
                        prob_tmp = prod( exp(sum_prob([result,p_list(p1)])) );
                        if ( prob_tmp > prod( exp(sum_prob([result,r_list])) ) ) 
                            r_list = p_list(p1);
                        end
                    end
                end
            end
                max_result = [max_result , r_list];
%                 for h2 = h1+1:h_len % problem
%                     index = zeros(len,1);
%                     index([result,h_list(h1),h_list(h2)]) = 1;
%                     if ( ~isValid(adj_mat,index,h_list(h1),h_list(h2)) )
%                         valid = 0;
%                         break;
%                     else
%                         prob_tmp = prod( exp(sum_prob([result,h_list(h1),h_list(h2)])) );
%                         disp(['now calculate ',num2str([result,h_list(h1),h_list(h2)]),', the valid is ' ,num2str(valid),', the prob is ' ,num2str(prob_tmp)]);
%                         if prob_tmp > max_prob
%                             max_prob = prob_tmp;
%                             max_result = [h_list(h1),h_list(h2)];
%                         end
%                     end
%                 end
% %                 if ( valid == 0 )
% %                     break;
% %                 else
%                     prob_tmp = prod( exp(sum_prob([result,h_list(h1)])) );
%                     disp(['now calculate ',num2str([result,h_list(h1)]),', the valid is ' ,num2str(valid),', the prob is ' ,num2str(prob_tmp)]);
%                     if prob_tmp > max_prob
%                         max_prob = prob_tmp;
%                         max_result = h_list(h1);
%                     end
% %                 end
            
            end
        end
        result = [result,max_result];
        value = [value,max_prob];
    end
    
    end
    i_list = max_result;
end


end
