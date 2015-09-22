function G = list_state(G)
% G = list_state_space(G)
%   List the state space for each clique
%
%   This is for 40 label (temp)
%
%   G is the structure containing the whole HEX Graph

% load groundtruth
load('../gt_scene.mat');
% groundtruth 1*40 cell
% gt_scene 1*205 double

num_c = G.num_c;
c_s_cell = cell(num_c, 1);
margin_cell = cell(num_c, 1);

% TODO: try to make it automatic
for c = 1:num_c
    
s_mat = zeros(45 , 40);
for i = 1:40
    s_mat(i,groundtruth{i}) = 1;
end
s_mat(41,[1,2,6,7]) = 1;
s_mat(42,[1,3,4,38,39]) = 1;
s_mat(43,[1,3,4,12,31,35]) = 1;
s_mat(44,[1,2,9]) = 1;
s_mat(45,[1,2,5]) = 1;

mar = cell(40,1);
for i = 1:40
    mar{i} = find(s_mat(:,i)==1);
end

c_s_cell{c} = s_mat;
margin_cell{c} = mar;

end

G.c_s_cell = c_s_cell;
G.margin_cell = margin_cell;