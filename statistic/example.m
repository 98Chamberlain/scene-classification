cont = [];
stop = [];
store_list = [77,59,64,68,75,78,80,87,118,129,175,206,207,216,194,193];

b = dir('./bookstore/*.h5');
b_len = length(b);
b_max = zeros(1,b_len);
b_data = zeros(205,b_len);

c = dir('./candy_store/*.h5');
c_len = length(c);
c_max = zeros(1,c_len);
c_data = zeros(205,c_len);

t = dir('./toyshop/*.h5');
t_len = length(t);
t_max = zeros(1,t_len);
t_data = zeros(205,t_len);

b_sta = [];
for i = 1:b_len
    % read prob form .h5 file
    data = hdf5read(['./bookstore/',b(i).name],'dataset_1');

    % calculate the probability of labels
    sum_prob = sumProb_p(data);
    [m , ind] = max(data(:));
    b_max(1,i) = ind;
%     if (ind == 28)
%         cont = [cont, sum_prob(68)/sum_prob(8) ];
%     end
    
    b_sta = [b_sta;ind,sum_prob(68)/sum_prob(8)];
    b_data(:,i) = data;
end

c_sta = [];
for i = 1:c_len
    % read prob form .h5 file
    data = hdf5read(['./candy_store/',c(i).name],'dataset_1');

    % calculate the probability of labels
    sum_prob = sumProb_p(data);
    [m , ind] = max(data(:));
    c_max(1,i) = ind;
%     if (ind == 40)
%         cont = [cont, sum_prob(80)/sum_prob(8) ];
%     end
    cont = [cont, sum_prob(80)/sum_prob(8) ];
    
    c_sta = [c_sta;ind,sum_prob(80)/sum_prob(8)];
    c_data(:,i) = data;
end

t_sta = [];
for i = 1:t_len
    % read prob form .h5 file
    data = hdf5read(['./toyshop/',t(i).name],'dataset_1');

    % calculate the probability of labels
    sum_prob = sumProb_p(data);
    [m , ind] = max(data(:));
    t_max(i) = ind;
    
    tmp = sum_prob(store_list)./sum_prob(8);
    stop = [stop, max(tmp) ];
    
    t_sta = [t_sta;ind,max(tmp)];
    t_data(:,i) = data;
end    

plot(cont,0.7*ones(1,length(cont)),'LineStyle','none','marker','o','MarkerEdgeColor','g');
hold on;
plot(stop,0.3*ones(1,length(stop)),'LineStyle','none','marker','o','MarkerEdgeColor','r');
axis([0,1,0,1]);

% binary SVM
addpath('../../Machine Learning/SVM/libsvm-3.20/matlab');

features_a = [c_data(:,1:50),t_data(:,1:50)]';
label_a = [ones(1,50),zeros(1,50)]';

% features_b = [c_data(:,51:100),t_data(:,51:100)]';
% label_b = [ones(1,50),zeros(1,50)]';
features_b = [t_data(:,51:100)]';
label_b = [zeros(1,50)]';

features_c = b_data';
label_c = ones(1,b_len)';

% scaling
[m,N]=size(features_a);
[m1,N]=size(features_b);
mf=mean(features_a);
nrm=diag(1./std(features_a,1));
features_1=(features_a-ones(m,1)*mf)*nrm;
features_2=(features_b-ones(m1,1)*mf)*nrm;
% SVM
model = svmtrain(label_a , features_1);
% test for test data 1
[predicted, accuracy, d_values] = svmpredict(label_b , features_2 , model);

% test for test data 2
[m2,N]=size(features_c);
features_3=(features_c-ones(m2,1)*mf)*nrm;
[predicted, accuracy, d_values] = svmpredict(label_c , features_3 , model);


% store(14)         8
% b_bakery_shop     77
% b_bar             59
% b_beauty_salon    64
% b_bookstore       68
% b_butchers_shop   75
% c_cafeteria       78
% c_candy_store     80
% c_clothing_store  87
% f_food_court      118
% g_gift_shop       129
% p_pantry          175
% s_shoe_shop       206
% s_shopfront       207
% s_supermarket     216
% r_restaurant_kitchen 194
% r_restaurant         193