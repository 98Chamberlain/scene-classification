function [model,mf,nrm] = training_svm( features , label )


addpath('../SVM/libsvm-3.20/matlab');

% features_a = [c_data(:,1:50),t_data(:,1:50)]';
% label_a = [ones(1,50),zeros(1,50)]';

% scaling
[m,N]=size(features);
mf=mean(features);
nrm=diag(1./std(features,1));

features_1=(features-ones(m,1)*mf)*nrm;

% SVM
model = svmtrain(label , features_1);

end

