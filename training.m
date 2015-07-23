function [model , mf , nrm] = training(data,amt)

% data: 205 feature * 128 data * 205 scene
model = {};
mf = {};
nrm = {};

% which scene labels contain
root_s = [1,2,3,5:1:22,24,25,26,28:1:38,40:1:49,51:1:63,65,66,...
    67,69:1:75,77:1:81,83:1:94,96:1:99,101:1:119,121:1:138,140,142,143,145,...
    147,148,150:1:158,160,162,163,164,166:1:172,174:1:185,189,190,194,195,196,...
    198,199,201,202,205];% 1		root
indoor_s = [2,6,9:1:13,16,18,19,21,24,25,28,30,31,34,35,37,38,40,...
    45:1:47,49,51,52,55,65,67,71,73,78,85,86,89,94,96,98,106,108,109,110,111,...
    113:1:115,124,127,128,130,135,137,151,153:1:155,166:1:168,175,176,180,181,...
    183,199];% 2		indoor
outdoor_s= [1,3,5,7,8,14,15,17,22,26,29,32,33,36,41:1:44,48,54,...
    56:1:63,66,69,70,72,77,79,80,81,83,84,88,91:1:93,97,99,101:1:105,107,112,...
    116,117,119,121:1:123,125,126,129,131:1:134,138,140,142,143,145,147,148,...
    150,152,156:1:158,160,162:1:164,169:1:172,174,177,182,184,185,189,190,...
    194:1:196,198,201,202,205,];% 3		outdoor
landscape_s = [15,17,29,36,41,48,54,56,59,60,66,69,70,79,80,81,83,...
    84,91,92,97,101,102,103,104,117,122,123,125,129,132,138,142,145,147,148,...
    150,156,157,158,162,164,169,170,171,174,177,182,184,194,195,198,201,202,...
    205];% 4		landscape
sports_s = [20,75,90,178,179,118,30,31];% 5		sports
home_s = [25,12,21,46,71,65,85,86,94,109,110,113,137];% 6		home
work_place_s = [51,52,94,130,199];% 7		work_place
store_s = [37,19,24,28,35,38,40,47,78,89,135,166,167,176,154,153];% 8		store
industrial_s = [2,11,53,73,74,87,136];% 9		industrial(indoor/outdoor)
building_s = [1,3,5,7,8,14,22,26,32,33,42,43,44,57,58,61,62,63,...
    72,77,88,93,99,105,107,112,116,119,121,126,131,133,134,140,143,152,160,...
    163,172,185,189,190,196];% 10	architecture/building
plants_s = [17,29,54,56,81,92,132,184,195,205,150,79,80];% 11	plants-vegitation
water_s = [48,59,66,91,97,103,117,129,145,148,157,162,164,177,182,201];% 12	water
bedroom_s = [25];% 13	bedroom
dining_room_s = [65,71];% 14	dining_room
living_room_s = [113,137];% 15	living_room
kitchen_s = [85,109,110];% 16	kitchen
conference_room_s = [52];% 17	conference_room
office_s = [130];% 18	office
restaurant_s = [154,153];% 19	restaurant
supermarket_s = [176];% 20	supermarket
aquarium_s = [6];% 21	aquarium
class_room_s = [45,108];% 22	class_room
church_s = [1,22,62,63,126];% 23	church
bridge_s = [32];% 24	bridge
skycraper_s = [172];% 25	skycraper
amusement_park_s = [5];% 26	amusement_park
playground_s = [143];% 27	playground
street_s = [3,26,61,93];% 28	street
forest_s = [17,150,79,80];% 29	forest
garden_s = [29,56,81,92,132,184,195];% 30	garden
coast_s = [48,66,91,103,162,164];% 31	coast
pond_s = [145,177,201];% 32	pond
river_s = [59,148,157];% 33	river
swimming_pool_s = [182];% 34	swimming_pool
ocean_s = [48,66,91,103,129,162,164];% 35	ocean
canyon_s = [41];% 36	canyon
desert_s = [69,70];% 37	desert
ice_s = [60,104,101,102,123,169,170,174];% 38	ice
mountain_s = [122,123];% 39	mountain
sky_s = [171];% 40	sky

