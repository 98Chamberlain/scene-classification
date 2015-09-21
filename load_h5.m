% load the label name
t = load('total_label.mat');

list = t.total_label(41:245,2);

prob_data = zeros(205,2000,205); % 205 feature * 2000 data * 205 scene
fc8_data = zeros(205,2000,205);

for i = 1:205
	file = dir(['../images256_h5',cell2mat(list(i)),'/*.h5']);
    fc8_file = dir(['../images256_fc8_h5',cell2mat(list(i)),'/*.h5']);
	
	for j = 1:2000
		tmp_data = hdf5read(['../images256_h5',cell2mat(list(i)),'/',file(j).name],'prob');
		prob_data(:,j,i) = tmp_data;
		tmp_data = hdf5read(['../images256_fc8_h5',cell2mat(list(i)),'/',fc8_file(j).name],'fc8');
		fc8_data(:,j,i) = tmp_data;
    end
        
end

save('feature_data_2000.mat','prob_data','fc8_data');
