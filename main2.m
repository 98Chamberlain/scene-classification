% close all; clear all;
addpath('./prob_SVM/');

% load the label name
t = load('./total_label.mat');

% setting the parameter
train_amt = 100;
data_len = 128;

% Qualcomm label
% adj_mat = xlsread('scene_matrix.xlsx',1);
adj_mat = make_SceneMatrix();

% read prob form .h5 file
load('./statistic/feature_data.mat');
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

% other relation
groundtruth{41} = [1,2,6,7];
gt_scene(94) = 41;
groundtruth{42} = [1,3,4,38,39];
gt_scene(123) = 42;
groundtruth{43} = [1,3,4,12,31,35];
gt_scene([48,66,91,103,162,164]) = 43;
groundtruth{44} = [1,2,9];
gt_scene([2,11,73]) = 44;
groundtruth{45} = [1,2,5];
gt_scene([30,31]) = 45;

% data pre-process
root_s = [1,2,3,5:1:22,24,25,26,28:1:38,40:1:49,51:1:63,65,66,...
    67,69:1:75,77:1:81,83:1:94,96:1:99,101:1:119,121:1:138,140,142,143,145,...
    147,148,150:1:158,160,162,163,164,166:1:172,174:1:185,189,190,194,195,196,...
    198,199,201,202,205];
prob_train_data = prob_data(:,1:train_amt,root_s);
prob_train_data = prob_train_data(:,:);
prob_test_data = prob_data(:,train_amt+1:data_len,root_s);
prob_test_data = prob_test_data(:,:);

% % sparse-coding representation
[ training_SR , testing_SR , D ] = sparse_coding( prob_train_data , prob_test_data );

% % training
[model,mf,nrm] = prob_SVM( training_SR );

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
for i = 1:size(prob_test_data,2)
    
    scn_index = root_s(ceil(i/28));
    
    feature = prob_test_data(:,i)';
    [m2,~]=size(feature);
    feature_t =(feature - ones(m2,1)*mf)*nrm;
    predicted = svmpredict(1 , feature_t , model);
    
    result = groundtruth{predicted};

    
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
        
%         % use prob feature
%         feature = prob_test_data(:,i);
%         tic
%         result = searchBest_hr(adj_mat,sum_prob,feature,model,mf,nrm);
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

% ------- Brute force -------
% result = searchBest_bf(adj_mat,sum_prob);

% tic;
% result = searchBest_hr(adj_mat,sum_prob);
% result = searchBest_hr(adj_mat,sum_prob,feature,model,mf,nrm);
% toc

        display(['the result is: ' , t.total_label(result,2)']);
        
end