function adj_mat = make_SceneMatrix( )
% for qualcomm's label map

% adj_mat = genAdj( 245 , 'related');
adj_mat = genAdj( 40 , 'related');
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

adj_mat = setRela( adj_mat , 6 , 7 ); % work_place - home
adj_mat = setRela( adj_mat , 2 , [5,9] ); % indoor - sports/industrial
adj_mat = setRela( adj_mat , 38 , 39 ); % mountain - ice
adj_mat = setRela( adj_mat , 31 , 35 ); % coast - ocean

% % scene hierachy
% adj_mat = setHier( adj_mat , 1 , add_40([1,2,3,5:1:22,24,25,26,28:1:38,40:1:49,51:1:63,65,66,...
%     67,69:1:75,77:1:81,83:1:94,96:1:99,101:1:119,121:1:138,140,142,143,145,...
%     147,148,150:1:158,160,162,163,164,166:1:172,174:1:185,189,190,194,195,196,...
%     198,199,201,202,205]));% 1		root
% adj_mat = setHier( adj_mat , 2 , add_40([2,6,9:1:13,16,18,19,21,24,25,28,30,31,34,35,37,38,40,...
%     45:1:47,49,51,52,55,65,67,71,73,78,85,86,89,94,96,98,106,108,109,110,111,...
%     113:1:115,124,127,128,130,135,137,151,153:1:155,166:1:168,175,176,180,181,...
%     183,199]));% 2		indoor
% adj_mat = setHier( adj_mat , 3 , add_40([1,3,5,7,8,14,15,17,22,26,29,32,33,36,41:1:44,48,54,...
%     56:1:63,66,69,70,72,77,79,80,81,83,84,88,91:1:93,97,99,101:1:105,107,112,...
%     116,117,119,121:1:123,125,126,129,131:1:134,138,140,142,143,145,147,148,...
%     150,152,156:1:158,160,162:1:164,169:1:172,174,177,182,184,185,189,190,...
%     194:1:196,198,201,202,205,]));% 3		outdoor
% adj_mat = setHier( adj_mat , 4 , add_40([15,17,29,36,41,48,54,56,59,60,66,69,70,79,80,81,83,...
%     84,91,92,97,101,102,103,104,117,122,123,125,129,132,138,142,145,147,148,...
%     150,156,157,158,162,164,169,170,171,174,177,182,184,194,195,198,201,202,...
%     205]));% 4		landscape
% adj_mat = setHier( adj_mat , 5 , add_40([20,75,90,178,179,118,30,31]));% 5		sports
% adj_mat = setHier( adj_mat , 6 , add_40([25,12,21,46,71,65,85,86,94,109,110,113,137]));% 6		home
% adj_mat = setHier( adj_mat , 7 , add_40([51,52,94,130,199]));% 7		work_place
% adj_mat = setHier( adj_mat , 8 , add_40([37,19,24,28,35,38,40,47,78,89,135,166,167,176,154,153]));% 8		store
% adj_mat = setHier( adj_mat , 9 , add_40([2,11,53,73,74,87,136]));% 9		industrial(indoor/outdoor)
% adj_mat = setHier( adj_mat , 10 , add_40([1,3,5,7,8,14,22,26,32,33,42,43,44,57,58,61,62,63,...
%     72,77,88,93,99,105,107,112,116,119,121,126,131,133,134,140,143,152,160,...
%     163,172,185,189,190,196]));% 10	architecture/building
% adj_mat = setHier( adj_mat , 11 , add_40([17,29,54,56,81,92,132,184,195,205,150,79,80]));% 11	plants-vegitation
% adj_mat = setHier( adj_mat , 12 , add_40([48,59,66,91,97,103,117,129,145,148,157,162,164,177,182,201]));% 12	water
% adj_mat = setHier( adj_mat , 13 , add_40([25]));% 13	bedroom
% adj_mat = setHier( adj_mat , 14 , add_40([65,71]));% 14	dining_room
% adj_mat = setHier( adj_mat , 15 , add_40([113,137]));% 15	living_room
% adj_mat = setHier( adj_mat , 16 , add_40([85,109,110]));% 16	kitchen
% adj_mat = setHier( adj_mat , 17 , add_40([52]));% 17	conference_room
% adj_mat = setHier( adj_mat , 18 , add_40([130]));% 18	office
% adj_mat = setHier( adj_mat , 19 , add_40([154,153]));% 19	restaurant
% adj_mat = setHier( adj_mat , 20 , add_40([176]));% 20	supermarket
% adj_mat = setHier( adj_mat , 21 , add_40([6]));% 21	aquarium
% adj_mat = setHier( adj_mat , 22 , add_40([45,108]));% 22	class_room
% adj_mat = setHier( adj_mat , 23 , add_40([1,22,62,63,126]));% 23	church
% adj_mat = setHier( adj_mat , 24 , add_40([32]));% 24	bridge
% adj_mat = setHier( adj_mat , 25 , add_40([172]));% 25	skycraper
% adj_mat = setHier( adj_mat , 26 , add_40([5]));% 26	amusement_park
% adj_mat = setHier( adj_mat , 27 , add_40([143]));% 27	playground
% adj_mat = setHier( adj_mat , 28 , add_40([3,26,61,93]));% 28	street
% adj_mat = setHier( adj_mat , 29 , add_40([17,150,79,80]));% 29	forest
% adj_mat = setHier( adj_mat , 30 , add_40([29,56,81,92,132,184,195]));% 30	garden
% adj_mat = setHier( adj_mat , 31 , add_40([48,66,91,103,162,164]));% 31	coast
% adj_mat = setHier( adj_mat , 32 , add_40([145,177,201]));% 32	pond
% adj_mat = setHier( adj_mat , 33 , add_40([59,148,157]));% 33	river
% adj_mat = setHier( adj_mat , 34 , add_40([182]));% 34	swimming_pool
% adj_mat = setHier( adj_mat , 35 , add_40([48,66,91,103,129,162,164]));% 35	ocean
% adj_mat = setHier( adj_mat , 36 , add_40([41]));% 36	canyon
% adj_mat = setHier( adj_mat , 37 , add_40([69,70]));% 37	desert
% adj_mat = setHier( adj_mat , 38 , add_40([60,104,101,102,123,169,170,174]));% 38	ice
% adj_mat = setHier( adj_mat , 39 , add_40([122,123]));% 39	mountain
% adj_mat = setHier( adj_mat , 40 , add_40([171]));% 40	sky



end

