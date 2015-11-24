% load the label name
t = load('total_label.mat');

list = t.total_label(41:245,2);

root_s = [1,2,3,5:1:22,24,25,26,28:1:38,40:1:49,51:1:63,65,66,...
    67,69:1:75,77:1:81,83:1:94,96:1:99,101:1:119,121:1:138,140,142,143,145,...
    147,148,150:1:158,160,162,163,164,166:1:172,174:1:185,189,190,194,195,196,...
    198,199,201,202,205];
use_scene = length(root_s);

train_amt = floor(2000*0.8*0.8);

prob_train = zeros(205,train_amt,use_scene); % 205 feature * 2000 data * 205 scene
fc8_train = zeros(205,train_amt,use_scene);
fc7_train = zeros(4096,train_amt,use_scene);
fc6_train = zeros(4096,train_amt,use_scene);

for i = 1:use_scene
	scene_idx = root_s(i);
	file = dir(['/home/ponu/Documents/h5/PlacesCNN_train_prob_h5/',cell2mat(list(scene_idx)),'/*.h5']);
    % fc8_file = dir(['/home/ponu/Documents/h5/PlacesCNN_fc8_h5/',cell2mat(list(scene_idx)),'/*.h5']);
	% fc7_file = dir(['/home/ponu/Documents/h5/PlacesCNN_fc7_h5/',cell2mat(list(scene_idx)),'/*.h5']);
	% fc6_file = dir(['/home/ponu/Documents/h5/PlacesCNN_fc6_h5/',cell2mat(list(scene_idx)),'/*.h5']);
	
	for j = 1:train_amt
		tmp_data = hdf5read(['/home/ponu/Documents/h5/PlacesCNN_train_prob_h5/',cell2mat(list(scene_idx)),'/',file(j).name],'prob');
		prob_data(:,j,i) = tmp_data;
		tmp_data = hdf5read(['/home/ponu/Documents/h5/PlacesCNN_train_fc8_h5/',cell2mat(list(scene_idx)),'/',file(j).name],'fc8');
		fc8_data(:,j,i) = tmp_data;
		tmp_data = hdf5read(['/home/ponu/Documents/h5/PlacesCNN_train_fc7_h5/',cell2mat(list(scene_idx)),'/',file(j).name],'fc7');
		fc7_data(:,j,i) = tmp_data;
		tmp_data = hdf5read(['/home/ponu/Documents/h5/PlacesCNN_train_fc6_h5/',cell2mat(list(scene_idx)),'/',file(j).name],'fc6');
		fc6_data(:,j,i) = tmp_data;
    end
        
end

save('feature_data_2000.mat','prob_data','fc8_data');
