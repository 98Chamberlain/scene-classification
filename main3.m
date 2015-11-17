% close all; clear all;
addpath(genpath('../hex_graph-master'));
addpath('./prob_SVM/');
addpath('../Research_Toolkit/SVM/libsvm-3.20/matlab');
addpath(genpath('./'));

% load the label name
load('./total_label.mat');

% setting the parameter
data_len = 2000;
train_amt = floor(data_len*0.8*0.8);
test_amt = floor(data_len*0.2);

% set hierarchy adjacency matrix
adj_mat = genAdj( 40 , 'exclusive');
adj_mat = setHier( adj_mat , 6 , [13,14,15,16] ); % home
adj_mat = setHier( adj_mat , 7 , [17,18] ); % work_place
adj_mat = setHier( adj_mat , 8 , [19,20] ); % store
adj_mat = setHier( adj_mat , 2 , [6,7,8,21,22] ); % indoor
adj_mat = setHier( adj_mat , 10 , [23,24,25,26,27,28] ); % building
adj_mat = setHier( adj_mat , 11 , [29,30] ); % plants
adj_mat = setHier( adj_mat , 12 , [31:1:35] ); % water
adj_mat = setHier( adj_mat , 4 , [11:1:12 36:1:40] ); % landscape
adj_mat = setHier( adj_mat , 3 , [10,4] ); % outdoor
adj_mat = setHier( adj_mat , 1 , [2,3,9,5] ); % root
E_h = logical(adj_mat);

% set Exclusive adjacency matrix
adj_mat = genAdj( 40 , 'exclusive');
adj_mat = setRela( adj_mat , 6 , 7 ); % work_place - home
adj_mat = setRela( adj_mat , 2 , [5,9] ); % indoor - sports/industrial
adj_mat = setRela( adj_mat , 38 , 39 ); % mountain - ice
adj_mat = setRela( adj_mat , 31 , 35 ); % coast - ocean
adj_mat(1,:) = zeros(1,40);
adj_mat(:,1) = zeros(40,1);
E_e = logical(adj_mat);

tic;
G = hex_setup(E_h, E_e);
toc

% Qualcomm label
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

% children information
children = children_run(adj_mat);

% data pre-process
root_s = [1,2,3,5:1:22,24,25,26,28:1:38,40:1:49,51:1:63,65,66,...
    67,69:1:75,77:1:81,83:1:94,96:1:99,101:1:119,121:1:138,140,142,143,145,...
    147,148,150:1:158,160,162,163,164,166:1:172,174:1:185,189,190,194,195,196,...
    198,199,201,202,205];
use_scene = length(root_s);

% load prob & fc8 data
% prob_data: 205 x 2000 x 205 (feature x data x scene)
% fc8_data : 205 x 2000 x 205 (feature x data x scene)
load('./statistic/feature_data.mat');

% train SVM model for each label
train_data = prob_data(:,:,root_s);
train_data = train_data(:,:);
train_amt = 128;
% [model,mf,nrm] = prob_SVM(train_data',train_amt);
load('./model.mat');

% load new 2000 data
load('./feature_data_2000.mat'); % new 2000 data

test_amt = 400;
acc = [];
FP = [];
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

    disp(['----- now process ',num2str(i),'/',num2str(use_scene),' scene -----']);
    scn_index = root_s(i);
    
    % for data_id = 1:size(prob_data,2)
    for data_id = 1:test_amt
        data = prob_data(:,data_id,scn_index);

%     f = dir(['../h5/ft_multi_label_cross_prob_h5',total_label{scn_index+40,2},'/*.h5']);
%     for h5_idx = 1:length(f)
	
        % calculate the probability of labels
% 		data = hdf5read(['../h5/ft_multi_label_cross_prob_h5',total_label{scn_index+40,2},'/',f(h5_idx).name],'prob');
		sum_prob = sumProb_p(data);
%         sum_prob = data;
        
%         % without relation
%         [M,I] = max(data);
%         if gt_scene(I) == 0
%             result == 0;
%         else
%             result = groundtruth{gt_scene(I)};
%         end
        
        % for test
%         [~,~,p_margin,~] = hex_run(G, sum_prob, 1, false);

%         % use prob feature
%         feature = 1;
%         model = 1;
%         mf = 1;
%         nrm = 1;
%         tic
%         result = searchBest_hr(adj_mat,sum_prob,feature,model,mf,nrm);
%         time = [time ,toc];

		% ----- decision tree begin -----
	    label = 1;
		[loss, gradients, p_margin, p0] = hex_run(G, sum_prob, label, false);
		
		result = [1];
		cont = true;
		parent_list = 1;
		while( cont )
			child_list = [];
			for p = 1:length(parent_list)
				% child_list = [child_list , children{p}];
				child_list = children{parent_list(p)};
			end
			child_list = unique(child_list);
			
			% Use SVM to predict each label
			predict = [];
			for child = 1:length(child_list)
				c = child_list(child);
				[m2,N]=size(data');
				fea_tmp=(data'-ones(m2,1)*mf{c})*nrm{c};
				[predicted, accuracy, d_values] = svmpredict(1 , fea_tmp , model{c});
				predict = [predict,predicted];
			end
			child_list = child_list(find(predict==1));
			
			if ~isempty(child_list)
				result_list = child_list(1);
				% check isvalid
				finished = false;
			else
				finished = true;
				cont = false;
			end
			% begin check
			new_result_list = [];
    		while( ~finished )
				old_result_list = new_result_list;
				for c = 1:length(child_list)
					for r = 1:length(result_list)
						notvalid(r) = (adj_mat( result_list(r),child_list(c) )==1) && (adj_mat( child_list(c),result_list(r) )==1);
					end
					if (sum(notvalid) > 0)
						if p_margin(child_list(c)) > sum(p_margin(result_list))
							result_list = child_list(c);
						end
					else
						result_list = [child_list(c),result_list];
					end
				end
				new_result_list = sort(unique(result_list));
				if isequal(new_result_list,old_result_list)
					finished = true;
					parent_list = new_result_list;
					result = [result,parent_list];
				end
			end
			
			label = new_result_list;
			back_propagate = true;
            
            % back_propagate
            % clamp the potential table and re-run message pass
            num_v = G.num_v;
            c_p_cell = hex_run.assign_potential(G, p_margin);
            c_p_cell = hex_run.clamp_potential(c_p_cell, G, label);
            c_m_cell = hex_run.pass_message(G, c_p_cell);
            [Pr_joint_margin, Z2, ~] = hex_run.marginalize(G, c_m_cell, c_p_cell);
  
            % loss = log(p_margin(label));
            % gradients = Pr_joint_margin ./ Z2 - Pr_margin / Z;
            p_margin = Pr_joint_margin ./ max(Pr_joint_margin);
			% [loss, gradients, p_margin, p0] = hex_run(G, p_margin, label, back_propagate);
		
		end
		
		result_total{data_id} = result;
		% ----- decision tree end -----

        
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
    end

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
save('151110result_decision_400.mat','acc','FP','cnt_ac_label','cnt_gt_label','cnt_FP_label');