% which scene should be labeled
root_d = setdiff(root_s,union(indoor_s,union(industrial_s,union(outdoor_s,sports_s))));
indoor_d = setdiff(indoor_s,union(home_s,union(work_place_s,union(store_s,union(aquarium_s,class_room_s)))));
outdoor_d = setdiff(outdoor_s,union(building_s,union(landscape_s,union(canyon_s,union(desert_s,union(ice_s,union(mountain_s,sky_s)))))));
home_d = setdiff(home_s,union(bedroom_s,union(dining_room_s,union(living_room_s,kitchen_s))));
work_place_d = setdiff(work_place_s,union(conference_room_s,office_s));
store_d = setdiff(store_s,union(restaurant_s,supermarket_s));
building_d = setdiff(building_s,union(church_s,union(bridge_s,union(skycraper_s,union(amusement_park_s,union(playground_s,street_s))))));
landscape_d = setdiff(landscape_s,union(plants_s,water_s));
plants_d = setdiff(plants_s,union(forest_s,garden_s));
water_d = setdiff(water_s,union(coast_s,union(pond_s,union(river_s,union(ocean_s,swimming_pool_s)))));
sports_d = sports_s;
industrial_d = industrial_s;

% set the training label data
root = data(:,1:amt,root_d);
indoor = data(:,1:amt,indoor_d);
outdoor = data(:,1:amt,outdoor_d);
landscape = data(:,1:amt,landscape_d);
sports = data(:,1:amt,sports_d);
home = data(:,1:amt,home_d);
work_place = data(:,1:amt,work_place_d);
store = data(:,1:amt,store_d);
industrial = data(:,1:amt,industrial_d);
building = data(:,1:amt,building_d);
plants = data(:,1:amt,plants_d);
water = data(:,1:amt,water_d);

bedroom = data(:,1:amt,bedroom_s); % 13
dining_room = data(:,1:amt,dining_room_s);
living_room = data(:,1:amt,living_room_s);
kitchen = data(:,1:amt,kitchen_s);% 16	kitchen
conference_room = data(:,1:amt,conference_room_s);% 17	conference_room
office = data(:,1:amt,office_s);% 18	office
restaurant = data(:,1:amt,restaurant_s);% 19	restaurant
supermarket = data(:,1:amt,supermarket_s);% 20	supermarket
aquarium = data(:,1:amt,aquarium_s);% 21	aquarium
class_room = data(:,1:amt,class_room_s);% 22	class_room
church = data(:,1:amt,church_s);% 23	church
bridge = data(:,1:amt,bridge_s);% 24	bridge
skycraper = data(:,1:amt,skycraper_s);% 25	skycraper
amusement_park = data(:,1:amt,amusement_park_s);% 26	amusement_park
playground = data(:,1:amt,playground_s);% 27	playground
street = data(:,1:amt,street_s);% 28	street
forest = data(:,1:amt,forest_s);% 29	forest
garden = data(:,1:amt,garden_s);% 30	garden
coast = data(:,1:amt,coast_s);% 31	coast
pond = data(:,1:amt,pond_s);% 32	pond
river = data(:,1:amt,river_s);% 33	river
swimming_pool = data(:,1:amt,swimming_pool_s);% 34	swimming_pool
ocean = data(:,1:amt,ocean_s);% 35	ocean
canyon = data(:,1:amt,canyon_s);% 36	canyon
desert = data(:,1:amt,desert_s);% 37	desert
ice = data(:,1:amt,ice_s);% 38	ice
mountain = data(:,1:amt,mountain_s);% 39	mountain
sky = data(:,1:amt,sky_s);% 40	sky

