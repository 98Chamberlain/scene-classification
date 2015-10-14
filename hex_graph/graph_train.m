% clear all; close all;

addpath(genpath('../../hex_graph-master'));
addpath('../../Research_Toolkit/SVM/libsvm-3.20/matlab');
addpath(genpath('../'));

% % ----- load the data -----
% load the label name
t = load('../total_label.mat');

% load prob & fc8 data
% prob_data: 205 x 2000 x 205 (feature x data x scene)
% fc8_data : 205 x 2000 x 205 (feature x data x scene)
% load('../feature_data_2000.mat'); % new 2000 data
load('../statistic/feature_data.mat'); % old 128 data

% load ground truth
% groundtruth = {[1],[1,2],[1,3],[1,3,4],[1,5],[1,2,6],[1,2,7],[1,2,8],[1,2,9],[1,3,10],[1,3,4,11],[1,3,4,12],...
%     [1,2,6,13],[1,2,6,14],[1,2,6,15],[1,2,6,16],[1,2,7,17],[1,2,7,18],[1,2,8,19],[1,2,8,20],[1,2,21],[1,2,22],...
%     [1,3,10,23],[1,3,10,24],[1,3,10,25],[1,3,10,26],[1,3,10,27],[1,3,10,28],[1,3,4,11,29],[1,3,4,11,30],[1,3,4,12,31],...
%     [1,3,4,12,32],[1,3,4,12,33],[1,3,4,12,34],[1,3,4,12,35],[1,3,36],[1,3,37],[1,3,38],[1,3,39],[1,3,40]};
% groundtruth 1*40 cell
% gt_scene 1*205 double
load('../gt_scene.mat'); % gt_scene , groundtruth

% % ----- data setting ----
% set the parameter
data_len = size(prob_data,2);
train_amt = round(data_len*0.8); % 2000 -> 1600
test_amt = data_len - train_amt;

% train data setting
train_data = prob_data(:,1:train_amt,root_s);
train_data = train_data(:,:);

% ----- Training -----
addpath('../../Research_Toolkit/SVM/libsvm-3.20/matlab');

tmp = repmat(root_s,[train_amt,1]);
lb_tmp = tmp(:);
label = gt_scene( lb_tmp );

features = train_data';
[model,mf,nrm] = training_svm( features , label' );

% ----- Testing -----

tmp = repmat(root_s,[test_amt,1]);
lb_tmp = tmp(:);
label = gt_scene( lb_tmp );

% train data setting
test_data = prob_data(:,train_amt+1:data_len,root_s);
test_data = test_data(:,:);

[m2,N]=size(test_data');
fea_tmp=(test_data'-ones(m2,1)*mf)*nrm;
[predicted, accuracy, d_values] = svmpredict(label' , fea_tmp , model);


