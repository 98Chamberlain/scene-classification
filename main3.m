close all; clear all;
addpath('./prob_SVM/');

% load the label name
load('./total_label.mat');

% setting the parameter
train_amt = 100;
data_len = 128;

% Qualcomm label
% adj_mat = xlsread('scene_matrix.xlsx',1);
adj_mat = make_SceneMatrix();

% read prob form .h5 file
% load('./statistic/feature_data.mat');
% fc8_testing_data = fc8_data(:,train_amt+1:data_len,:);
% fc8_testing_data = fc8_testing_data(:,:);
% prob_testing_data = prob_data(:,train_amt+1:data_len,:);
% prob_testing_data = prob_testing_data(:,:);

% set ground truth
% groundtruth = {[1],[1,2],[1,3],[1,3,4],[1,5],[1,2,6],[1,2,7],[1,2,8],[1,2,9],[1,3,10],[1,3,4,11],[1,3,4,12],...
%     [1,2,6,13],[1,2,6,14],[1,2,6,15],[1,2,6,16],[1,2,7,17],[1,2,7,18],[1,2,8,19],[1,2,8,20],[1,2,21],[1,2,22],...
%     [1,3,10,23],[1,3,10,24],[1,3,10,25],[1,3,10,26],[1,3,10,27],[1,3,10,28],[1,3,4,11,29],[1,3,4,11,30],[1,3,4,12,31],...
%     [1,3,4,12,32],[1,3,4,12,33],[1,3,4,12,34],[1,3,4,12,35],[1,3,36],[1,3,37],[1,3,38],[1,3,39],[1,3,40]};
load('./gt_scene.mat'); % gt_scene , groundtruth

% data pre-process
root_s = [1,2,3,5:1:22,24,25,26,28:1:38,40:1:49,51:1:63,65,66,...
    67,69:1:75,77:1:81,83:1:94,96:1:99,101:1:119,121:1:138,140,142,143,145,...
    147,148,150:1:158,160,162,163,164,166:1:172,174:1:185,189,190,194,195,196,...
    198,199,201,202,205];
use_scene = length(root_s);
	
	% prob_train_data = prob_data(:,1:train_amt,root_s);
% prob_train_data = prob_train_data(:,:);
% prob_test_data = prob_data(:,train_amt+1:data_len,root_s);
% prob_test_data = prob_test_data(:,:);

% % sparse-coding representation
% [ training_SR , testing_SR , D ] = sparse_coding( prob_train_data , prob_test_data );

% % training
% [model,mf,nrm] = prob_SVM( training_SR );

acc = [];
FP = [];
FN = [];
TP = [];
TN = [];
tmp = repmat(root_s,[ (data_len-train_amt) , 1 ]);
scn = tmp(:);
scn = scn';
scene_acc = zeros(205,1);
scene_FP = zeros(205,1);
time = [];
cnt_gt_label = zeros(40,1);
cnt_ac_label = zeros(40,1);
cnt_FP_label = zeros(40,1);
for i = 1:use_scene
% for i = (123-1)*28+1:123*28
% for i = 28:56

% data = hdf5read(['./statistic/toyshop/',d(i).name],'dataset_1');
    scn_index = root_s(i);
	f = dir(['../h5/multi_label_origin_prob_h5',total_label{scn_index+40,2},'/*.h5']);
    for h5_idx = 1:length(f)
	
        % calculate the probability of labels
		data = hdf5read(['../h5/multi_label_origin_prob_h5',total_label{scn_index+40,2},'/',f(h5_idx).name],'prob');
		sum_prob = sumProb_p(data);
        
%         % without relation
%         [M,I] = max(prob_testing_data(:,i));
%         if gt_scene(I) == 0
%             result == 0;
%         else
%             result = groundtruth{gt_scene(I)};
%         end
        
%         % with constant threshold
%         feature = prob_testing_data(:,i);
%         tic
%         result = searchBest_hr(adj_mat,sum_prob,feature,model_prob,mf_prob,nrm_prob);
%         time = [time ,toc];
        
        % use prob feature
        feature = 1;
        model = 1;
        mf = 1;
        nrm = 1;
        tic
        result = searchBest_hr(adj_mat,sum_prob,feature,model,mf,nrm);
        time = [time ,toc];
              
        
        if scn_index == 94
            gt = [1,2,6,7];
        elseif scn_index == 123
            gt = [1,3,4,38,39];
        elseif (scn_index == 2) || (scn_index == 11) || (scn_index == 73)
            gt = [1,2,9];
        elseif (scn_index == 30) || (scn_index == 31)
            gt = [1,2,5];
        elseif (sum([48,66,91,103,162,164] == scn_index) >= 1)
            gt = [1,3,4,12,31,35];
        else
            gt = groundtruth{gt_scene(scn_index)};
        end
        acc = [acc,length(intersect(result,gt))/length(gt)];
        FP = [FP,(length(setdiff(result,intersect(result,gt))))];
		
        cnt_gt_label(gt) = cnt_gt_label(gt)+1;
        cnt_ac_label(intersect(result,gt)) = cnt_ac_label(intersect(result,gt))+1;
        cnt_FP_label(setdiff(result,intersect(result,gt))) = cnt_FP_label(setdiff(result,intersect(result,gt)))+1;
        
% % test
% adj_mat = [0,1,1,1;
%            0,0,1,1;
%            0,1,0,1;
%            1,1,1,0];
% sum_prob = [0.5,0.3,0.2,0.5];
% adj_mat = adj_mat(1:16,1:16);

% ------- Brute force -------
% result = searchBest_bf(adj_mat,sum_prob);

% tic;
% result = searchBest_hr(adj_mat,sum_prob);
% result = searchBest_hr(adj_mat,sum_prob,feature,model,mf,nrm);
% toc

        % display(['the result is: ' , total_label(result,2)']);
        
end

% display the result
for s_id = 1:use_scene
disp(['scene ',num2str(s_id),' mean accuracy: ',num2str(mean(acc( floor((s_id-1)*test_amt+1:s_id*test_amt)))),', sum FP: ',num2str(sum(FP( floor((s_id-1)*test_amt+1:s_id*test_amt))))])
end
disp(['total mean accuracy: ',num2str(mean(acc)),', sum FP: ',num2str(sum(FP))])

for i = 1:40
    disp(['Label ',num2str(i),' mean accuracy: ',num2str(cnt_ac_label(i)/cnt_gt_label(i)),...
        ', sum FP: ',num2str(cnt_FP_label(i))])
end
disp(['total mean accuracy: ',num2str(sum(cnt_ac_label)/sum(cnt_gt_label)),', sum FP: ',num2str(sum(cnt_FP_label))])
