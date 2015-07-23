% close all; clear all;

% load the label name
t = load('total_label.mat');

% setting the parameter
train_amt = 100;
data_len = 128;

% Qualcomm label
% adj_mat = xlsread('scene_matrix.xlsx',1);
adj_mat = make_SceneMatrix();

% read prob form .h5 file
load('./statistic/feature_data.mat');
fc8_testing_data = fc8_data(:,train_amt+1:data_len,:);
fc8_testing_data = fc8_testing_data(:,:);
prob_testing_data = prob_data(:,train_amt+1:data_len,:);
prob_testing_data = prob_testing_data(:,:);

% set ground truth
% groundtruth = {[1],[1,2],[1,3],[1,3,4],[1,5],[1,2,6],[1,2,7],[1,2,8],[1,2,9],[1,3,10],[1,3,4,11],[1,3,4,12],...
%     [1,2,6,13],[1,2,6,14],[1,2,6,15],[1,2,6,16],[1,2,7,17],[1,2,7,18],[1,2,8,19],[1,2,8,20],[1,2,21],[1,2,22],...
%     [1,3,10,23],[1,3,10,24],[1,3,10,25],[1,3,10,26],[1,3,10,27],[1,3,10,28],[1,3,4,11,29],[1,3,4,11,30],[1,3,4,12,31],...
%     [1,3,4,12,32],[1,3,4,12,33],[1,3,4,12,34],[1,3,4,12,35],[1,3,36],[1,3,37],[1,3,38],[1,3,39],[1,3,40]};

load('./gt_scene.mat'); % gt_scene , groundtruth

% % training
[model_prob , mf_prob , nrm_prob ] = training(prob_data,train_amt);
% [model_fc8 , mf_fc8 , nrm_fc8 ] = training(fc8_data,train_amt);
% [model_cb , mf_cb , nrm_cb] = training([fc8_data;prob_data],train_amt);

acc = [];
FP = [];
FN = [];
TP = [];
TN = [];
scene_acc = zeros(205,1);
scene_FP = zeros(205,1);
time = [];
for i = 1:size(prob_testing_data,2)
% for i = (123-1)*28+1:123*28

% data = hdf5read(['./statistic/toyshop/',d(i).name],'dataset_1');
    scn_index = ceil(i/28);
    if gt_scene(scn_index) ~= 0
        
        % calculate the probability of labels
        sum_prob = sumProb_p(prob_testing_data(:,i));
        
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
        feature = prob_testing_data(:,i);
        tic
        result = searchBest_hr(adj_mat,sum_prob,feature,model_prob,mf_prob,nrm_prob);
        time = [time ,toc];
              
        % use fc8 feature
        feature = fc8_testing_data(:,i);
        result = searchBest_hr(adj_mat,sum_prob,feature,model_fc8,mf_fc8,nrm_fc8);

%         % use prob+fc8 feature
%         feature = [fc8_testing_data(:,i);prob_testing_data(:,i)];
%         tic
%         result = searchBest_hr(adj_mat,sum_prob,feature,model_cb,mf_cb,nrm_cb);
%         time = [time ,toc];
        
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
%         acc = [acc,length(intersect(result,groundtruth{gt_scene(scn_index)}))/length(groundtruth{gt_scene(scn_index)})];
%         scene_acc(scn_index) = scene_acc(scn_index) + length(intersect(result,groundtruth{gt_scene(scn_index)}))/length(groundtruth{gt_scene(scn_index)});
%         FP = [FP,(length(result)-length(intersect(result,groundtruth{gt_scene(scn_index)})))/length(groundtruth{gt_scene(scn_index)})];
%         FN = [FN,(length(groundtruth{gt_scene(scn_index)})-length(intersect(result,groundtruth{gt_scene(scn_index)})))/length(groundtruth{gt_scene(scn_index)})];
%         scene_FP(scn_index) = scene_FP(scn_index) + (length(result)-length(intersect(result,groundtruth{gt_scene(scn_index)})))/length(groundtruth{gt_scene(scn_index)});
        
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

        display(['the result is: ' , t.total_label(result,2)']);
        
    end
        
end