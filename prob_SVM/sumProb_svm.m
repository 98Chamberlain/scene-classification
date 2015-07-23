function sum_prob = sumProb_svm( fea , model , mf , nrm )
% give SVM model and mf and nrm, calculate the d_value after prediction
% fea = 205 * 1

sum_prob(1,40) = 0;
fea = fea';

for i = 1:40
    [m2,N]=size(fea);
    fea_tmp=(fea-ones(m2,1)*mf{i})*nrm{i};
    [predicted, accuracy, d_values] = svmpredict(1 , fea_tmp , model{i});
    if model{i}.Label(1) == 0
        sum_prob(i) = -d_values;
    elseif model{i}.Label(1) == 1
        sum_prob(i) = d_values;
    end
end

