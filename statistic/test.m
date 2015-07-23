% acc = [];
% for thr = 0:0.1:1
%      acc = [acc; thr , (length(find(t_sta(51:100,2)<=thr))+length(find(c_sta(51:100,2)>thr)))/100];
% end
% plot(acc)

data = hdf5read('toyshop.h5','dataset_1');
features_c = data';
label_c = 0;
[m2,N]=size(features_c);
features_3=(features_c-ones(m2,1)*mf)*nrm;
[predicted, accuracy, d_values] = svmpredict(label_c , features_3 , model);