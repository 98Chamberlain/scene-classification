function result = searchBest_bf(adj_mat,sum_prob)
% brute force search the best path

len = length(adj_mat);
i = 0;
prob = zeros(2^(len),1);
% time = cell(2^(len),1);
tic;
while ( i < 2^(len) )
    % tic;
    index = dec2bin(i,len);
    disp(['----- now calculate ',index,' -----']);
    valid = 1;
    prob_tmp = 1;
    for x = 1:len
        for y = x+1:len
            if ( ~isValid(adj_mat,index,x,y) )
                valid = 0;
                break;
            end
        end
        if ( valid == 0 )
            break;
        end
    end
    if (valid)
        prob_tmp = prod( exp(sum_prob(index == '1')) );
        disp(['now calculate ',index,', the valid is ' ,num2str(valid),', the prob is ' ,num2str(prob_tmp)]);
%         sumprob_tmp = sum_prob(index == '1');
%         sumprob_norm = sumprob_tmp./sum(sumprob_tmp(:));
%         prob_tmp = sum( exp(sumprob_norm) );
    end
    % disp(['now calculate ',index,', the valid is ' ,num2str(valid),', the prob is ' ,num2str(prob_tmp)]);
    prob(i+1,1) = prob_tmp;
    % time(i+1,1) = {num2str(toc)};
    i = i+1;
end
toc

[m,ind] = max(prob(:));
result = dec2bin(ind-1,len);
disp(['the best result is ',result]);

end