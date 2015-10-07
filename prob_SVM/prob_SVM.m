function [model,mf,nrm] = prob_SVM( training_SR,train_amt )

% load('./statistic/feature_data.mat');
% prob_data 205*128*205
% fc8_data

nScene = 205;
nLabel = 40;
%train_amt = 100;

load('./gt_scene.mat');
% groundtruth 1*40 cell
% gt_scene 1*205 double

% gt = 205 * 40
gt = zeros(nScene,nLabel);
for i = 1:nScene
    if i == 94
        gt(i,[1,2,6,7]) = 1;
    elseif i == 123
        gt(i,[1,3,4,38,39]) = 1;
    elseif (sum([48,66,91,103,162,164] == i) >= 1)
        gt(i,[1,3,4,12,31,35]) = 1;
    elseif (sum([2,11,73] == i) >= 1)
        gt(i,[1,2,9]) = 1;
    elseif (sum([30,31] == i) >= 1)
        gt(i,[1,2,5]) = 1;
    elseif gt_scene(i)~=0
        gt(i,groundtruth{gt_scene(i)}) = 1;
    end
end

root_s = [1,2,3,5:1:22,24,25,26,28:1:38,40:1:49,51:1:63,65,66,...
    67,69:1:75,77:1:81,83:1:94,96:1:99,101:1:119,121:1:138,140,142,143,145,...
    147,148,150:1:158,160,162,163,164,166:1:172,174:1:185,189,190,194,195,196,...
    198,199,201,202,205];

% training_SR : m*p
% m : number of training data
% p : dimension of sparse representation

% ----- Training -----
addpath('../Research_Toolkit/SVM/libsvm-3.20/matlab');

model{1,40} = [];
mf{1,40} = [];
nrm{1,40} = [];
tmp = repmat(root_s,[train_amt,1]);
lb_tmp = tmp(:);

features = training_SR;
for i = 1:nLabel
    label = gt( lb_tmp , i);
    [model{i},mf{i},nrm{i}] = training_svm( features , label );
end

end