% label number
root_l= 1;
indoor_l = 2;
outdoor_l = 3;
landscape_l = 4;
sports_l = 5;
home_l = 6;
work_place_l = 7;
store_l = 8;
industrial_l = 9;
building_l = 10;
plants_l = 11;
water_l = 12;
bedroom_l = 13;
dining_room_l = 14;
living_room_l = 15;
kitchen_l = 16;
conference_room_l = 17;
office_l = 18;
restaurant_l = 19;
supermarket_l = 20;
aquarium_l = 21;
class_room_l = 22;
church_l = 23;
bridge_l = 24;
skycraper_l = 25;
amusement_park_l = 26;
playground_l = 27;
street_l = 28;
forest_l = 29;
garden_l = 30;
coast_l = 31;
pond_l = 32;
river_l = 33;
swimming_pool_l = 34;
ocean_l = 35;
canyon_l = 36;
desert_l = 37;
ice_l = 38;
mountain_l = 39;
sky_l = 40;

% SVM
% [model(1) , mf(1) , nrm(1)] = training_svm(  );
feature = [ indoor(:,:) , home(:,:) , work_place(:,:) , store(:,:) , aquarium(:,:) , class_room(:,:) , bedroom(:,:) , dining_room(:,:) , living_room(:,:) ,...
    kitchen(:,:) , conference_room(:,:) , office(:,:) , restaurant(:,:) , supermarket(:,:) , industrial(:,:)]';
label = [ zeros(1,size(indoor,2)*size(indoor,3)) , ones(1,size(feature,1)-size(indoor,2)*size(indoor,3))]';
[model{indoor_l} , mf{indoor_l} , nrm{indoor_l}] = training_svm( feature , label );

feature = [home(:,:),bedroom(:,:),living_room(:,:),kitchen(:,:)]';
label = [ zeros(1,size(home,2)*size(home,3)) , ones(1,size(feature,1)-size(home,2)*size(home,3))]';
[model{home_l} , mf{home_l} , nrm{home_l}] = training_svm( feature , label );

feature = [work_place(:,:),conference_room(:,:),office(:,:)]';
label = [ zeros(1,size(work_place,2)*size(work_place,3)) , ones(1,size(feature,1)-size(work_place,2)*size(work_place,3))]';
[model{work_place_l} , mf{work_place_l} , nrm{work_place_l}] = training_svm( feature , label );

feature = [store(:,:),restaurant(:,:),supermarket(:,:)]';
label = [ zeros(1,size(store,2)*size(store,3)) , ones(1,size(feature,1)-size(store,2)*size(store,3))]';
[model{store_l} , mf{store_l} , nrm{store_l}] = training_svm( feature , label );

feature = [building(:,:),church(:,:),bridge(:,:),skycraper(:,:),amusement_park(:,:),playground(:,:),street(:,:)]';
label = [ zeros(1,size(building,2)*size(building,3)) , ones(1,size(feature,1)-size(building,2)*size(building,3))]';
[model{building_l} , mf{building_l} , nrm{building_l}] = training_svm( feature , label );

feature = [ landscape(:,:) ];
tmp = data(:,1:amt,plants_s);
feature = [feature,tmp(:,:)];
tmp = data(:,1:amt,water_s);
feature = [feature,tmp(:,:)];
feature = [feature,canyon(:,:),desert(:,:),ice(:,:),mountain(:,:),sky(:,:)]';
label = [ zeros(1,size(landscape,2)*size(landscape,3)) , ones(1,size(feature,1)-size(landscape,2)*size(landscape,3))]';
[model{landscape_l} , mf{landscape_l} , nrm{landscape_l}] = training_svm( feature , label );

feature = [plants(:,:),forest(:,:),garden(:,:)]';
label = [ zeros(1,size(plants,2)*size(plants,3)) , ones(1,size(feature,1)-size(plants,2)*size(plants,3))]';
[model{plants_l} , mf{plants_l} , nrm{plants_l}] = training_svm( feature , label );

feature = [water(:,:),coast(:,:),pond(:,:),river(:,:),ocean(:,:),swimming_pool(:,:)]';
label = [ zeros(1,size(water,2)*size(water,3)) , ones(1,size(feature,1)-size(water,2)*size(water,3))]';
[model{water_l} , mf{water_l} , nrm{water_l}] = training_svm( feature , label );

% extend the model mf nrm to 1*40 cell
model{40} = [];
mf{40} = [];
nrm{40} = [];

end
