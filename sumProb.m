function sum_prob = sumProb(prob)

sum_prob(66,1)=0;

% Indoor
sum_prob(29) = sum(prob([51,52,130]));
sum_prob(28) = sum(prob([96]));
sum_prob(26) = sum(prob([11,73]));
sum_prob(25) = sum(prob([55,114,151,199]));
sum_prob(23) = sum(prob([34]));
sum_prob(21) = sum(prob([49]));
sum_prob(20) = sum(prob([49 34 85]));
sum_prob(19) = sum(prob([2 181 192]));
sum_prob(18) = sum(prob([30 31 118]));
sum_prob(17) = sum(prob([6 16 86]));
sum_prob(16) = sum(prob([37 24 28 35 40 47 89 100 166 176]));
sum_prob(15) = sum(prob([18 19 38 50 78 153 154]));
sum_prob(14) = sum(prob([12 21 25 65 68 98 113 128 137 109 110 135 168]));
sum_prob(13) = sum(prob([146]));
sum_prob(12) = sum(prob([127]));
sum_prob(11) = sum(prob([106 127 146]));
sum_prob(10) = sum(prob([45 108]));
sum_prob(9) = sum(prob([9 10 13 124 180]));
sum_prob(8) = sum(prob([55 114 151 199 11 73 96 51 52 130 183]));
sum_prob(7) = sum(prob([2 181 192 49 34 85]));
sum_prob(6) = sum(prob([6 16 86 30 31 118]));
sum_prob(5) = sum(prob([18 19 38 50 78 153 154 37 24 28 35 40 47 89 100 166 176]));
sum_prob(4) = sum(prob([12 21 25 65 68 98 113 128 137 46 71 94 109 110 111 135 168 175]));
sum_prob(3) = sum(prob([9 10 13 124 180 127 146 106 45 108]));
sum_prob(2) = sum(prob([18,19,38,50,78,153,154,37,24,28,35,40,47,89,100,...
    166,176,9,10,13,124,180,127,146,106,45,108,12,21,25,65,68,98,113,128,...
    137,46,71,94,109,110,111,135,168,175,6,16,86,30,31,118,2,181,192,49,34,...
    85,55,114,151,199,11,73,96,51,52,130,183]));



sum_prob(1) = sum_prob(2)+sum_prob(30)+sum_prob(45);

% normalize
sum_prob = sum_prob./sum_prob(1);


end
